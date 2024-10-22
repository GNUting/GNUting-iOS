//
//
//  HomeVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

// MARK: - 홈 화면

import UIKit
import SnapKit


final class HomeVC: BaseViewController {
    
    // MARK: - Properties
    
    private var userDetailData: UserDetailModel?
    
    // MARK: - SubViews
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(hexCode: "FFF0F0")
        
        return view
    }()
    
    private lazy var appLogoButton = UIButton()
    private lazy var bellImageView = UIImageView()
    private lazy var homeTopView = HomeTopView()
    private lazy var homeBottomView = HomeBottomView()
    
    private lazy var eventView: EventView = {
        let eventView = EventView()
        eventView.eventViewDelegate = self
        
        return eventView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexCode: "FFF0F0")
        
        addSubViews()
        setAutoLayout()
        setAppLogoButtonConfiguration()
        setImageViewTapGesture()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postFCMTokenAPI()
        getNotificationCheckAPI()
        getUserDataAPI()
        tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Layout Helpers

extension HomeVC {
    private func addSubViews() {
        view.addSubViews([scrollView,eventView])
        scrollView.addSubview(contentView)
        contentView.addSubViews([homeTopView, homeBottomView])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        eventView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
            
        }
        
        homeTopView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.upperTop)
            make.left.right.equalToSuperview().inset(25)
        }
        
        homeBottomView.snp.makeConstraints { make in
            make.top.equalTo(homeTopView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - Private Method (SetSubViews Set)

extension HomeVC {
    private func setNavigationBar() { // 네비게이션 바 설정
        let leftNavigationItem = UIBarButtonItem(customView: self.appLogoButton)
        let searchButtonItem = UIBarButtonItem(image: UIImage(named: "SearchImg"), style: .plain, target: self, action: #selector(self.tapSearchButton))
        let bellImageButton = UIBarButtonItem(customView: self.bellImageView)
        
        leftNavigationItem.tintColor = UIColor(named: "PrimaryColor")
        searchButtonItem.tintColor = UIColor(named: "IconColor")
        self.navigationItem.leftBarButtonItem = leftNavigationItem
        self.navigationItem.rightBarButtonItems = [bellImageButton,searchButtonItem]
    }
    
    private func setAppLogoButtonConfiguration() {
        var config = UIButton.Configuration.plain()
        
        config.image = UIImage(named: "AppLogoImage")
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 12, bottom: 0, trailing: 0)
        appLogoButton.configuration = config
    }
    
    private func setImageViewTapGesture() {
        setTapGestureView(view: bellImageView, action: #selector(tapNotiButtonAction))
        //        setTapGestureView(view: homeBottomView.bannerImageView, action: #selector(tapBannerImageViewAction))
    }
    
    private func setDelegate() {
        homeTopView.writePostButton.writeButtonDelegate = self
        homeTopView.writNoteButton.writeButtonDelegate = self
        homeBottomView.homeBottomViewDelegate = self
    }
    
    // MARK:  - SetAlertController
    
    private func setAlertController(chatID: Int) {
        let alertController = UIAlertController(title: "채팅이 성사되었습니다.", message: "채팅방으로 이동 하시겠습니까?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "네", style: .destructive,handler: { _ in
            self.pushChatRoom(chatID: chatID)
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    
    // MARK: - pushChatRoom
    
    private func pushChatRoom(chatID: Int) {
        let chatRoomVC = ChatRoomVC()
        chatRoomVC.isPushNotification = true
        chatRoomVC.chatRoomID = chatID
        self.pushViewContoller(viewController: chatRoomVC)
    }
}

// MARK: - API

extension HomeVC {
    
    // MARK: - Post FCMToken
    
    private func postFCMTokenAPI() {
        guard let fcmToken = KeyChainManager.shared.read(key: "fcmToken") else { return }
        APIPostManager.shared.postFCMToken(fcmToken: fcmToken) { response in
            if response?.code != "FIREBASE4000" {
                self.errorHandling(response: response)
            }
        }
    }
    
    private func getUserDataAPI() {
        APIGetManager.shared.getUserData { [unowned self] userData,response  in
            errorHandling(response: response)
            self.userDetailData = UserDetailModel(imageURL: userData?.result?.profileImage,
                                                  nickname: userData?.result?.nickname ?? "닉네임",
                                                  userStudentID: userData?.result?.studentId ?? "학번",
                                                  userDepartment: userData?.result?.department ?? "학과")
            homeTopView.setUserNaemLabel(username: userData?.result?.nickname ?? "닉네임")
            setImageFromStringURL(stringURL: userData?.result?.profileImage ) { image in
                self.homeTopView.setImageButton(image: image)
            }
        }
    }
    
    private func getNotificationCheckAPI() {
        APIGetManager.shared.getNotificationCheck { notificationCheckModel in
            guard let notificationCheckData = notificationCheckModel?.result else { return }
            
            self.bellImageView.image = notificationCheckData ? UIImage(named: "NewBellImg") : UIImage(named: "BellImg")
            self.setNavigationBar()
        }
    }
    
    private func postEventParticipateAPI(nickname: String) {
        APIPostManager.shared.postEventParticipate(nickname: nickname) { successResponse, failureResponse in
            if ((successResponse?.isSuccess) != nil) {
                self.setAlertController(chatID: successResponse?.result.chatId ?? 0)
            } else {
                if !(failureResponse?.isSuccess ?? false)  {
                    self.showMessage(message: failureResponse?.message ?? "재시도 해주세요.")
                }
            }
        }
    }
}

// MARK: - Delegate

extension HomeVC: WriteButtonDelegate {
    func tapButtonAction(tag: Int) {
        if tag == 0 {
            self.pushViewContoller(viewController: WriteDateBoardVC())
        } else if tag == 1 { // 메모팅 남기기 버튼
            let vc = NoteViewController()
            vc.isHiddenwriteNoteView(hidden: false)
            self.pushViewContoller(viewController: vc)
        }
    }
}

extension HomeVC: HomeBottomViewDelegate {
    func tapEventButton() {
        APIGetManager.shared.getEventSeverOpen { response in
            let isOpen = response?.result
            if isOpen == "OPEN" {
                self.eventView.isHidden = false
            } else {
                self.showAlert(message: "이벤트 기간이 아닙니다.")
            }
        }
        
    }
    
    func tapPostBoardCardView() {
        self.pushViewContoller(viewController: DateBoardListVC())
    }
    
    func oneMatchCardView() {
        self.showAlert(message: "곧 출시 예정이에요.")
    }
    
    func tapNoteCardView() {
        self.pushViewContoller(viewController: NoteViewController())
    }
    
    func tapMypostCardView() {
        self.pushViewContoller(viewController: UserWriteTextVC())
    }
}

extension HomeVC: EventViewDelegate {
    func tapCancelButton() {
        eventView.isHidden = true
    }
    
    func tapRegisterButton(textFiledText: String) {
        postEventParticipateAPI(nickname: textFiledText)
        eventView.isHidden = true
    }
    
    
}

// MARK: - Action

extension HomeVC {
    @objc private func tapNotiButtonAction() {
        presentViewController(viewController: NotificationVC(), modalPresentationStyle: .fullScreen)
    }
    
    @objc private func tapUserImageButton(){
        let vc = UserDetailVC()
        
        vc.userDetailData = self.userDetailData
        presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
    }
    @objc private func tapSearchButton(){
        let vc = UINavigationController.init(rootViewController: BoardTextSearchVC())
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func tapBannerImageViewAction() {
        instagramOpen()
    }
}
