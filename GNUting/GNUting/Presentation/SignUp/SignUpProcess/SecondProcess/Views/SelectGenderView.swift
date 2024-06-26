//
//  SelectGenderView.swift
//  GNUting
//
//  Created by 원동진 on 2/8/24.
//

// MARK: - 회원가입 (2) 성별 선택 View

import UIKit

class SelectGenderView: UIView {
    
    // MARK: - Properties
    
    var selectedGender: Int = 0 // 0 : 남자 , 1:여자

    // MARK: - SubViews
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = Pretendard.semiBold(size: 14)
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    private lazy var manTypeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("남", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .systemFont(ofSize: 16)]))
        config.baseForegroundColor = UIColor(hexCode: "767676")
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        button.backgroundColor = UIColor(hexCode: "F5F5F5")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        button.tag = 0
        
        return button
    }()
    
    private lazy var girlTypeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("여", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .systemFont(ofSize: 16)]))
        config.baseForegroundColor = UIColor(hexCode: "767676")
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        config.titleAlignment = .center
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        button.backgroundColor = UIColor(hexCode: "F5F5F5")
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        button.tag = 1
        
        return button
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension SelectGenderView {
    private func setAddSubViews() {
        self.addSubViews([typeLabel,buttonStackView])
        
        buttonStackView.addStackSubViews([manTypeButton,girlTypeButton])
    }
    
    private func setAutoLayout() {
        typeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
    }
}

// MARK: - Action

extension SelectGenderView {
    @objc func tapButton(_ sender : UIButton) {
        selectedGender = sender.tag
        if sender.tag == 0{
            isSelctedButton(text: "남", isSelcted: true, button: manTypeButton)
            isSelctedButton(text: "여", isSelcted: false, button: girlTypeButton)
        } else {
            isSelctedButton(text: "여", isSelcted: true, button: girlTypeButton)
            isSelctedButton(text: "남", isSelcted: false, button: manTypeButton)
        }
    }
    
    func isSelctedButton(text: String,isSelcted : Bool,button : UIButton){
        if isSelcted{
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .systemFont(ofSize: 16)]))
            config.baseForegroundColor = UIColor(named: "PrimaryColor")
            config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
            config.titleAlignment = .center
            button.configuration = config
            button.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
            button.backgroundColor = UIColor(named: "PrimaryColor")?.withAlphaComponent(0.3)
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
        } else {
            var config = UIButton.Configuration.plain()
            config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.medium(size: 16) ?? .systemFont(ofSize: 16)]))
            config.baseForegroundColor = UIColor(hexCode: "767676")
            config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
            config.titleAlignment = .center
            button.configuration = config
            button.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
            button.backgroundColor = UIColor(hexCode: "F5F5F5")
            button.layer.cornerRadius = 10
            button.layer.masksToBounds = true
            button.layer.borderWidth = 1
        }
    }
}

// MARK: - Method public

extension SelectGenderView {
    func getSelectedGender() -> String{
        if selectedGender == 0 {
            return "MALE"
        } else {
            return "FEMALE"
        }
    }
}
