//
//  BoardTextSearchResultVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class BoardTextSearchResultVC: UIViewController {
    var filterData : [DetailDateBoardModel] = []
    private lazy var searchResultTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(DateBoardListTableViewCell.self, forCellReuseIdentifier: DateBoardListTableViewCell.identi)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        setTableView()
        
    }

}
extension BoardTextSearchResultVC{
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
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    
}
extension BoardTextSearchResultVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateBoardListTableViewCell.identi, for: indexPath) as? DateBoardListTableViewCell else {return UITableViewCell()}
//        cell.setCell(model: filterData[indexPath.row])
        return cell
    }
    
    
}
extension BoardTextSearchResultVC{
    public func tableViewReload(){
        searchResultTableView.reloadData()
    }
}
