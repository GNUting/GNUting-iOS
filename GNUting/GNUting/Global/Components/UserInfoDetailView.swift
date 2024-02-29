//
//  UserInfoDetailView.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

class UserInfoDetailView: UIView { // 한줄소개 있음
    private lazy var upperView : UIView = {
        let stackView = UIView()
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var firstStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var userImageButton : UIButton = {
        let imagebutton = UIButton()
        imagebutton.setImage(UIImage(named: "SampleImg1"), for: .normal)
        imagebutton.layer.cornerRadius = imagebutton.layer.frame.size.width / 2
        return imagebutton
    }()
 
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "전병규"
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subInfoLabel : UILabel = { // 학번 나이
        let label = UILabel()
        label.text = "20학번|23살"
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        label.textColor = UIColor(hexCode: "767676")
        label.textAlignment = .left
        return label
    }()
    
    private lazy var selfIntroduceLabel : UILabel = { // 한줄 소개
        let label = UILabel()
        label.text = "안녕하세요 재밌게 놀아요."
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddsubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension UserInfoDetailView{
    private func setAddsubViews() {
        self.addSubview(upperView)
        upperView.addSubViews([firstStackView,subInfoLabel,selfIntroduceLabel])
        firstStackView.addStackSubViews([userImageButton,userNameLabel])
    }

    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        selfIntroduceLabel.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        userImageButton.setContentHuggingPriority(.init(251), for: .horizontal)
    }
    func hiddenBorder(){
        upperView.layer.borderWidth = 0
    }
}
