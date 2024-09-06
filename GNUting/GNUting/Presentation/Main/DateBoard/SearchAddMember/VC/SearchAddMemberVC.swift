//
//  SearchAddMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

// MARK: - 멤버검색해서 추가하는 VC

import UIKit

// MARK: protocol

protocol MemberAddButtonDelegate: AnyObject{
    func sendAddMemberData(send: [UserInfosModel])
}

class SearchAddMemberVC: BaseViewController{
    var searchText: String = ""
    var chatMemeberCount = 0
    var requestChat : Bool = false
    var searchUser : UserInfosModel?
    var addMemberInfos: [UserInfosModel] = [] {
        didSet {
            addMemberCollectionView.reloadData()
        }
    }
    weak var memberAddButtonDelegate: MemberAddButtonDelegate?
    
    
    // MARK: - SubViews
    private lazy var naviBorderView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorderImage")
        return imageView
    }()
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "닉네임을 검색해 주세요"
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
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var upperUserInfoView : UIView = {
        let view = UIView()
        view.isHidden = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var searchUserInfoView : UserInfoDetailView = {
        let view = UserInfoDetailView()
        
        return view
    }()
    private lazy var completedButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("완료", fointSize: 14)
        button.addTarget(self, action: #selector(tapMemberAddButtton), for: .touchUpInside)
        return button
    }()
    private lazy var memberOptionButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20)
        
        config.attributedTitle = AttributedString("추가", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 13) ?? .systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor: UIColor(named: "SecondaryColor")!]))
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didSearchUserInfoView(_ :)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        setAddSubViews()
        setAutoLayout()
        setNavigationBar()
        
    }
}
extension SearchAddMemberVC{
    private func setAddSubViews() {
        self.view.addSubViews([addMemberCollectionView, upperUserInfoView, completedButton])
        upperUserInfoView.addSubViews([searchUserInfoView, memberOptionButton])
    }
    private func setAutoLayout(){
        addMemberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(40)
        }
        upperUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(addMemberCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        searchUserInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(18)
            make.bottom.equalToSuperview().offset(-20)
            
        }
        memberOptionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchUserInfoView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-18)
        }
        memberOptionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        completedButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Spacing.UpperInset)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
    }
    private func setNavigationBar() {
        
        self.navigationItem.titleView = naviBorderView
        navigationItem.searchController = searchController
    }
    private func setAddButton() {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("추가", attributes: AttributeContainer([NSAttributedString.Key.font : Pretendard.regular(size: 13) ?? .systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor : UIColor(named: "SecondaryColor")!]))
        memberOptionButton.configuration = config
        memberOptionButton.backgroundColor = UIColor(named: "SecondaryColor")
        memberOptionButton.backgroundColor = .white
    }
    private func setDeleteButton() {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("삭제", attributes: AttributeContainer([NSAttributedString.Key.font : Pretendard.regular(size: 13) ?? .systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor : UIColor.white]))
        memberOptionButton.configuration = config
        memberOptionButton.backgroundColor = UIColor(named: "SecondaryColor")
    }
}

extension SearchAddMemberVC {
    @objc private func didSearchUserInfoView(_ sender: UIButton) {
        guard let searchUser = searchUser else { return }
        guard let buttonTetxt = sender.titleLabel?.text else { return }
        if buttonTetxt == "추가" {
            addMemberInfos.append(searchUser)
            if requestChat{
                if chatMemeberCount < addMemberInfos.count {
                    showMessage(message: "인원이 초과되었습니다.")
                    addMemberInfos.removeLast()
                }else {
                    setDeleteButton()
                }
            } else {
                setDeleteButton()
            }
        } else {
            setAddButton()
            if let index = addMemberInfos.firstIndex(where: {$0.id == searchUser.id}) {
                addMemberInfos.remove(at: index)
            }
        }
    }
    
    @objc private func tapMemberAddButtton() {
        memberAddButtonDelegate?.sendAddMemberData(send: addMemberInfos)
        self.presentingViewController?.dismiss(animated: true)
        
    }
}
extension SearchAddMemberVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            addMemberInfos.remove(at: indexPath.item)
            
        }
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
        
        return CGSize(width: addMemberInfos[indexPath.item].nickname.size(withAttributes: [NSAttributedString.Key.font : Pretendard.semiBold(size: 15) ?? .boldSystemFont(ofSize: 15)]).width + 50, height: 35)
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
        upperUserInfoView.isHidden = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setAddButton()
        if  addMemberInfos.map({$0.nickname}).contains(searchText) {
            showMessage(message: "이미 추가한 유저입니다.")
        } else {
            APIGetManager.shared.getSearchUser(searchNickname: searchText) { [unowned self] searchUserData,response  in
                guard let success = response?.isSuccess else { return }
                if success {
                    upperUserInfoView.isHidden = false
                    searchUser = searchUserData?.result
                    
                    searchUserInfoView.setUserInfoDetailView(name: searchUser?.nickname, major: searchUser?.department, studentID: searchUser?.studentId, introduce: searchUser?.userSelfIntroduction, image: searchUser?.profileImage)
                    searchController.searchBar.text = ""
                } else {
                    showAlert(message: "일치하는 닉네임이 없습니다.")
                }
            }
        }
        
        return true
    }
    
}
