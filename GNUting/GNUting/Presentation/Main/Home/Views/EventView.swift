//
//  EventView.swift
//  GNUting
//
//  Created by 원동진 on 9/25/24.
//

import UIKit

protocol EventViewDelegate: AnyObject {
    func tapCancelButton()
    func tapRegisterButton(contentTextViewText: String)
}

final class EventView: UIView {
    
    // MARK: - Properties
    
    weak var eventViewDelegate: EventViewDelegate?
    
    // MARK: - SubViews
    
    private let contentView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 남겨주세요 :)"
        label.font = Pretendard.medium(size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.textPadding = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        textField.placeholder = "닉네임을 입력해주세요."
        
        return textField
    }()
    
    private lazy var buttonStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var cancelButton = makeButton(text: "취소하기", textColor: UIColor(named: "SecondaryColor"), borderColor: UIColor(named: "SecondaryColor"), backgroundColor: .white)
    
    private lazy var registerButton = makeButton(text: "등록하기", textColor: .white, borderColor: UIColor(named: "SecondaryColor"), backgroundColor: UIColor(named: "SecondaryColor"))
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
        setBlureffect()
        setButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([contentView])
        contentView.addSubViews([explainLabel,nicknameTextField, buttonStackView])
        buttonStackView.addStackSubViews([cancelButton,registerButton])
    }
    private func setAutoLayout() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.5)
            make.left.right.equalToSuperview().inset(28)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-22)
        }
    }
    
    // MARK: SetView
    
    private func setBlureffect() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        self.isHidden = true
    }
    
    private func setButtonAction() {
        cancelButton.throttle(delay: 1) { _ in
            self.eventViewDelegate?.tapCancelButton()
        }
        
        registerButton.throttle(delay: 3) { _ in
            self.eventViewDelegate?.tapRegisterButton(contentTextViewText: self.nicknameTextField.text ?? "")
        }
    }
}
