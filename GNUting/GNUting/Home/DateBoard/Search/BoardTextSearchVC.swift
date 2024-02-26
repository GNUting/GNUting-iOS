//
//  BoardTextSearchVC.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class BoardTextSearchVC: UIViewController{
    let sampeleDetailDateBoardData : [DetailDateBoardModel] = [DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "2:2과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "22학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "23학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "21학번"),DetailDateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.", studentID: "24학번")]
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: BoardTextSearchResultVC())
        searchController.searchResultsUpdater = self // 검새 결과 업데이트 담당
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "도시 또는 우편번호 검색"
        return searchController
    }()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchConfigure()
        setNavigation()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
extension BoardTextSearchVC {
  
    private func searchConfigure(){
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    private func setNavigation(){
        let dismissButton = UIBarButtonItem(image: UIImage(named: "DissmissImg"), style: .plain, target: self, action: #selector(tapDissmisButton))
        dismissButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.leftBarButtonItem = dismissButton
    }
}

extension BoardTextSearchVC : UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        let titleArr = sampeleDetailDateBoardData.map{$0.title}
        var filterArr : [DetailDateBoardModel] = []
        for (idx,title) in titleArr.enumerated(){
            if title.contains(text){
                filterArr.append(sampeleDetailDateBoardData[idx])
            }
        }
        if let resultController = searchController.searchResultsController as? BoardTextSearchResultVC {
            resultController.filterData = filterArr
            resultController.tableViewReload()
        }
    }
}
