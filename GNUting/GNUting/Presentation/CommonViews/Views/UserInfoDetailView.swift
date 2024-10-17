//
//  UserInfoDetailView.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//
// MARK: - 유저 정보 한줄 소개 있는 버전
// MARK: - 사용 되는 곳 : 멤버 검색 ViewController, DateMemeberTableViewCell, MemberTableViewCell

import UIKit

// MARK : - protocol

protocol UserInfoDetailViewDelegate: AnyObject {
    func tapUserImageButton()
}

class UserInfoDetailView: UIView {
    
    // MARK: - Properties
    
    weak var userInfoDetailViewDelegate: UserInfoDetailViewDelegate?
    
    // MARK: - SubViews
    
    private lazy var infoUpperView = UIView()
    
    private lazy var middleTopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var userImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapUserImageButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subInfoLabel: UILabel = { // 학번 나이
        let label = UILabel()
        label.font = Pretendard.medium(size: 12)
        label.textColor = UIColor(named: "DisableColor")
        label.textAlignment = .left
        
        return label
    }()
    private lazy var selfIntroduceLabel: UILabel = { // 한줄 소개
        let label = UILabel()
        label.font = Pretendard.medium(size: 12)
        label.textColor = UIColor(named: "DisableColor")
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddsubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UserInfoDetailView {
    
    // MARK: - Layout Helpers
    
    private func setAddsubViews() {
        self.addSubViews([userImageButton, infoUpperView])
        infoUpperView.addSubViews([middleTopStackView, selfIntroduceLabel])
        middleTopStackView.addStackSubViews([userNameLabel, subInfoLabel])
        
    }
    
    private func setAutoLayout() {
        userImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.top.left.bottom.equalToSuperview()
        }
        
        infoUpperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview()
            make.left.equalTo(userImageButton.snp.right).offset(10)
        }
        
        middleTopStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        selfIntroduceLabel.snp.makeConstraints { make in
            make.top.equalTo(middleTopStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        userNameLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        subInfoLabel.setContentHuggingPriority(.init(250), for: .horizontal)
        userNameLabel.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        subInfoLabel.setContentCompressionResistancePriority(.init(750), for: .horizontal)
    }
    
    // MARK: - SetView
    
    func setUserInfoDetailView(name :String?,major: String?,studentID: String?, introduce: String?, image : String? ) {
        self.userNameLabel.text = name
        self.subInfoLabel.text = "\(studentID ?? "학번") | \(major ?? "과")"
        self.selfIntroduceLabel.text = introduce
        self.setImageFromStringURL(stringURL: image) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
        
    }
    
    // MARK: - Action
    
    @objc private func tapUserImageButton() {
        userInfoDetailViewDelegate?.tapUserImageButton()
    }
}
