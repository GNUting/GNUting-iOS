//
//  MyPageVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit
import SnapKit
class MyPageVC: UIViewController {
    let mypageConfiguration = [MyPageModel(title: "", elements: ["작성한 글 목록"]),MyPageModel(title: "고객지원", elements: ["신고하기","고객센터"]),MyPageModel(title: "계정 관리", elements: ["로그아웃","회원탈퇴"]),MyPageModel(title: "안내", elements: ["공지사항","도움말","오픈소스 사용","법적고지"])]
    
    private lazy var myPageTabelView : UITableView = {
        let tableView = UITableView(frame: .zero,style: .grouped)
        tableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: MyPageTableViewCell.identi)
        tableView.register(MyPageUserInfoTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MyPageUserInfoTableViewHeader.identi)
        tableView.register(MyPageTitleTableViewHeader.self, forHeaderFooterViewReuseIdentifier: MyPageTitleTableViewHeader.identi)
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpmyPageTabelView()
        self.navigationController?.navigationBar.isHidden = true
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
            APIGetManager.shared.getUserData { userData in
                guard let userData = userData?.result else { return }
                if let url = URL(string: userData.profileImage ?? "") {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        guard let imageData = data else { return }
                        
                        header.setUserInfoView(name: userData.nickname , studentID: userData.studentId , age: userData.age , introduce: userData.userSelfIntroduction , image:UIImage(data: imageData) ?? UIImage())
                        
                    }.resume()
                }else {
                    header.setUserInfoView(name: userData.nickname , studentID: userData.studentId , age: userData.age , introduce: userData.userSelfIntroduction , image: UIImage(systemName: "person.circle") ?? UIImage())
                }
            }
           
            return header
        }else{
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MyPageTitleTableViewHeader.identi) as? MyPageTitleTableViewHeader else { return UIView()}
            header.setTitleLabel(text: mypageConfiguration[section].title)
            return header
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
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
        let VC = UpdaetProfileVC()
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}

