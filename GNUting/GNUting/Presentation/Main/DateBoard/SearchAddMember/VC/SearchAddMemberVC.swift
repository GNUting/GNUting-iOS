//
//  SearchAddMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

// MARK: - 멤버검색해서 추가하는 VC

protocol MemberAddButtonDelegate: AnyObject{
    func sendAddMemberData(send: [UserInfosModel])
}

class SearchAddMemberVC: UIViewController{
    var searchUser : UserInfosModel?
    var addMemberInfos: [UserInfosModel] = [] {
        didSet {
            addMemberCollectionView.reloadData()
        }
    }
    var searchText: String = ""
    
    var tappedSearchUserInfoView: Bool = false
    
    var memberAddButtonDelegate: MemberAddButtonDelegate?
    
    private lazy var dismissButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        return button
    }()
    private lazy var memberAddButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("멤버 추가", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 14)!]))
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let button = UIButton(configuration: config)
        
        button.setTitle("멤버 추가", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "SecondaryColor")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapMemberAddButtton), for: .touchUpInside)
        
        return button
    }()
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "추가할 멤버의 닉네임을 입력하세요."
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField.returnKeyType = .search
        return searchController
    }()
    private lazy var addMemberCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AddMemeberCollectionViewCell.self, forCellWithReuseIdentifier: AddMemeberCollectionViewCell.identi)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    private lazy var searchUserInfoView : UserInfoDetailView = {
        let view = UserInfoDetailView()
        view.isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didSearchUserInfoView))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
    }
}
extension SearchAddMemberVC{
    private func setAddSubViews() {
        self.view.addSubViews([addMemberCollectionView,searchUserInfoView])
    }
    private func setAutoLayout(){
        addMemberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(40)
        }
        
        searchUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(self.addMemberCollectionView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
    }
    private func setNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: memberAddButton)
        navigationItem.searchController = searchController
    }
}

extension SearchAddMemberVC {
    @objc private func didSearchUserInfoView() {
        guard let searchUser = searchUser else { return }
        
        if tappedSearchUserInfoView{
            tappedSearchUserInfoView = false
            if let index = addMemberInfos.firstIndex(where: {$0.id == searchUser.id}) {
                addMemberInfos.remove(at: index)
            }
        } else {
            addMemberInfos.append(searchUser)
            tappedSearchUserInfoView = true
        }
        searchUserInfoView.selected(isSelected: tappedSearchUserInfoView)
    }
    
    @objc private func tapMemberAddButtton() {
        memberAddButtonDelegate?.sendAddMemberData(send: addMemberInfos)
        self.presentingViewController?.dismiss(animated: true)
        
    }
}
extension SearchAddMemberVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addMemberInfos.remove(at: indexPath.item)
        searchUserInfoView.selected(isSelected: false)
    }
}
extension SearchAddMemberVC: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addMemberInfos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMemeberCollectionViewCell.identi, for: indexPath) as? AddMemeberCollectionViewCell else { return UICollectionViewCell()}
        cell.setCell(text: addMemberInfos[indexPath.item].nickname)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: addMemberInfos[indexPath.item].nickname.size(withAttributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.SemiBold.rawValue, size: 15)!]).width + 50, height: 35)
    }
    
}


extension SearchAddMemberVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return}
        searchText = text
    }
}
extension SearchAddMemberVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchUserInfoView.isHidden = true
        searchUserInfoView.selected(isSelected: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        APIGetManager.shared.getSearchUser(searchNickname: searchText) { [self] searchUserData in
            searchUserInfoView.isHidden = false
            searchUser = searchUserData?.result
          
            self.searchUserInfoView.setUserInfoDetailView(name: searchUser?.name, major: searchUser?.department, studentID: searchUser?.studentId, age: searchUser?.age, introduce: searchUser?.userSelfIntroduction, image: searchUser?.profileImage)
            searchController.searchBar.text = ""
        }
        return true
    }
 
}
