//
//  SearchAddMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit
// 추후 컴포지셔널 뷰사용
class SearchAddMemberVC: UIViewController {
    private lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        return button
    }()
    private lazy var memberAddButton : UIButton = {
        let button = UIButton()
        button.setTitle("멤버 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "SecondaryColor")
        button.titleLabel?.font = UIFont(name: Pretendard.Bold.rawValue, size: 14)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController()
        return searchController
    }()
    private lazy var addMemberCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AddMemeberCollectionViewCell.self, forCellWithReuseIdentifier: AddMemeberCollectionViewCell.identi)
        return collectionView
    }()
    private lazy var searchMemBerTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(DateJoinMemberTableViewCell.self, forCellReuseIdentifier: DateJoinMemberTableViewCell.identi)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        setCollectionView()
        setTableView()
        setNavigationBar()
    }
}
extension SearchAddMemberVC{
    private func setAddSubViews() {
        self.view.addSubViews([addMemberCollectionView,searchMemBerTableView])
    }
    private func setAutoLayout(){
        addMemberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(80)
        }
        searchMemBerTableView.snp.makeConstraints { make in
            make.top.equalTo(addMemberCollectionView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setCollectionView() {
        addMemberCollectionView.delegate = self
        addMemberCollectionView.dataSource = self
    }
    private func setTableView() {
//        searchMemBerTableView.delegate = self
        searchMemBerTableView.dataSource = self
    }
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: memberAddButton)
        navigationItem.searchController = searchController
    }
}

extension SearchAddMemberVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMemeberCollectionViewCell.identi, for: indexPath) as? AddMemeberCollectionViewCell else { return UICollectionViewCell()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 40)
    }
}


extension SearchAddMemberVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateJoinMemberTableViewCell.identi, for: indexPath) as? DateJoinMemberTableViewCell else { return UITableViewCell() }
        return cell
    }

}

