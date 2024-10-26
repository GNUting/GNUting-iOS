//
//  DateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

// MARK: - 과팅 게시판 리스트 ViewController

import UIKit

final class DateBoardListVC: BaseViewController {
    
    // MARK: - Properties
    
    private var page = 1
    private var isFetching = true
    private var dateBoardListData: [BoardResult] = [] {
        didSet {
            noDataScreenView.isHidden = dateBoardListData.isEmpty ? false : true
            self.dateBoardTableView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    let noticeStackView = NoticeStackView(text: "부적절한 게시글을 작성할 경우, 앱 이용이 제한될 수 있습니다.")
    
    private lazy var noDataScreenView: NoDataScreenView = {
        let view = NoDataScreenView()
        view.isHidden = true
        view.setLabel(text: "게시글이 비어있습니다.", range: "")
        
        return view
    }()
    
    private lazy var dateBoardTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BoardListTableViewCell.self, forCellReuseIdentifier: BoardListTableViewCell.identi)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var writeTextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "WritePostImage"), for: .normal)
        button.addTarget(self, action: #selector(tapWriteTextButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBoardDataAPI(page: page)
        addSubViews()
        setAutoLayout()
        setNavigationBar(title: "과팅 게시판")
    }
}

// MARK: - Layout Helpers

extension DateBoardListVC {
    private func addSubViews() {
        view.addSubViews([noticeStackView, dateBoardTableView, noDataScreenView, writeTextButton])
    }
    
    private func setAutoLayout() {
        noticeStackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(27)
            make.left.right.equalToSuperview().inset(25)
        }
        
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(noticeStackView.snp.bottom).offset(28)
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
}

// MARK: - API

extension DateBoardListVC {
    private func getBoardDataAPI(page: Int) {
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

// MARK: - UITableView

extension DateBoardListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateBoardListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let boardListCell = tableView.dequeueReusableCell(withIdentifier: BoardListTableViewCell.identi, for: indexPath) as? BoardListTableViewCell else {return BoardListTableViewCell()}
        boardListCell.setCell(model: dateBoardListData[indexPath.row])
        
        return boardListCell
    }
}

// MARK: - Delegate

extension DateBoardListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.boardID = dateBoardListData[indexPath.row].id
        vc.setPushBoardList()
        tableView.deselectRow(at: indexPath, animated: true)
        
        if dateBoardListData[indexPath.row].status == "OPEN" {
            pushViewController(viewController: vc)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height) {
            if !isFetching {
                page += 1
                getBoardDataAPI(page: page)
            }
        }
    }
}
