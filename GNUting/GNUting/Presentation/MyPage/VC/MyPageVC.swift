//
//  MyPageVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit
import SnapKit
// MARK: - 마이 페이지
class MyPageVC: UIViewController {
    let mypageConfiguration = [MyPageModel(title: "", elements: ["작성한 글 목록"]),MyPageModel(title: "고객지원", elements: ["신고하기","고객센터"]),MyPageModel(title: "계정 관리", elements: ["로그아웃","회원탈퇴"]),MyPageModel(title: "안내", elements: ["공지사항","도움말","오픈소스 사용","법적고지"])]
    var userInfo : GetUserDataModel? {
        didSet{
            myPageTabelView.reloadData()
        }
    }
    private lazy var myPageTabelView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identi)
        tableView.register(MyPageUserInfoTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MyPageUserInfoTableViewHeader.identi)
        tableView.register(MyPageTitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MyPageTitleTableViewHeader.identi)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.backgroundColor = .white
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpmyPageTabelView()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        tabBarController?.tabBar.isHidden = false
    }
}

extension MyPageVC {
    private func setUpmyPageTabelView() {
        view.addSubview(myPageTabelView)
        myPageTabelView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        myPageTabelView.delegate = self
        myPageTabelView.dataSource = self
        
        
    }
    
}
extension MyPageVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mypageConfiguration.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mypageConfiguration[section].elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identi, for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell()}
        cell.setCell(text: mypageConfiguration[indexPath.section].elements[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageUserInfoTableViewHeader.identi) as? MyPageUserInfoTableViewHeader else {return UIView()}
            header.profileUpdateButtonDelegate = self
            
            if let userData = userInfo?.result {
                header.setInfoView(image: userData.profileImage, name: userData.name, studentID: userData.studentId, age: userData.age, major: userData.department, introuduce: userData.userSelfIntroduction)
            }
            return header
        }else{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageTitleTableViewHeader.identi) as? MyPageTitleTableViewHeader else { return UIView()}
            header.setTitleLabel(text: mypageConfiguration[section].title)
            return header
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 150
        } else {
            return 25
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = UserWriteTextVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension MyPageVC : tapProfileUpateButtonDelegate {
    func tapProfileUpdateButton() {
        let vc = UpdateProfileVC()
        vc.userInfo = self.userInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getUserData(){
        APIGetManager.shared.getUserData { userData in
            self.userInfo = userData
        }
    }
}

