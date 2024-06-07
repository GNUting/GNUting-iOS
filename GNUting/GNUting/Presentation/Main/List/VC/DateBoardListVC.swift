//
//  DateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardListVC: BaseViewController {
    
    // MARK: - Properties
    
    var page = 1
    var isFetching : Bool = true
    var dateBoardListData: [BoardResult] = [] {
        didSet{
            
            if dateBoardListData.count == 0 {
                noDataScreenView.isHidden = false
            } else {
                noDataScreenView.isHidden = true
            }
            self.dateBoardTableView.reloadData()
         
        }
    }
    private lazy var noticeStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNoticeStackView))
        stackView.addGestureRecognizer(tapGesture)
        return stackView
    }()
    private lazy var borderView = BorderView()
    private lazy var noticeImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "LoudspeakerImg")
        return imageView
    }()
    
    private lazy var noticeLabel: BasePaddingLabel = {
       let label = BasePaddingLabel(padding: UIEdgeInsets(top: 9, left: 15, bottom: 9, right: 15))
        label.text = "부적절한 게시글을 작성할 경우, 앱 이용이 제한될 수 있습니다."
        label.font = Pretendard.regular(size: 11)
        label.textColor = UIColor(hexCode: "4F4F4F")
        label.backgroundColor = UIColor(named: "BackGroundColor")
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var noDataScreenView: NoDataScreenView = {
       let view = NoDataScreenView()
        view.isHidden = true
        view.setLabel(text: "게시글이 비어있습니다.", range: "")
        return view
    }()
    
    private lazy var dateBoardTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(DateBoardListTableViewCell.self, forCellReuseIdentifier: DateBoardListTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false

        return tableView
    }()
    
    private lazy var writeTextButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "WritePostImage"), for: .normal)
        button.addTarget(self, action: #selector(tapWriteTextButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBoardData(page: page)
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}
extension DateBoardListVC{
    private func addSubViews() {
        view.addSubViews([noticeStackView,borderView,dateBoardTableView,noDataScreenView,writeTextButton])
        noticeStackView.addStackSubViews([noticeImageView,noticeLabel])
    }
    private func setAutoLayout(){
        
        noticeStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(28)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-28)
           
        }
        
        noticeImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(noticeStackView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        writeTextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            make.right.equalToSuperview().offset(-25)
            make.height.width.equalTo(60)
        }
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    private func setNavigationBar(){
        setNavigationBar(title: "과팅 게시판")
        
    }
}

extension DateBoardListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.boardID = dateBoardListData[indexPath.row].id
        vc.setPushBoardList()
        tableView.deselectRow(at: indexPath, animated: true)
        if dateBoardListData[indexPath.row].status == "OPEN" {
            pushViewContoller(viewController: vc)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height) {
            if !isFetching {
                page += 1
                getBoardData(page: page)
            }
        }
    }
}

extension DateBoardListVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateBoardListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let boardListCell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return DateBoardListTableViewCell()}
        boardListCell.boardListSetCell(model: dateBoardListData[indexPath.row])
        
        
        return boardListCell
    }
}

// MARK: - Get Data
extension DateBoardListVC  {
    private func getBoardData(page: Int) {
        self.isFetching = true
        
        APIGetManager.shared.getBoardText(page: page, size: 15) { boardData,response  in
            self.errorHandling(response: response)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let boardDataList = boardData?.result else { return}
                self.dateBoardListData.append(contentsOf: boardDataList)
                self.isFetching = false
            }
            
        }
    }
}

extension DateBoardListVC {
    @objc private func tapNoticeStackView() {
    
    }
}
