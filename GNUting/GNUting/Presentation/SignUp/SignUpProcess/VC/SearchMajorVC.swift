//
//  SearchMajorVC.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

import UIKit
protocol SearchMajorSelectCellDelegate : AnyObject{
    func sendSeleceted(major: String)
}
class SearchMajorVC: UIViewController {
    var searchMajorSelectCellDelegate: SearchMajorSelectCellDelegate?
    
    var searchResultList: [SearchMajorModelResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    private lazy var naviBorderView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorderImage")
        return imageView
    }()
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "학과를 검색하세요."
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    private lazy var searchResultTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(MajorSearchTableViewCell.self, forCellReuseIdentifier: MajorSearchTableViewCell.identi)
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        addSubViews()
        setAutoLayout()
        searchConfigure()
        setNavigation()
        hideKeyboardWhenTappedAround()
    }
    
}
extension SearchMajorVC {
    
    private func addSubViews() {
        self.view.addSubview(searchResultTableView)
    }
    private func setAutoLayout(){
        searchResultTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    private func searchConfigure(){
        navigationItem.searchController = searchController
    }
    private func setNavigation(){
        self.navigationItem.titleView = naviBorderView
    }
}

extension SearchMajorVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        APIGetManager.shared.searchMajor(major: text) { response, statusCode in
            print("searchMajor statusCode : \(statusCode)")
            guard let result = response?.result else { return }
            
            self.searchResultList = result
        }
        
        
    }
}
extension SearchMajorVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchMajorSelectCellDelegate?.sendSeleceted(major: searchResultList[indexPath.row].name)
        dismiss(animated: true)
    }
}
extension SearchMajorVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorSearchTableViewCell.identi, for: indexPath) as? MajorSearchTableViewCell else { return UITableViewCell() }
        cell.setCell(model: searchResultList[indexPath.row])
        return cell
    }
    
    
}

