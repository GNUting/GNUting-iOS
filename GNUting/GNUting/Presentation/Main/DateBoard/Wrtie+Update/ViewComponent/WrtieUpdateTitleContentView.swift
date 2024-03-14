//
//  WriteDateBoardTitleContentView.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit
//MARK: - 제목, 내용 입력 화면
class WrtieUpdateTitleContentView: UIView {
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
        textField.font = UIFont(name: Pretendard.Bold.rawValue, size: 18)
        textField.textColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "제목",attributes: [NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)!,NSAttributedString.Key.foregroundColor : UIColor(hexCode: "9F9F9F")])
        return textField
    }()
    private lazy var borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    lazy var contentTextView : UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        textView.textColor = UIColor(hexCode: "9F9F9F")
        return textView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
}
extension WrtieUpdateTitleContentView{
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

}
extension WrtieUpdateTitleContentView{
    public func setTitleTextFieldText(text : String) {
        titleTextField.text = text
    }
    public func setContentTextView(text : String) {
        contentTextView.text = text
    }
    public func setContentTextViewTextColor(color : UIColor){
        contentTextView.textColor = color
    }
}
