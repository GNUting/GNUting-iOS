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
    let mypageConfiguration = [MyPageModel(title: "", elements: []),MyPageModel(title: "고객지원", elements: ["고객센터"]),MyPageModel(title: "계정 관리", elements: ["로그아웃","회원탈퇴"]),MyPageModel(title: "알림", elements: ["알림 설정"]),MyPageModel(title: "안내", elements: ["오픈소스 사용","개인정보 처리방침"])]
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
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupMyPageTabelView()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }
}

extension MyPageVC {
    private func setupMyPageTabelView() {
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
        cell.selectionStyle = .none
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
        switch indexPath {
        case [1,0]:
            instagramOpen()
        case [2,0]:
            logout()
        case [2,1]:
            userDelete()
        case [3,0]:
            pushViewContoller(viewController: TotalAlertVC())
        case [4,0]:
            useLicense()
        case [4,1]:
            personalInformation()
        default:
            break
        }
    }
}
extension MyPageVC : tapProfileUpateButtonDelegate {
    func tapProfileUpdateButton() {
        let vc = UpdateProfileVC()
        vc.userInfo = self.userInfo
        pushViewContoller(viewController: vc)
    }
    func getUserData(){
        APIGetManager.shared.getUserData { userData,response  in
            self.errorHandling(response: response)
            self.userInfo = userData
        }
    }
}
extension MyPageVC {
    private func logout() {
        APIPostManager.shared.postLogout { response in
            if response?.isSuccess ?? false {
                let alertController = UIAlertController(title: "로그아웃", message: "로그 아웃되었습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                    self.navigationController?.setViewControllers([LoginVC()], animated: true)
                }))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            } else { //🔨 추후 분기처리하기
                let alertController = UIAlertController(title: "로그아웃 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            }
        }
        
    }
    private func userDelete() { //회원 탈퇴
        APIDeleteManager.shared.deleteUser { response in
            if response.isSuccess {
                let alertController = UIAlertController(title: "회원탈퇴", message: "회원 탈퇴되었습니다..", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                    self.navigationController?.setViewControllers([LoginVC()], animated: true)
                }))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            } else {
                let alertController = UIAlertController(title: "회원탈퇴 실패", message: "다시 시도해주세요.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    private func personalInformation() { // 개인 정보 처리방침
        guard let url = URL(string: "https://gnuting.github.io/GNUting-PrivacyPolicy/privacy_policy"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
    private func useLicense() { // 오픈 소스 사용
        guard let url = URL(string: "https://github.com/GNUting/GNUting-iOS/blob/main/Using%20Open%20Source"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
