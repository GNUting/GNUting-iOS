//
//  NoteDateProgressView.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

import Foundation

// MARK: - 메모 팅 진행 View

import UIKit

// MARK: - protocol

protocol NoteDateProgressViewDelegate: AnyObject {
    func noteDateProgressViewTapCancelbutton()
    func tapProgressButton()
}

final class NoteDateProgressView: UIView {
    
    // MARK: - Properties
    
    weak var writeNoteViewDelegate: NoteDateProgressViewDelegate?
    
    // MARK: - SubViews
    
    private let contentView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let explainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "메모팅을 진행하시겠습니까? "
        label.font = Pretendard.medium(size: 18)
        label.textAlignment = .center
        
        return label
    }()
    
    private let explainSubLabel: UILabel = {
        let label = UILabel()
        label.text = "예 버튼을 누르면 자동으로 채팅방이 형성됩니다."
        label.font = Pretendard.regular(size: 14)
        label.textColor = UIColor(hexCode: "666666")
        label.textAlignment = .center
        
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
    
    private lazy var cancelButton = makeThrottleButton(text: "아니오", textColor: UIColor(named: "SecondaryColor"), borderColor: UIColor(named: "SecondaryColor"), backgroundColor: .white)
    
    private lazy var progressButton = makeThrottleButton(text: "예", textColor: .white, borderColor: UIColor(named: "SecondaryColor"), backgroundColor: UIColor(named: "SecondaryColor"))
    
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

extension NoteDateProgressView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([contentView])
        contentView.addSubViews([explainTitleLabel,explainSubLabel,buttonStackView])
        buttonStackView.addStackSubViews([cancelButton,progressButton])
    }
    private func setAutoLayout() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(28)
        }
        
        explainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
        }
        
        explainSubLabel.snp.makeConstraints { make in
            make.top.equalTo(explainTitleLabel.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(explainSubLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    // MARK: SetView
    
    private func setBlureffect() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        self.isHidden = true
    }
    
    private func setButtonAction() {
        cancelButton.throttle(delay: 1) { _ in
            self.writeNoteViewDelegate?.noteDateProgressViewTapCancelbutton()
        }
        progressButton.throttle(delay: 3) { _ in
            self.writeNoteViewDelegate?.tapProgressButton()
        }
    }
}
