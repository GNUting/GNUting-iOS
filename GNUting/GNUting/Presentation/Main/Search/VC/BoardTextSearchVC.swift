//
//  BoardTextSearchVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class BoardTextSearchVC: UIViewController{
    var isFetching : Bool = false
    var page = 0
    var searchText = ""
    
    var searchResultList: [SearchResultContent] = [] {
        didSet{
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "게시글/학과를 검색하세요."
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    private lazy var searchResultTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(DateBoardListTableViewCell.self, forCellReuseIdentifier: DateBoardListTableViewCell.identi)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        searchConfigure()
        setNavigation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
extension BoardTextSearchVC {
    private func setTableView(){
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
    }
    private func addSubViews() {
        self.view.addSubview(searchResultTableView)
    }
    private func setAutoLayout(){
        searchResultTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    private func searchConfigure(){
        navigationItem.searchController = searchController
    }
    private func setNavigation(){
        let dismissButton = UIBarButtonItem(image: UIImage(named: "DissmissImg"), style: .plain, target: self, action: #selector(tapDissmisButton))
        dismissButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.leftBarButtonItem = dismissButton
    }
}

extension BoardTextSearchVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        searchText = text

        APIGetManager.shared.getSearchBoardText(searchText: text, page: 0) { searchDataInfo in
            guard let searchResultData = searchDataInfo?.result.content else { return }
            self.page = 0
            self.searchResultList = searchResultData
        }
    }
}

extension BoardTextSearchVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height) {
            if !isFetching {
                page += 1
                self.isFetching = true
                APIGetManager.shared.getSearchBoardText(searchText: searchText, page: page) { searchDataInfo in
                    guard let searchResultData = searchDataInfo?.result.content else { return }
                    self.searchResultList.append(contentsOf: searchResultData)
                    if searchResultData.count == 0 {
                        self.isFetching = true
                    }else {
                        self.isFetching = false
                    }
                    
                }
            }
        }
    }
}


extension BoardTextSearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let boardListCell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return DateBoardListTableViewCell()}
        boardListCell.searchSetCell(model: searchResultList[indexPath.row])
        return boardListCell
    }
    
    
}
