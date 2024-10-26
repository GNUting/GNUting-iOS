//
//  MyPageVC.swift
//  GNUting
//
//  Created by 원동진 on 2/17/24.
//

import UIKit
import SnapKit
// MARK: - 마이 페이지
class MyPageVC: BaseViewController {
    let mypageConfiguration = [MyPageModel(title: "", elements: []),MyPageModel(title: "고객지원", elements: ["고객센터"]),MyPageModel(title: "계정 관리", elements: ["로그아웃","회원탈퇴"]),MyPageModel(title: "알림", elements: ["알림 설정"]),MyPageModel(title: "안내", elements: ["오픈소스 사용","개인정보 처리방침","서비스 이용약관"])]
    var userInfo : GetUserDataModel? {
        didSet {
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 5
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                header.setInfoView(image: userData.profileImage, name: userData.nickname, studentID: userData.studentId, age: userData.age, major: userData.department, introuduce: userData.userSelfIntroduction)
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
            return 170
        } else {
            return 35
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
            pushViewController(viewController: TotalAlertVC())
        case [4,0]:
            useLicense()
        case [4,1]:
            personalInformation()
        case [4,2]:
            termsConditions()
        default:
            break
        }
    }
}
extension MyPageVC : tapProfileUpateButtonDelegate {
    func tapProfileUpdateButton() {
        let vc = UpdateProfileVC()
        vc.userInfo = self.userInfo
        pushViewController(viewController: vc)
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
        let alertController = UIAlertController(title: "", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
            self.userLogOutAPI()
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    private func userLogOutAPI() {
        APIPostManager.shared.postLogout { response in
            if response?.isSuccess ?? false {
                let alertController = UIAlertController(title: "로그아웃", message: "로그아웃 되었습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { _ in
                    self.view.window?.rootViewController = UINavigationController.init(rootViewController: LoginVC())
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
        
        let alertController = UIAlertController(title: "", message: "회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "아니요", style: .destructive))
        alertController.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
            self.userDeleteAPI()
        }))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
    private func userDeleteAPI() {
        APIDeleteManager.shared.deleteUser { response in
            if response.isSuccess {
                let alertController = UIAlertController(title: "", message: "회원 탈퇴되었습니다.", preferredStyle: .alert)
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
    private func termsConditions() { // 이용약관
        guard let url = URL(string: "https://equal-kiwi-602.notion.site/9021bea8cf1841fc8a83d26a06c8e72c"), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
