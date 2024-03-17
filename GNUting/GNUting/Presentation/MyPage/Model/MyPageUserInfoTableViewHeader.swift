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
    
    private lazy var userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SampleImg1")
        return imageView
    }()
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
        label.text = "이름"
        return label
    }()
    private lazy var subInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 16)
        label.text = "학과|나이|학번"
        return label
    }()
    private lazy var introduceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 16)
        label.text = "자기소개"
        return label
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
        contentView.addSubViews([userImageView,labelStackView])
        labelStackView.addStackSubViews([nameLabel,subInfoLabel,introduceLabel])
    }
    private func setAutoLayout() {
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
            make.height.width.equalTo(70)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    @objc private func tapUpdateProfileButton() {
        self.profileUpdateButtonDelegate?.tapProfileUpdateButton()
    }
}
extension MyPageUserInfoTableViewHeader {
    func setInfoView(image: String?, name: String, studentID: String, age: String, major: String,introuduce: String){
        nameLabel.text = name
        subInfoLabel.text = "\(major)|\(age)|\(studentID)"
        introduceLabel.text = "\(introuduce)"
        setImageFromStringURL(stringURL: image) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = 35
                self.userImageView.layer.masksToBounds = true
            }
            
        }
    }
}
