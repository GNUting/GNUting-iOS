//
//  SearchAddMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

// MARK: - 멤버 검색해서 추가하는 ViewController

import UIKit

// MARK: - protocol

protocol SearchAddMemberVCDelegate: AnyObject{
    func sendAddMemberData(send: [UserInfosModel])
}

final class SearchAddMemberVC: BaseViewController{
    
    // MARK: - Properties
    
    private var searchText = ""
    private var searchUser: UserInfosModel?
    weak var searchAddMemberVCDelegate: SearchAddMemberVCDelegate?
    var chatMemeberCount = 0
    var pushRequestChatVC = false // 채팅 신청하기 ViewController에서 push 됬는지
    var addMemberInfos: [UserInfosModel] = [] {
        didSet {
            addMemberCollectionView.reloadData()
        }
    }
    
    // MARK: - SubViews
    
    private let naviBorderView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BorderImage")
        
        return imageView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "닉네임을 검색해 주세요"
        searchController.searchResultsUpdater = self
        searchController.searchBar.searchTextField.delegate = self
        searchController.searchBar.searchTextField.returnKeyType = .search
        
        return searchController
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    
    private lazy var addMemberCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(AddMemeberCollectionViewCell.self, forCellWithReuseIdentifier: AddMemeberCollectionViewCell.identi)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let upperUserInfoView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.setLayerCorner(cornerRaius: 10, borderColor: UIColor(named: "BorderColor"))
        
        return view
    }()
    
    private let searchUserInfoView = UserInfoDetailView()
    
    private lazy var completedButton: PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.setText("완료", fointSize: 14)
        button.addTarget(self, action: #selector(tapMemberAddButtton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var memberOptionButton: UIButton = { // 추가 & 삭제 버튼
        let button = UIButton()
        button.setLayerCorner(cornerRaius: 10, borderColor: UIColor(named: "SecondaryColor"))
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(didSearchUserInfoView(_ :)), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        setNavigation()
    }
}

extension SearchAddMemberVC {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.view.addSubViews([addMemberCollectionView, upperUserInfoView, completedButton])
        upperUserInfoView.addSubViews([searchUserInfoView, memberOptionButton])
    }
    
    private func setAutoLayout() {
        addMemberCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.size25)
            make.height.equalTo(40)
        }
        
        upperUserInfoView.snp.makeConstraints { make in
            make.top.equalTo(addMemberCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.bottom.lessThanOrEqualToSuperview().offset(-50)
        }
        
        searchUserInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.size20)
            make.left.equalToSuperview().offset(18)
        }
        
        memberOptionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchUserInfoView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-18)
        }
        
        completedButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
        }
        
        memberOptionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - SetView
    
    private func setNavigation() {
        navigationItem.titleView = naviBorderView
        navigationItem.searchController = searchController
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setMemberOptionButton(isAddButton: Bool = true) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString(isAddButton ? "추가" : "삭제", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.regular(size: 13)!, NSAttributedString.Key.foregroundColor: isAddButton ? UIColor(named: "SecondaryColor")! : .white]))
        memberOptionButton.configuration = config
        memberOptionButton.backgroundColor = isAddButton ? .white : UIColor(named: "SecondaryColor")
    }
    
    // MARK: - Private Method
    
    private func isMemberLimitExceeded() {
        if pushRequestChatVC {
            if chatMemeberCount < addMemberInfos.count {
                showAlert(message: "인원이 초과되었습니다.")
                addMemberInfos.removeLast()
                return
            }
        }
    }
    
    // MARK: - PublicMethod
    
    func setProperties(pushRequestChatVC: Bool, addMemberInfos: [UserInfosModel], chatMemeberCount: Int = 0) {
        self.pushRequestChatVC = pushRequestChatVC
        self.addMemberInfos = addMemberInfos
        self.chatMemeberCount = chatMemeberCount
    }
    
    // MARK: - API
    
    private func getSearchUserAPI(searchNickname: String) {
        APIGetManager.shared.getSearchUser(searchNickname: searchNickname) { [unowned self] searchUserData,response  in
            guard let success = response?.isSuccess else { return }
            if success {
                upperUserInfoView.isHidden = false
                searchUser = searchUserData?.result
                searchUserInfoView.setUserInfoDetailView(name: searchUser?.nickname,
                                                         major: searchUser?.department,
                                                         studentID: searchUser?.studentId,
                                                         introduce: searchUser?.userSelfIntroduction,
                                                         image: searchUser?.profileImage)
                searchController.searchBar.text = ""
            } else {
                showAlert(message: "일치하는 닉네임이 없습니다.")
            }
        }
    }
}

// MARK: - UICollectionView

extension SearchAddMemberVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addMemberInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMemeberCollectionViewCell.identi, for: indexPath) as? AddMemeberCollectionViewCell else { return UICollectionViewCell()}
        cell.setCell(text: addMemberInfos[indexPath.item].nickname)
        
        return cell
    }
}

extension SearchAddMemberVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: addMemberInfos[indexPath.item].nickname.size(withAttributes: [NSAttributedString.Key.font : Pretendard.semiBold(size: 15)!]).width + 50, height: 35)
    }
}

// MARK: - Delegate

extension SearchAddMemberVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0 {
            addMemberInfos.remove(at: indexPath.item)
        }
    }
}

extension SearchAddMemberVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
    }
}

extension SearchAddMemberVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        upperUserInfoView.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let isUserExited = addMemberInfos.map({$0.nickname}).contains(searchText)
        setMemberOptionButton()
        isUserExited ? showAlert(message: "이미 추가한 유저입니다.") : getSearchUserAPI(searchNickname: searchText)
        
        return true
    }
    
}

// MARK: - Action

extension SearchAddMemberVC {
    @objc private func didSearchUserInfoView(_ sender: UIButton) {
        guard let searchUser = searchUser else { return }
        guard let buttonText = sender.titleLabel?.text else { return }
        if buttonText == "추가" {
            addMemberInfos.append(searchUser)
            isMemberLimitExceeded()
            setMemberOptionButton(isAddButton: false)
        } else {
            setMemberOptionButton()
            if let index = addMemberInfos.firstIndex(where: {$0.id == searchUser.id}) {
                addMemberInfos.remove(at: index)
            }
        }
    }
    
    @objc private func tapMemberAddButtton() {
        searchAddMemberVCDelegate?.sendAddMemberData(send: addMemberInfos)
        self.presentingViewController?.dismiss(animated: true)
    }
}
