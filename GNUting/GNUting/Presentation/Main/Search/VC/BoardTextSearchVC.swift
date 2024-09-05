//
//  BoardTextSearchVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class BoardTextSearchVC: BaseViewController {
    
    // MARK: - Properties
    
    var isFetching : Bool = true
    var page = 0
    var searchText = ""
    var searchResultList: [SearchResultContent] = [] {
        didSet {
            noDataScreenView.isHidden = searchResultList.count == 0 ? false : true
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    
    // MARK: - SubViews
    
    private lazy var noDataScreenView: NoDataScreenView = {
        let view = NoDataScreenView()
        view.setLabel(text: "검색 결과가 없습니다. ", range: "")
        
        return view
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "게시글/학과를 검색하세요."
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BoardListTableViewCell.self, forCellReuseIdentifier: BoardListTableViewCell.identi)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        setNavigationItem()
    }
}
extension BoardTextSearchVC {
    private func addSubViews() {
        self.view.addSubViews([searchResultTableView, noDataScreenView])
    }
    
    private func setAutoLayout() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        noDataScreenView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setNavigationItem() {
        let dismissButton = UIBarButtonItem(image: UIImage(named: "DissmissImg"), style: .plain, target: self, action: #selector(tapDissmisButton))
        
        dismissButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.leftBarButtonItem = dismissButton
        self.navigationItem.title = "게시글 검색"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : Pretendard.semiBold(size: 18) ?? .boldSystemFont(ofSize: 18)]
        self.navigationItem.searchController = searchController
    }
}

// MARK: - API

extension BoardTextSearchVC {
    private func getSearchBoardTextAPI(searchText: String,page: Int, initialState: Bool) {
        APIGetManager.shared.getSearchBoardText(searchText: searchText, page: page) { searchDataInfo,response  in
            guard let searchResultData = searchDataInfo?.result.content else { return }
            self.errorHandling(response: response)
            
            if initialState {
                self.page = 0
                self.searchResultList = searchResultData
            } else {
                self.searchResultList.append(contentsOf: searchResultData)
                self.isFetching = searchResultData.count == 0 ? true : false
            }
            
        }
    }
}

// MARK: - UITalbeView

extension BoardTextSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let boardListCell = tableView.dequeueReusableCell(withIdentifier: BoardListTableViewCell.identi, for: indexPath) as? BoardListTableViewCell else {return BoardListTableViewCell()}
        boardListCell.setCell(model: searchResultList[indexPath.row])
        
        return boardListCell
    }
}

// MARK: - Delegate

extension BoardTextSearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        self.searchText = text
        
        getSearchBoardTextAPI(searchText: text,page: 0, initialState: true)
    }
}

extension BoardTextSearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailDateBoardVC()
        vc.boardID = searchResultList[indexPath.row].boardID
        vc.setPushBoardList()
        tableView.deselectRow(at: indexPath, animated: true)
        
        pushViewContoller(viewController: vc)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height) {
            if !isFetching {
                page += 1
                self.isFetching = true
                getSearchBoardTextAPI(searchText: self.searchText, page: page, initialState: false)
            }
        }
    }
}
