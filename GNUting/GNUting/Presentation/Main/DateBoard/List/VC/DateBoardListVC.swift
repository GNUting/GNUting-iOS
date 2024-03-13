//
//  DateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardListVC: UIViewController {
    
    // MARK: - Properties
    
    var page = 1
    var isFetching : Bool = true
    var dateBoardListData: [BoardResult] = [] {
        didSet{
            DispatchQueue.main.async {
                self.dateBoardTableView.reloadData()
            }
        }
    }
  
    private lazy var dateBoardTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(DateBoardListTableViewCell.self, forCellReuseIdentifier: DateBoardListTableViewCell.identi)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identi)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
                                                       
        return tableView
    }()
    
    private lazy var writeTextButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("글쓰기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 16)!]))
        config.image = UIImage(named: "Edit")
        config.baseForegroundColor = .black
        config.imagePlacement = .leading
        config.imagePadding = 5
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 20
        button.addTarget(self, action: #selector(tapWriteTextButton), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
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
        view.addSubViews([dateBoardTableView,writeTextButton])
    }
    private func setAutoLayout(){
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        writeTextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    private func setNavigationBar(){
        setNavigationBar(title: "과팅 게시판")
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SearchImg"), style: .plain, target: self, action: #selector(tapSearchButton))
        rightBarButtonItem.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension DateBoardListVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
//        vc.setTitleLabel(title: sampeleDetailDateBoardData[indexPath.row].title)
        
        self.navigationController?.pushViewController(vc, animated: true)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return dateBoardListData.count
        } else if section == 1 && isFetching {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let boardListCell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return DateBoardListTableViewCell()}
        
        if indexPath.section == 0{
            boardListCell.setCell(model: dateBoardListData[indexPath.row])
            
            return boardListCell
        } else {
            guard let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identi, for: indexPath) as? LoadingTableViewCell else {return UITableViewCell()}
            loadingCell.start()
            return loadingCell
        }
        
        
        
    }
}
extension DateBoardListVC {
    @objc private func tapSearchButton(){
        let vc = UINavigationController.init(rootViewController: BoardTextSearchVC())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @objc private func tapWriteTextButton(){
        let vc = WriteUpdateDateBoardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Get Data
extension DateBoardListVC  {
    private func getBoardData(page: Int) {
        self.isFetching = true
        APIGetManager.shared.getBoardText(page: page, size: 15) { boardData in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                guard let boardDataList = boardData?.result else { return}
                self.dateBoardListData.append(contentsOf: boardDataList)
                self.isFetching = false
            }
            
        }
    }
}
