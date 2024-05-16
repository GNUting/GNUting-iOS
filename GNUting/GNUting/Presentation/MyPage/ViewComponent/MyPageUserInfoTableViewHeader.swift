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
    private lazy var upperView = UIView()
    private lazy var userImageButton = UIButton()
    
    private lazy var labelStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 18)

        return label
    }()
    private lazy var subInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 16)

        return label
    }()
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 16)
 
        return label
    }()
    private lazy var updateProfileButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("프로필 수정", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)!]))
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
        contentView.addSubViews([upperView,updateProfileButton])
        upperView.addSubViews([userImageButton,labelStackView])
        labelStackView.addStackSubViews([nameLabel,subInfoLabel,introduceLabel])
    }
    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.right.equalToSuperview()
        }
        userImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            
            make.height.width.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(userImageButton.snp.right).offset(10)
            make.right.equalToSuperview()
            
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(upperView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    @objc private func tapUpdateProfileButton() {
        self.profileUpdateButtonDelegate?.tapProfileUpdateButton()
    }
}
extension MyPageUserInfoTableViewHeader {
    func setInfoView(image: String?, name: String, studentID: String, age: String, major: String,introuduce: String){
        nameLabel.text = name
        subInfoLabel.text = "\(studentID) | \(major)"
        introduceLabel.text = "\(introuduce)"
        setImageFromStringURL(stringURL: image) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
                
            }
            
        }
    }
}
