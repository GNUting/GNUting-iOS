//
//  ReportVC.swift
//  GNUting
//
//  Created by 원동진 on 2/23/24.
//

import UIKit

class ReportVC: UIViewController {
    let textViewPlaceHolder = "기타 사유를 입력해주세요."
    private let explainLabel : UILabel = {
        let fullText = """
신고하기 전에 잠깐!
이 글이 운영진에 의해 삭제되어야 마땅하다고 생각된다면 신고해주세요!
이용규칙에 위배되는 글을 여러 차례 계시하여 신고를 많이 받은 회원은 제한 조취가 취해집니다.

신고는 사용자의 반대 의견을 표시하는 것이 아닙니다.
사용자의 신고가 건전하고 올바른 지누팅 문화를 만듭니다.
허위 신고의 경우 신고자가 제재를 받을 수 있습니다.
"""
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 9)
        label.numberOfLines = 0
        label.text = fullText
        label.setRangeTextFont(fullText: fullText, range: "신고하기 전에 잠깐!", uiFont: UIFont(name: Pretendard.Bold.rawValue, size: 12)!)
        return label
    }()
    private lazy var reportReasonView : ReportReasonView = {
        let view = ReportReasonView()
        return view
    }()
    private lazy var OtherReasonTextView : UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.textColor = UIColor(hexCode: "9F9F9F")
        textView.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(hexCode: "E0E0DF").cgColor
        textView.layer.masksToBounds = true
        textView.delegate = self
        return textView
    }()
    private lazy var bottomButtonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 12
        return stackView
    }()
    private lazy var cancelButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 30, bottom: 18, trailing: 30)
        config.attributedTitle = AttributedString("취소하기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: "BEBDBD").cgColor
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var reportButton : UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 30, bottom: 18, trailing: 30)
        config.attributedTitle = AttributedString("신고하기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: Pretendard.Bold.rawValue, size: 14)!]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(named: "PrimaryColor")
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
        addSubViews()
        setAutoLayout()
        setNavigationBar()
    }
}
extension ReportVC{
    private func setVC(){
        view.backgroundColor = .white
    }
    private func setNavigationBar(){
        navigationItem.title = "신고하기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)! ]
    }
    
}
extension ReportVC{
    private func addSubViews() {
        view.addSubViews([explainLabel,reportReasonView,OtherReasonTextView,bottomButtonStackView])
        bottomButtonStackView.addStackSubViews([cancelButton,reportButton])
    }
    private func setAutoLayout() {
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        reportReasonView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        OtherReasonTextView.snp.makeConstraints { make in
            make.top.equalTo(reportReasonView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        
        bottomButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(OtherReasonTextView.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
}
extension ReportVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = UIColor(hexCode: "9F9F9F")
        }
    }
}
