//
//  EventView.swift
//  GNUting
//
//  Created by 원동진 on 9/25/24.
//

// MARK: - 이벤트 관련 View

import UIKit

protocol EventViewDelegate: AnyObject {
    func tapCancelButton()
    func tapRegisterButton(textFiledText: String)
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
        label.text = "닉네임을 입력해 주세요 :)"
        label.font = Pretendard.medium(size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.textPadding = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        textField.placeholder = "닉네임을 입력해 주세요."
        textField.backgroundColor = UIColor(hexCode: "EEEEEE")
        textField.textColor = UIColor(hexCode: "717171")
        return textField
    }()
    
    private lazy var explainSubLabel: UILabel = {
        let label = UILabel()
        let style = NSMutableParagraphStyle()
        let text = """
         - 본 메모팅은 대동제 기간 동안 진행되는 오감 총학생회와 지누팅의 콜라보 이벤트입니다.
         - 대동제 종료 후, 지누팅 애플리케이션을 통해 언제든지 메모팅을 진행하실 수 있습니다.
        """
        label.textColor = UIColor(hexCode: "AEAEAE")
        label.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: style])
        label.font = Pretendard.regular(size: 10)
        label.numberOfLines = 4
        style.lineBreakStrategy = .hangulWordPriority
        
        
        return label
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var cancelButton = makeThrottleButton(text: "취소하기", textColor: UIColor(named: "SecondaryColor"), borderColor: UIColor(named: "SecondaryColor"), backgroundColor: .white)
    
    private lazy var registerButton = makeThrottleButton(text: "신청하기", textColor: .white, borderColor: UIColor(named: "SecondaryColor"), backgroundColor: UIColor(named: "SecondaryColor"))
    
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
        contentView.addSubViews([explainLabel,nicknameTextField,  explainSubLabel, buttonStackView])
        buttonStackView.addStackSubViews([cancelButton,registerButton])
    }
    
    private func setAutoLayout() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //            make.height.equalTo(self.snp.width).multipliedBy(0.8)
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
        
        explainSubLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(explainSubLabel.snp.bottom).offset(23)
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
            self.eventViewDelegate?.tapRegisterButton(textFiledText: self.nicknameTextField.text ?? "")
        }
    }
}
