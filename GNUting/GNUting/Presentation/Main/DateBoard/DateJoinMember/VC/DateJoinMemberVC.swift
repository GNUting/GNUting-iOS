//
//  DateJoinMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//
import UIKit

class DateJoinMemberVC: UIViewController {
    var userInfos : [UserInfosModel] = []
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "과팅 멤버 정보"
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        
        return label
    }()
    
    private lazy var dismissButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var memberTableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
    }
}

extension DateJoinMemberVC {
    private func setAddSubViews() {
        view.addSubViews([titleLabel,dismissButton,memberTableView])
    }
    
    private func setAutoLayout(){
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.centerX.equalToSuperview()
        }
        
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(25)
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
}



extension DateJoinMemberVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell() }
        cell.setUserInfoViews(model: userInfos[indexPath.row])
        cell.userImageTappedClosure = {
            let vc = UserDetailVC()
            vc.imaegURL = self.userInfos[indexPath.row].profileImage
            vc.userNickName = self.userInfos[indexPath.row].nickname
            vc.userDepartment = self.userInfos[indexPath.row].department
            vc.userStudentID = self.userInfos[indexPath.row].studentId
            self.presentFullScreenVC(viewController: vc)
        }
        return cell
    }

}
