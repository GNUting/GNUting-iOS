//
//  WriteNoteView.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 메모 작성 View

import UIKit

// MARK: - protocol

protocol WriteNoteViewDelegate: AnyObject {
    func writeNoteViewtapCancelbutton()
    func tapRegisterButton(contentTextViewText: String)
}

final class WriteNoteView: UIView {
    
    // MARK: - Properties
    
    weak var writeNoteViewDelegate: WriteNoteViewDelegate?
    private let textViewPlaceHolder = "메모를 입력해주세요."
    
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
        label.text = "메모를 남겨주세요 :)"
        label.font = Pretendard.medium(size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var noteContentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor(hexCode: "E6E6E6")
        textView.textColor = .black
        textView.font = Pretendard.medium(size: 12)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.text = textViewPlaceHolder
        textView.delegate = self
        
        return textView
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
    
    private lazy var registerButton = makeThrottleButton(text: "등록하기", textColor: .white, borderColor: UIColor(named: "SecondaryColor"), backgroundColor: UIColor(named: "SecondaryColor"))
    
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

extension WriteNoteView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([contentView])
        contentView.addSubViews([explainLabel,noteContentTextView,buttonStackView])
        buttonStackView.addStackSubViews([cancelButton,registerButton])
    }
    private func setAutoLayout() {
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(self.snp.width).multipliedBy(0.8)
            make.left.right.equalToSuperview().inset(28)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        noteContentTextView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(noteContentTextView.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-22)
        }
    }
    
    // MARK: - SetView
    
    private func setBlureffect() {
        self.backgroundColor = .black.withAlphaComponent(0.4)
        self.isHidden = true
    }
    
    private func setButtonAction() {
        cancelButton.throttle(delay: 1) { _ in
            self.writeNoteViewDelegate?.writeNoteViewtapCancelbutton()
        }
        
        registerButton.throttle(delay: 3) { _ in
            self.writeNoteViewDelegate?.tapRegisterButton(contentTextViewText: self.noteContentTextView.text)
        }
    }
}

// MARK: - Delegate

extension WriteNoteView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .black
        }
    }
}
