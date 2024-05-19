//
//
//  HomeVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit
import SnapKit
class HomeVC: BaseViewController{
    var imageURL : String?
    var username: String?
    var userStudentID: String?
    var userDepartment: String?
    var currentPage = 0
    private lazy var appLogoButtonItem: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "AppLogoImage")
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 12, bottom: 0, trailing: 0)
        let button = UIButton(configuration: config)
        
        return button
    }()
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var contentView : UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(hexCode: "FFF0F0")
        return view
    }()
    private lazy var bellImage : UIImageView = {
        let imageView = UIImageView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNotiButton))
        
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    private lazy var homeTopView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        return view
    }()
    private lazy var homeBottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private lazy var explainStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    private lazy var userNameLabel:  UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 22)
        label.numberOfLines = 2
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    private lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.text = "지누팅에서 아름다운 만남을 가져보세요!"
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    private lazy var writePostButton : WritePostButton = {
        let button = WritePostButton()
        button.writePostButtonDelegate = self
        return button
    }()
    
    private lazy var imageButton = UIButton()
    
    private lazy var bannerImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bannerImage")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBannerImageView))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    private lazy var postSubView: ImagePlusLabelView = {
        let view = ImagePlusLabelView()
        view.setImagePlusLabelView(imageName: "PostImage", textFont: UIFont(name: Pretendard.Bold.rawValue, size: 14) ?? .boldSystemFont(ofSize: 14), labelText: "모든 글은 여기서 볼 수 있어요")
        return view
    }()
    private lazy var cardStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    private lazy var postBoardCardView : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PostBoardCardImage"), for: .normal)
        button.addTarget(self, action: #selector(tapPostBoardCardView), for: .touchUpInside)
        
        return button
    }()
    private lazy var mypostCardView : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "MypostCardImage"), for: .normal)
        button.addTarget(self, action: #selector(tapMypostCardView), for: .touchUpInside)

        return button
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexCode: "FFF0F0")
        addSubViews()
        setAutoLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotificationCheckData()
        getUserData()
        postFCMToken()
        tabBarController?.tabBar.isHidden = false
    }
   
}
extension HomeVC{
    
    
    private func addSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews([homeTopView,homeBottomView])
        homeTopView.addSubViews([explainStackView,writePostButton,imageButton])
        explainStackView.addStackSubViews([userNameLabel,explainLabel])
        homeBottomView.addSubViews([bannerImageView,postSubView,cardStackView])
        cardStackView.addStackSubViews([postBoardCardView,mypostCardView])
    }
    private func setAutoLayout(){
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
        explainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalToSuperview().offset(25)
        }
        
        writePostButton.snp.makeConstraints { make in
            make.top.equalTo(explainStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(25)
            make.bottom.equalToSuperview().offset(-16)
        }
        imageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalTo(explainStackView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-25)
            make.height.width.equalTo(60)
        }
        
        homeBottomView.snp.makeConstraints { make in
            make.top.equalTo(homeTopView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview().inset(25)
        }
        postSubView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(25)
        }
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(postSubView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
    
        
    }
    
    private func setUserNaemLabel(username: String) {
        let text = "\(username) 님 안녕하세요 :)"
        userNameLabel.text = text
        userNameLabel.setRangeTextFont(fullText: text, range: username, uiFont: UIFont(name: Pretendard.Bold.rawValue, size: 22) ?? .boldSystemFont(ofSize: 22))
    }
    private func setExplainLabel(text: String) {
        
    }
    private func setNavigationBar() {
        let leftNavigationItem = UIBarButtonItem(customView: self.appLogoButtonItem)
        leftNavigationItem.tintColor = UIColor(named: "PrimaryColor")
        
        self.navigationItem.leftBarButtonItem = leftNavigationItem
        let searchButtonItem = UIBarButtonItem(image: UIImage(named: "SearchImg"), style: .plain, target: self, action: #selector(self.tapSearchButton))
        searchButtonItem.tintColor = UIColor(named: "IconColor")
        let bellImageButton = UIBarButtonItem(customView: self.bellImage)
        self.navigationItem.rightBarButtonItems = [bellImageButton,searchButtonItem]
        
    }
}



extension HomeVC{
    @objc private func tapNotiButton(){
        let vc = NotificationVC()
        presentFullScreenVC(viewController: vc)
    }
    @objc private func tapUserImageButton(){
        let vc = UserDetailVC()
        vc.imaegURL = self.imageURL
        vc.userNickName = self.username
        vc.userStudentID = self.userStudentID
        vc.userDepartment = self.userDepartment
        
        presentFullScreenVC(viewController: vc)
    }
    @objc private func tapSearchButton(){
        let vc = UINavigationController.init(rootViewController: BoardTextSearchVC())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @objc private func tapBannerImageView() {
        instagramOpen()
    }
    @objc private func tapPostBoardCardView() {
        self.pushViewContoller(viewController: DateBoardListVC())
       
    }
    @objc private func tapMypostCardView() {
        self.pushViewContoller(viewController: UserWriteTextVC())
    }
}
// MARK: - Get Data
extension HomeVC {
    
    private func getUserData(){
        APIGetManager.shared.getUserData { [unowned self] userData,response  in
            errorHandling(response: response)
            self.imageURL = userData?.result?.profileImage
            self.username = userData?.result?.nickname ?? "닉네임"
            self.userStudentID = userData?.result?.studentId ?? "학번"
            self.userDepartment = userData?.result?.department ?? "학과"
            setExplainLabel(text: userData?.result?.nickname ?? "이름")
            self.setUserNaemLabel(username: username ?? "닉네임")
            
            setImageFromStringURL(stringURL:self.imageURL ) { image in
                
                DispatchQueue.main.async {
                    self.imageButton.setImage(image, for: .normal)
                    if self.imageURL != nil {
                        self.imageButton.layer.cornerRadius = self.imageButton.layer.frame.size.width / 2
                        self.imageButton.layer.masksToBounds = true
                    }
                }
            }
        }
    }
    private func getNotificationCheckData(){
        APIGetManager.shared.getNotificationCheck { notificationCheckModel in
            guard let notificationCheckData = notificationCheckModel?.result else { return }
            if notificationCheckData {
                self.bellImage.image = UIImage(named: "NewBellImg")
            } else {
                self.bellImage.image = UIImage(named: "BellImg")
            }
            self.setNavigationBar()
        }
    }
}
// MARK: - Post FCMToken
extension HomeVC {
    private func postFCMToken(){
        guard let fcmToken = KeyChainManager.shared.read(key: "fcmToken") else { return }
        APIPostManager.shared.postFCMToken(fcmToken: fcmToken) { response in
            if response?.code != "FIREBASE4000" {
                self.errorHandling(response: response)
            }
        }
    }
}

//MARK: - Delegate
extension HomeVC: WritePostButtonDelegate {
    func tapButton() {
        UIView.animate(withDuration: 0.2) {
            let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self.writePostButton.transform = scale
            
        } completion: { finished in
            UIView.animate(withDuration: 0.2) {
                self.writePostButton.transform = .identity
            }
            self.pushViewContoller(viewController: WriteDateBoardVC())
        }
        
    }
}
