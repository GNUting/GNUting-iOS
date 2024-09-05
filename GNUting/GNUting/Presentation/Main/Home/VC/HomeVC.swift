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


class HomeVC: BaseViewController {
    
    // MARK: - Properties
    
    var userDetailData: UserDetailModel?
    
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
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews([homeTopView, homeBottomView])
    }
    
    private func setAutoLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        homeTopView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.upperTop)
            make.left.right.equalToSuperview().inset(25)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
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
        setTapGestureImageView(imaegView: bellImageView, action: #selector(tapNotiButtonAction))
        setTapGestureImageView(imaegView: homeBottomView.bannerImageView, action: #selector(tapBannerImageViewAction))
    }
    
    private func setDelegate() {
        homeTopView.writePostButton.writePostButtonDelegate = self
        homeBottomView.homeBottomViewDelegate = self
    }
}

// MARK: API

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
}

// MARK: - Delegate

extension HomeVC: WritePostButtonDelegate {
    func tapButtonAction() {
        self.pushViewContoller(viewController: WriteDateBoardVC())
    }
}

extension HomeVC: HomeBottomViewDelegate {
    func tapPostBoardCardView() {
        self.pushViewContoller(viewController: DateBoardListVC())
    }
    
    func tapMypostCardView() {
        self.pushViewContoller(viewController: UserWriteTextVC())
    }
    
    
}

// MARK: - Action

extension HomeVC {
    @objc private func tapNotiButtonAction() {
        presentFullScreenVC(viewController: NotificationVC())
    }
    
    @objc private func tapUserImageButton(){
        let vc = UserDetailVC()
        
        vc.userDetailData = self.userDetailData
        presentFullScreenVC(viewController: vc)
    }
    @objc private func tapSearchButton(){
        let vc = UINavigationController.init(rootViewController: BoardTextSearchVC())
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func tapBannerImageViewAction() {
        instagramOpen()
    }
    
    private func setTapGestureImageView(imaegView: UIImageView, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        
        imaegView.addGestureRecognizer(tapGesture)
    }
}
