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
    private lazy var explainLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 22)
        return label
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
        return tableview
    }()
    private lazy var imageButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getBoardData()
        getUserData()
        setNavigationBar()
        addSubViews()
        setAutoLayout()
        setCollectionView()
        setTableview()
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
        self.view.addSubViews([explainLabel,advertCollectionView,pageControl,dateBoardTableView])
    }
    private func setAutoLayout(){
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        advertCollectionView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(Spacing.top)
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
        let notiButton = UIBarButtonItem(image: UIImage(named: "BellImg"), style: .plain, target: self, action: #selector(tapNotiButton))
        notiButton.tintColor = UIColor(named: "IconColor")
    
        let userImageButton = UIBarButtonItem(customView: imageButton)
        userImageButton.tintColor = UIColor(named: "IconColor")
        self.navigationItem.rightBarButtonItems = [userImageButton,notiButton]
    }
    
    private func setExplainLabel(text: String) {
        explainLabel.text = "\(text)님 안녕하세요 😄"
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
            let vc = DateBoardListVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return header
    }
  
}
extension HomeVC{
    @objc private func tapNotiButton(){
        
    }
    @objc private func tapUserImageButton(){
        
    }
}
// MARK: - Get Data
extension HomeVC {
    private func getBoardData() {
        APIGetManager.shared.getBoardText(page: 1, size: 10) { boardData in
            guard let boardDataList = boardData?.result else { return}
            self.homeBoardData = boardDataList
        }
    }
    private func getUserData(){
        APIGetManager.shared.getUserData { [unowned self] userData in
            guard let userData = userData else { return }
            self.setExplainLabel(text: userData.result.nickname)
            self.setImageFromStringURL(stringURL: userData.result.profileImage ?? "")
        }
    }
    private func setImageFromStringURL(stringURL : String) {
        if let url = URL(string: stringURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    self.imageButton.setImage(UIImage(data: imageData), for: .normal)
                    self.imageButton.layer.cornerRadius = self.imageButton.layer.frame.size.width / 2
                    self.imageButton.layer.masksToBounds = true
                }
            }.resume()
        }else {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            imageButton.configuration = config
            self.imageButton.setImage(UIImage(systemName: "person.circle"), for: .normal)
        }
    }
}
