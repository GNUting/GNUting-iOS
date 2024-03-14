//
//  MyPageTableViewHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit
protocol tapProfileUpateButtonDelegate : AnyObject{
    func tapProfileUpdateButton()
}
class MyPageUserInfoTableViewHeader: UITableViewHeaderFooterView {
    static let identi = "MyPageTableViewUserInfoHeaderid"
    var profileUpdateButtonDelegate : tapProfileUpateButtonDelegate?
    private lazy var userInfoView : UserInfoDetailView = {
        let view = UserInfoDetailView()
        view.hiddenBorder()
        return view
    }()
    
    private lazy var updateProfileButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("프로필 수정", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 20)!]))
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10)
        let button = UIButton(configuration: config)
        button.backgroundColor = UIColor(hexCode: "F5F5F5")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapUpdateProfileButton), for: .touchUpInside)
        return button
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setHeader()
        setAddSubViews()
        setAutoLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MyPageUserInfoTableViewHeader{
  
    private func setAddSubViews() {
        contentView.addSubViews([userInfoView,updateProfileButton])
    }
    private func setAutoLayout(){
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(userInfoView.snp.bottom).offset(Spacing.top)
            make.left.right.bottom.equalToSuperview()
        }
    }
    @objc private func tapUpdateProfileButton() {
        self.profileUpdateButtonDelegate?.tapProfileUpdateButton()
    }
}
extension MyPageUserInfoTableViewHeader {
    func setUserInfoView(name :String,studentID: String, age: String, introduce: String, image : String?) {
        userInfoView.setUserInfoDetailView(name: name, studentID: studentID, age: age, introduce: introduce, image: image)
    }
}

