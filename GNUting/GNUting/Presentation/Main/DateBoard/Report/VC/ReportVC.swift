//
//  ReportVC.swift
//  GNUting
//
//  Created by 원동진 on 2/23/24.
//

// MARK: - 사용자 및 게시글 신고하기 ViewController

import UIKit

final class ReportVC: BaseViewController {
    
    // MARK: - Properties
    
    var userNickname: String = ""
    private var boardID: Int = 0
    private var tag: Int = 0
    private let textViewPlaceHolder = Strings.Report.textViewPlaceHolder
    
    // MARK: - SubViews
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Pretendard.medium(size: 9)
        label.numberOfLines = 0
        label.text = Strings.Report.explain
        label.setRangeTextFont(fullText: Strings.Report.explain, range: "신고하기 전에 잠깐!", font: Pretendard.bold(size: 12) ?? .systemFont(ofSize: 12))
        
        return label
    }()
    
    private lazy var reportReasonView: ReportReasonView = {
        let view = ReportReasonView()
        view.buttonTagClosure = { selectedTag in
            self.tag = selectedTag
        }
        
        return view
    }()
    
    private lazy var OtherReasonTextView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.textColor = UIColor(hexCode: "9F9F9F")
        textView.font = Pretendard.regular(size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(hexCode: "E0E0DF").cgColor
        textView.layer.masksToBounds = true
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var bottomButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 30, bottom: 18, trailing: 30)
        config.attributedTitle = AttributedString("취소하기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.bold(size: 14) ?? .boldSystemFont(ofSize: 14)]))
        config.titleAlignment = .center
        config.baseForegroundColor = .black
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexCode: "BEBDBD").cgColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var reportButton: ThrottleButton = {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 30, bottom: 18, trailing: 30)
        config.attributedTitle = AttributedString("신고하기", attributes: AttributeContainer([NSAttributedString.Key.font: Pretendard.bold(size: 14) ?? .boldSystemFont(ofSize: 14)]))
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        let button = ThrottleButton(configuration: config)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.throttle(delay: 3) { _ in
            self.tapReportButton()
        }
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        setNavigationBarPresentType(title: "신고하기")
    }
}

extension ReportVC {
    
    // MARK: - Layout Helpers
    
    private func addSubViews() {
        view.addSubViews([explainLabel, reportReasonView, OtherReasonTextView, bottomButtonStackView])
        bottomButtonStackView.addStackSubViews([cancelButton, reportButton])
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

// MARK: - Private Method

extension ReportVC {
    private func tapReportButton() {
        var reportCategory = ""
        switch tag {
        case 1:
            reportCategory = ReportCategory.COMMERCIAL_SPAM.category
        case 2:
            reportCategory = ReportCategory.ABUSIVE_LANGUAGE.category
        case 3:
            reportCategory = ReportCategory.OBSCENITY.category
        case 4:
            reportCategory = ReportCategory.FLOODING.category
        case 5:
            reportCategory = ReportCategory.PRIVACY_VIOLATION.category
        default:
            reportCategory = ReportCategory.OTHER.category
        }
        if userNickname == "" {
            
            APIPostManager.shared.reportBoardPost(boardID: boardID, reportCategory: reportCategory, reportReason: OtherReasonTextView.text) { response in
                if response.isSuccess {
                    let alertController = UIAlertController(title: "글 신고 완료", message: "해당 글이 신고가 완료 되었습니다. 검토후 조치하겠습니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { action in
                        self.tapDissmisButton()
                    }))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "오류 발생", message: response.message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                }
            }
            
        } else {
            APIPostManager.shared.reportUser(nickName: self.userNickname, reportCategory: reportCategory, reportReason: OtherReasonTextView.text) { response in
                if response.isSuccess {
                    let alertController = UIAlertController(title: "유저 신고 완료", message: "해당 유저가신고가 완료 되었습니다. 검토후 조치하겠습니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .default,handler: { action in
                        self.tapDissmisButton()
                    }))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                }else {
                    let alertController = UIAlertController(title: "오류 발생", message: response.message, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "확인", style: .cancel))
                    DispatchQueue.main.async {
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - Delegate

extension ReportVC: UITextViewDelegate {
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

