//
//
//  HomeVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit
import SnapKit
class HomeVC: UIViewController{
    let sampleAdvertImage : [UIImage] = [UIImage(named: "SampleImg2")!,UIImage(named: "SampleImg2")!,UIImage(named: "SampleImg2")!]
    var imageURL : String?
    var userNickname: String?
    var homeBoardData : [BoardResult] = [] {
        didSet {
            DispatchQueue.main.async {
                self.dateBoardTableView.reloadData()
            }
        }
    }
    var currentPage = 0
    
    private lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = sampleAdvertImage.count
        pageControl.currentPageIndicatorTintColor = UIColor(hexCode: "A0A0A0")
        pageControl.pageIndicatorTintColor = UIColor(hexCode: "D9D9D9")
        return pageControl
    }()
    private lazy var explainStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    private lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        return label
    }()
    private lazy var explainImage: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "ExplainImage")
        return imageView
    }()
    private lazy var flowLayout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return layout
    }()
    private lazy var advertCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(AdvertCollectionViewCell.self, forCellWithReuseIdentifier: AdvertCollectionViewCell.identi)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    private lazy var dateBoardTableView : UITableView = { // 과팅 게시판
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.register(HomeDateBoardListTableViewHeader.self, forHeaderFooterViewReuseIdentifier: HomeDateBoardListTableViewHeader.identi)
        tableview.register(HomeDateBoardListTableViewCell.self, forCellReuseIdentifier: HomeDateBoardListTableViewCell.identi)
        tableview.showsVerticalScrollIndicator = false
        tableview.bounces = false
        return tableview
    }()
    private lazy var imageButton = UIButton()

    private lazy var bellImage : UIImageView = {
        let imageView = UIImageView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapNotiButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        addSubViews()
        setAutoLayout()
        setCollectionView()
        setTableview()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
        getNotificationCheckData()
        getUserData()
        getBoardData()
        postFCMToken()
    }
}
extension HomeVC{
    private func setTableview(){
        dateBoardTableView.delegate = self
        dateBoardTableView.dataSource = self
    }
    private func setCollectionView(){
        advertCollectionView.delegate = self
        advertCollectionView.dataSource = self
    }
    private func addSubViews() {
        self.view.addSubViews([explainStackView,advertCollectionView,pageControl,dateBoardTableView])
        explainStackView.addStackSubViews([explainLabel,explainImage])
    }
    private func setAutoLayout(){
        explainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.lessThanOrEqualToSuperview().offset(Spacing.right)
        }

        
        explainImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        advertCollectionView.snp.makeConstraints { make in
            make.top.equalTo(explainStackView.snp.bottom).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(80)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(advertCollectionView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        dateBoardTableView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        imageButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
    }
    private func setNavigationBar(){
        imageButton.addTarget(self, action: #selector(tapUserImageButton), for: .touchUpInside)
        let userImageButton = UIBarButtonItem(customView: imageButton)
        userImageButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItems = [userImageButton]
    }
    
    private func setExplainLabel(text: String) {
        explainLabel.text = "\(text)님 안녕하세요"
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sampleAdvertImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertCollectionViewCell.identi, for: indexPath) as? AdvertCollectionViewCell else {return UICollectionViewCell()}
        cell.setCell(sampleAdvertImage[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 80)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / advertCollectionView.frame.width)
        self.pageControl.currentPage = page
    }
}
extension HomeVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeBoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeDateBoardListTableViewCell.identi, for: indexPath) as? HomeDateBoardListTableViewCell else { return UITableViewCell()}
        cell.setCell(model: homeBoardData[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HomeDateBoardListTableViewHeader.identi) as? HomeDateBoardListTableViewHeader else {return UIView()}
        header.tapMoreViewButtonCompletion = { [unowned self] in
            self.pushViewContoller(viewController: DateBoardListVC())
        }
        return header
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
        vc.userNickName = self.userNickname
        
        presentFullScreenVC(viewController: vc)
    }
}
// MARK: - Get Data
extension HomeVC {
    private func getBoardData() {
        APIGetManager.shared.getBoardText(page: 1, size: 10) { [unowned self] boardData,response  in
            errorHandling(response: response)
            guard let boardDataList = boardData?.result else { return}
            homeBoardData = boardDataList
        }
    }
    private func getUserData(){
        APIGetManager.shared.getUserData { [unowned self] userData,response  in
            errorHandling(response: response)
            self.imageURL = userData?.result?.profileImage
            self.userNickname = userData?.result?.name ?? "유저이름"
            setExplainLabel(text: userData?.result?.name ?? "이름")
            
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
                let bellImageButton = UIBarButtonItem(customView: self.bellImage)
                
                self.navigationItem.rightBarButtonItems?.append(bellImageButton)
            } else {
                self.bellImage.image = UIImage(named: "BellImg")
                let bellImageButton = UIBarButtonItem(customView: self.bellImage)
                self.navigationItem.rightBarButtonItems?.append(bellImageButton)
            }
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
