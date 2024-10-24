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
    var boardID: Int = 0
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
    
    private lazy var reportReasonView = ReportReasonView()
    
    private lazy var OtherReasonTextView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.textColor = UIColor(hexCode: "9F9F9F")
        textView.font = Pretendard.regular(size: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.setLayerCorner(cornerRaius: 10,borderWidth: 1,borderColor: UIColor(hexCode: "E0E0DF"))
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
        let button = UIButton()
        button.setLayerCorner(cornerRaius: 10,borderColor: UIColor(hexCode: "BEBDBD"))
        setButtonConfiguration(setButton: button, text: "취소하기", font: Pretendard.bold(size: 14), baseForefroundColor: .black)
        
        return button
    }()
    
    private lazy var reportButton: ThrottleButton = {
        let button = ThrottleButton()
        button.setLayerCorner(cornerRaius: 10)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        setButtonConfiguration(setButton: button, text: "신고하기", font: Pretendard.bold(size: 14), baseForefroundColor: .white)
        
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        setAutoLayout()
        setNavigationBarPresentType(title: "신고하기")
        setButtonAction()
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
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        reportReasonView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        OtherReasonTextView.snp.makeConstraints { make in
            make.top.equalTo(reportReasonView.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(Spacing.size25)
        }
        
        bottomButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(OtherReasonTextView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(Spacing.size25)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
    // MARK: - SetView
    
    private func setButtonConfiguration(setButton: UIButton,insets: NSDirectionalEdgeInsets = NSDirectionalEdgeInsets(top: 18, leading: 30, bottom: 18, trailing: 30), text: String, font: UIFont?, baseForefroundColor: UIColor) {
        var config = UIButton.Configuration.plain()
        config.contentInsets = insets
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font: font ?? .boldSystemFont(ofSize: 14)]))
        config.titleAlignment = .center
        config.baseForegroundColor = baseForefroundColor
        setButton.configuration = config
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
        
        userNickname == "" ? reportBoardPostAPI(category: reportCategory) : reportUserAPI(category: reportCategory)
    }
}

// MARK: - API

extension ReportVC {
    private func reportBoardPostAPI(category: String) {
        APIPostManager.shared.reportBoardPost(boardID: boardID, reportCategory: category, reportReason: OtherReasonTextView.text) { response in
            if response.isSuccess {
                self.showAlertNavigationBack(title: "글 신고 완료", message: "해당 글이 신고가 완료 되었습니다. 검토후 조치하겠습니다.", backType: .dismiss)
            } else {
                self.showAlert(title: "오류 발생", message: response.message)
            }
        }
    }
    
    private func reportUserAPI(category: String) {
        APIPostManager.shared.reportUser(nickName: self.userNickname, reportCategory: category, reportReason: OtherReasonTextView.text) { response in
            if response.isSuccess {
                self.showAlertNavigationBack(title: "유저 신고 완료", message: "해당 유저가신고가 완료 되었습니다. 검토후 조치하겠습니다.", backType: .dismiss)
            } else {
                self.showAlert(title: "오류 발생", message: response.message)
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

// MARK: - ACtion

extension ReportVC {
    private func setButtonAction() {
        reportReasonView.buttonTagClosure = { selectedTag in
            self.tag = selectedTag
        }
        
        reportButton.throttle(delay: 3) { _ in
            self.tapReportButton()
        }
        
        cancelButton.addTarget(self, action: #selector(tapDissmisButton), for: .touchUpInside)
    }
}
