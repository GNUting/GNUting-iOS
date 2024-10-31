//
//  WriteDateBoardTitleContentView.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

// MARK: - 제목, 내용 입력 View

import UIKit

// MARK: - protocol

protocol WriteUpdatePostTextViewDelegate: AnyObject {
    func tapDoneButton()
}

class WriteUpdatePostTextView: UIView {
    
    // MARK: - Properties
    
    weak var wrtieUpdatePostTextViewDelegate: WriteUpdatePostTextViewDelegate?
    var content = ""
    
    // MARK: - SubViews
    
    private lazy var upperView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.font = Pretendard.bold(size: 18)
        textField.attributedPlaceholder = NSAttributedString(string: "제목",attributes: [NSAttributedString.Key.font: Pretendard.medium(size: 18) ?? .systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor(hexCode: "9F9F9F")])
        textField.returnKeyType = .done
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        
        return view
    }()
    
    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = Strings.WriteDateBoard.textPlaceHolder
        textView.textColor = UIColor(hexCode: "9F9F9F")
        textView.font = Pretendard.regular(size: 18)
        textView.inputAccessoryView = doneButton
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var doneButton: UIButton = {
       let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.font = Pretendard.regular(size: 10)
        button.addTarget(self, action: #selector(tapDoneButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WriteUpdatePostTextView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        addSubview(upperView)
        upperView.addStackSubViews([titleTextField,borderView,contentTextView])
    }
    
    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        borderView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
    }
    
    // MARK: - Internal Method
    
    func setTitleTextFieldText(text : String) {
        titleTextField.text = text
    }
    
    func setContentTextView(text : String) {
        contentTextView.text = text
    }
    
    func getTitleTextFieldText() -> String? {
        return titleTextField.text
    }
    
    func getContentTextViewText() -> String {
        return contentTextView.text
    }
}

// MARK: - Delegate

extension WriteUpdatePostTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
}

extension WriteUpdatePostTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == content {
            textView.textColor = .black
        }
    
        if textView.text == Strings.WriteDateBoard.textPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = Strings.WriteDateBoard.textPlaceHolder
            textView.textColor = UIColor(hexCode: "9F9F9F")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = contentTextView.text ?? ""
        guard let stringRange = Range(range,in: currentText) else { return false}
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.count <= 300
    }
}

// MARK: - Action

extension WriteUpdatePostTextView {
    @objc private func tapDoneButton() {
        wrtieUpdatePostTextViewDelegate?.tapDoneButton()
    }
}
