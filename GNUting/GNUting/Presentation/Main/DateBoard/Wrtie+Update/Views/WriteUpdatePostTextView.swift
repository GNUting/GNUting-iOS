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

class WriteUpdatePostTextView: UIView{
    weak var wrtieUpdatePostTextViewDelegate: WriteUpdatePostTextViewDelegate?
    private lazy var upperView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var titleTextField : UITextField = {
        let textField = UITextField()
        textField.font = Pretendard.bold(size: 18)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "제목",attributes: [NSAttributedString.Key.font: Pretendard.medium(size: 18) ?? .systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor(hexCode: "9F9F9F")])
        textField.delegate = self
        textField.returnKeyType = .done
        
        return textField
    }()
    private lazy var borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    lazy var contentTextView : UITextView = {
        let textView = UITextView()
        textView.text = Strings.WriteDateBoard.textPlaceHolder
        textView.font = Pretendard.regular(size: 18)
        textView.textColor = UIColor(hexCode: "9F9F9F")
        textView.delegate = self
        
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setkeyboardToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
extension WriteUpdatePostTextView {
    private func configure(){
        addSubview(upperView)
        upperView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        upperView.addStackSubViews([titleTextField,borderView,contentTextView])
        borderView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    private func setkeyboardToolbar() {
        let keyboardToolbar = UIToolbar()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(tapDoneButton))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        keyboardToolbar.sizeToFit()
        keyboardToolbar.tintColor = UIColor.systemGray

        contentTextView.inputAccessoryView = keyboardToolbar
    }
    @objc private func tapDoneButton() {
        wrtieUpdatePostTextViewDelegate?.tapDoneButton()
    }
}
extension WriteUpdatePostTextView {
    func setTitleTextFieldText(text : String) {
        titleTextField.text = text
    }
    func setContentTextView(text : String) {
        contentTextView.text = text
    }
    func setContentTextViewTextColor(color : UIColor){
        contentTextView.textColor = color
    }
    
    func getTitleTextFieldText() -> String? {
        return titleTextField.text
    }
    
    func getContentTextViewText() -> String {
        return contentTextView.text
    }
}
extension WriteUpdatePostTextView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
    }
}

extension WriteUpdatePostTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
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
