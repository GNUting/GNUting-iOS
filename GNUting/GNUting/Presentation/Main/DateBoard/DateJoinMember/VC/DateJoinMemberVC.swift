//
//  DateJoinMemberVC.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//
import UIKit

class DateJoinMemberVC: BaseViewController {
    
    // MARK: - Properties
    
    var userInfos: [UserInfosModel] = []
    
    // MARK: - SubViews
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "과팅 멤버 정보"
        label.font = Pretendard.medium(size: 18)
        
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "DissmissImg"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var memberTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(MemberTableViewCell.self, forCellReuseIdentifier: MemberTableViewCell.identi)
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
    }
}

extension DateJoinMemberVC {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        view.addSubViews([titleLabel, dismissButton, memberTableView])
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
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
}

// MARK: - UITableView DataSource

extension DateJoinMemberVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemberTableViewCell.identi, for: indexPath) as? MemberTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setUserInfoViews(model: userInfos[indexPath.row])
        cell.userImageTappedClosure = {
            let vc = UserDetailVC()
            vc.userDetailData = UserDetailModel(imageURL: self.userInfos[indexPath.row].profileImage,
                                                nickname: self.userInfos[indexPath.row].nickname,
                                                userStudentID: self.userInfos[indexPath.row].studentId, 
                                                userDepartment: self.userInfos[indexPath.row].department)
            self.presentViewController(viewController: vc, modalPresentationStyle: .fullScreen)
        }
        return cell
    }

}
