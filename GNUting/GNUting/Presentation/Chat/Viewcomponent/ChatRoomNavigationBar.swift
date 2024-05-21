//
//  ChatRoomNavigationBar.swift
//  GNUting
//
//  Created by 원동진 on 5/21/24.
//

import UIKit
protocol NaviagtionBarButtonDelegate {
    func tappedBackButton()
    func tappedSettingButton()
}
class ChatRoomNavigationBar: UIView {
    var naviagtionBarButtonDelegate: NaviagtionBarButtonDelegate?
    private lazy var backButton : BackButton = {
       let button = BackButton()
        button.addTarget(self, action: #selector(tapBackButton), for: .touchUpInside)
        return button
    }()
    private lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        return label
    }()
    private lazy var settingButton : UIButton =  {
       let button = UIButton()
        button.setImage(UIImage(named: "ChatRoomSetImage"), for: .normal)
        button.tintColor = UIColor(named: "IconColor")
        button.addTarget(self, action: #selector(tapSettingButton), for: .touchUpInside)
        return button
    }()
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.textColor = UIColor(hexCode: "767676")
        
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ChatRoomNavigationBar{
    private func setAddSubViews() {
        self.addSubViews([backButton,titleLabel,settingButton,subTitleLabel])
    }
    private func setAutoLayout(){
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}

extension ChatRoomNavigationBar {
    func setLabel(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}

extension ChatRoomNavigationBar {
    @objc private func tapBackButton() {
        naviagtionBarButtonDelegate?.tappedBackButton()
    }
    @objc private func tapSettingButton() {
        naviagtionBarButtonDelegate?.tappedSettingButton()
    }
}
