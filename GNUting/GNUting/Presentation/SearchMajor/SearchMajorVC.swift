//
//  SearchMajorVC.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

// MARK: - 학과 검색 VC

import UIKit

// MARK: - protocol

protocol SearchMajorSelectCellDelegate: AnyObject {
    func sendSeleceted(major: String)
}

final class SearchMajorVC: BaseViewController {
    
    // MARK: - Properties
    weak var searchMajorSelectCellDelegate: SearchMajorSelectCellDelegate?
    var searchResultList: [SearchMajorModelResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
        }
    }
    
    // MARK: - SubViews
    
    private lazy var naviBorderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorderImage")
        
        return imageView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "학과를 검색하세요."
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    private lazy var searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identi)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        setNavigationitem()
    }
}

extension SearchMajorVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        self.view.addSubview(searchResultTableView)
    }
    
    private func setAutoLayout() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
    // MARK: - setView
    
    private func setNavigationitem() {
        navigationItem.searchController = searchController
        self.navigationItem.titleView = naviBorderView
    }
    
    // MARK: - API
    
    private func searchMajorAPI(text: String) {
        APIGetManager.shared.searchMajor(major: text) { response, statusCode in
            print("searchMajor statusCode : \(statusCode)")
            guard let result = response?.result else { return }
            self.searchResultList = result
        }
    }
}

// MARK: - UITableVIew

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identi, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.setCell(model: searchResultList[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - Delegate

extension SearchMajorVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        searchMajorAPI(text: text)
    }
}
