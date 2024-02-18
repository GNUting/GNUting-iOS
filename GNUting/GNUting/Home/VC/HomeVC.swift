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
    
    var userName = "원동진"
    let sampleAdvertImage : [UIImage] = [UIImage(named: "SampleImg2")!,UIImage(named: "SampleImg2")!,UIImage(named: "SampleImg2")!]
    let sampeleDateBoardData : [DateBoardModel] = [DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요."),DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요."),DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요."),DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요."),DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요."),DateBoardModel(major: "간호학과", title: "3:3과팅하실분 연락주세요.")]
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
        label.text = "\(userName)님 안녕하세요!"
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
        tableview.register(DateBoardTableViewHeader.self, forHeaderFooterViewReuseIdentifier: DateBoardTableViewHeader.identi)
        tableview.register(DateBoardTableViewCell.self, forCellReuseIdentifier: DateBoardTableViewCell.identi)
        return tableview
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
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
    }
    private func setNavigationBar(){
        let notiButton = UIBarButtonItem(image: UIImage(named: "BellImg"), style: .plain, target: self, action: #selector(tapNotiButton))
        notiButton.tintColor = UIColor(named: "IconColor")
        let imagebutton = UIButton()
        imagebutton.setImage(UIImage(named: "SampleImg1"), for: .normal)
        imagebutton.layer.cornerRadius = imagebutton.layer.frame.size.width / 2
        let userImageButton = UIBarButtonItem(customView: imagebutton)
        self.navigationItem.rightBarButtonItems = [userImageButton,notiButton]
    }
}

extension HomeVC : UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sampleAdvertImage.count
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
        return sampeleDateBoardData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DateBoardTableViewCell.identi, for: indexPath) as? DateBoardTableViewCell else { return UITableViewCell()}
        cell.setCell(model: sampeleDateBoardData[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: DateBoardTableViewHeader.identi) as? DateBoardTableViewHeader else {return UIView()}
        header.tapMoreViewButtonCompletion = { [unowned self] in
            let vc = DateBoardVC()
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
