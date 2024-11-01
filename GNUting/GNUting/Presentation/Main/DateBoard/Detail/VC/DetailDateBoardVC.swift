//
//  DetailDateBoardVC.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

// MARK: - 과팅 게시판 Detail ViewController

import UIKit

final class DetailDateBoardVC: BaseViewController {
    
    // MARK: - Properties
    
    var boardID: Int = 0
    private var userInfos: [UserInfosModel] = []
    private var postUserInfos: User?
    private var chatMemeberCount: Int = 0
    
    // MARK: - SubViews
    
    private lazy var statusLabel: UILabel = {
       let label = UILabel()
        label.text = "신청 가능"
        label.font = Pretendard.semiBold(size: 14)
        label.textColor = UIColor(named: "SecondaryColor")
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 16)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var writeDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Pretendard.regular(size: 14)
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    private lazy var userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.userInfoViewDelegate = self
        
        return view
    }()
    
    private lazy var contentTextView: UITextView  = {
        let textView = UITextView()
        textView.font = Pretendard.regular(size: 18)
        textView.textColor = .black
        textView.isEditable = false

        return textView
    }()
    
    private lazy var chatPeopleViewButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapchatPeopleViewButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var requestChatButton: PrimaryColorButton = { // 어떻게 할지 정해야된다. 내글에서는 필요가 없기때문에
        let button = PrimaryColorButton()
        button.setText("신청하기",fointSize: 16)
        button.addTarget(self, action: #selector(tapRequestChatButton(_ :)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var detailDateBoardSetView: SettingView = {
        let view = SettingView()
        view.isHidden = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.1
        
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        bringToDetailDateBoardSetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBoardDetailDataAPI()
        setNavigationBar()
    }
}

extension DetailDateBoardVC {
    
    // MARK: - LifeCycle
    
    private func bringToDetailDateBoardSetView() {
        self.view.bringSubviewToFront(detailDateBoardSetView)
    }
    
    private func addSubViews() {
        view.addSubViews([statusLabel, titleLabel, writeDateLabel, userInfoView, contentTextView, chatPeopleViewButton, requestChatButton, detailDateBoardSetView])
        
    }
    private func setAutoLayout(){
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        
        writeDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(writeDateLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(Spacing.size27)
        }
        contentTextView.setContentHuggingPriority(.init(249), for: .vertical)
        
        chatPeopleViewButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        requestChatButton.snp.makeConstraints { make in
            make.top.equalTo(chatPeopleViewButton.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.size27)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
            
        }
        
        detailDateBoardSetView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    
    // MARK: - SetView
    
    private func setNavigationBar() {
        let settingButton = UIBarButtonItem(image: UIImage(named: "SettingButton"), style: .plain, target: self, action: #selector(tapSettingButton(_:)))
        settingButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    private func setChatPeopleViewButton(memeberCount: Int) {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("과팅 멤버 정보 \(memeberCount)명", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 15) ?? .systemFont(ofSize: 15)]))
        config.image = UIImage(named: "ChatImg")
        config.baseForegroundColor = UIColor(named: "PrimaryColor")
        config.imagePlacement = .leading
        config.imagePadding = 5
        
        chatPeopleViewButton.configuration = config
    }
    
    // MARK: - push된 분기에 따른 처리
    
    func setPushMypostVersion() {
        setNavigationBar(title: "내가 쓴 게시글")
        requestChatButton.backgroundColor = UIColor(named: "SecondaryColor")
        requestChatButton.setText("신청 현황 보러가기",fointSize: 16)
        chatPeopleViewButton.isHidden = true
        detailDateBoardSetView.setAutoLayout(isMypost: true)
        detailDateBoardSetView.myPostDelegate = self
    }
    
    func setPushBoardList() {
        setNavigationBar(title: "과팅 게시판")
        detailDateBoardSetView.otherPostDelegate = self
        detailDateBoardSetView.setAutoLayout(isMypost: false)
    }
}

// MARK: - API

extension DetailDateBoardVC {
    private func getBoardDetailDataAPI() {
        APIGetManager.shared.getBoardDetail(id: boardID) { boardDetailData,response  in
            self.errorHandling(response: response)
            guard let result = boardDetailData?.result else { return }
            let user = result.user
            let isOpen = result.status == "OPEN" ? true : false
            self.postUserInfos = user
            self.titleLabel.text =  result.title
            self.writeDateLabel.text = result.time
            self.contentTextView.text = result.detail
            self.userInfos = result.inUser
            self.userInfoView.setUserInfoView(userImage: user.image, userNickname: user.nickname, major: user.department, StudentID: user.studentId)
            self.setChatPeopleViewButton(memeberCount: result.inUser.count)
            self.chatMemeberCount = result.inUser.count
            self.statusLabel.textColor = isOpen ? UIColor(named: "SecondaryColor") : UIColor(named: "PrimaryColor")
            self.statusLabel.text = isOpen ? "신청 가능" : "신청 마감"
        }
    }
    
    private func deletePostTextAPI() {
        APIDeleteManager.shared.deletePostText(boardID: self.boardID) { response in
            response.isSuccess ? self.showAlertNavigationBack(message: "게시글이 삭제되었습니다.",backType: .pop) :
            self.errorHandling(response: response)
        }
    }
}

// MARK: - Delegate

extension DetailDateBoardVC: OtherPostDelegate {
    func didTapReportButton() { // 신고하기
        let vc = ReportVC()
        vc.boardID = boardID
        
        self.navigationItem.rightBarButtonItem?.isSelected = false
        detailDateBoardSetView.isHidden = true
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
}

extension DetailDateBoardVC: MyPostDelegate {
    func didTapUpDateButton() {
        let vc = PostEditorVC()
        
        vc.isEditingMode = true
        vc.setPostTestView(title: titleLabel.text ?? "", content: contentTextView.text)
        vc.boardID = boardID
        vc.memberList = userInfos
        detailDateBoardSetView.isHidden = true
        pushViewController(viewController: vc)
    }
    
    func didTapDeleteButton() {
        let alertController = UIAlertController(title: "", message: "게시글을 삭제하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "예", style: .default,handler: { _ in
            self.deletePostTextAPI()
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

extension DetailDateBoardVC: UserInfoViewDelegate {
    func tapUserImageButton() {
        let vc = UserDetailVC()
        
        vc.userDetailData = UserDetailModel(imageURL: postUserInfos?.image,
                                            nickname: postUserInfos?.nickname,
                                            userStudentID: postUserInfos?.studentId,
                                            userDepartment: postUserInfos?.department)
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
}

// MARK: - Action

extension DetailDateBoardVC {
    @objc private func tapSettingButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        detailDateBoardSetView.isHidden = sender.isSelected ? false : true
    }
    
    @objc private func didTapchatPeopleViewButton() {
        let vc = DateJoinMemberVC()
        vc.userInfos = self.userInfos
        self.presentViewController(viewController: vc,modalPresentationStyle: .fullScreen)
    }
    
    @objc private func tapRequestChatButton(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        if buttonText == "신청하기" {
            let vc = RequestChatVC()
            vc.boardID = boardID
            vc.chatMemeberCount = self.chatMemeberCount
            pushViewController(viewController: vc)
        } else {
            self.tabBarController?.selectedIndex = 1
        }
    }
}
