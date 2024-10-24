//
//  ReportReasonVioew.swift
//  GNUting
//
//  Created by 원동진 on 2/25/24.
//

// MARK: - Report VC 신고 목록 View

import UIKit

class ReportReasonView: UIView {
    
    // MARK: - Properties
    
    var buttonTagClosure: ((Int)->())?
    
    // MARK: - SubViews
    
    private let reportResonLabel: UILabel =  {
        let label = UILabel()
        label.font = Pretendard.bold(size: 12)
        label.textAlignment = .left
        label.text = "신고 사유"
        return label
    }()
    
    private lazy var upperStackView = makeStackView(axis: .horizontal,distribution: .equalSpacing,alignment: .fill,spacing: 30)
    private lazy var firstBusttonStackView = makeStackView()
    private lazy var secondBusttonStackView = makeStackView()
    
    private lazy var reportReasonFirstButton = makeReportReasonCheckButton(text: "영리목적/홍보성", tag: 1)
    private lazy var reportReasonSecondButton = makeReportReasonCheckButton(text: "욕설/인신공격", tag: 2)
    private lazy var reportReasonThirdButton = makeReportReasonCheckButton(text: "음란성/선정성", tag: 3)
    private lazy var reportReasonFourthButton = makeReportReasonCheckButton(text: "도배/반복", tag: 4)
    private lazy var reportReasonFifthButton = makeReportReasonCheckButton(text: "개인정보 노출", tag: 5)
    private lazy var reportReasonSixthButton = makeReportReasonCheckButton(text: "기타", tag: 6)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
    
    // MARK: - Make
    
    private func makeReportReasonCheckButton(text: String, tag: Int) -> ReportReasonCheckButton {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: text)
        button.addTarget(self, action: #selector(tapButtonAction), for: .touchUpInside)
        button.tag = tag
        
        return button
    }
    
    private func makeStackView(axis: NSLayoutConstraint.Axis = .vertical,
                               distribution: UIStackView.Distribution = .fillEqually,
                               alignment: UIStackView.Alignment = .leading,
                               spacing: CGFloat = 20) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        
        return stackView
    }
}
extension ReportReasonView {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubViews([reportResonLabel, upperStackView])
        upperStackView.addStackSubViews([firstBusttonStackView, secondBusttonStackView])
        firstBusttonStackView.addStackSubViews([reportReasonFirstButton, reportReasonThirdButton, reportReasonFifthButton])
        secondBusttonStackView.addStackSubViews([reportReasonSecondButton, reportReasonFourthButton, reportReasonSixthButton])
    }
    private func setAutoLayout() {
        reportResonLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(reportResonLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(Spacing.size10)
            make.bottom.equalToSuperview()
        }
    }
}

extension ReportReasonView {
    @objc private func tapButtonAction(_ sender: UIButton) {
        [reportReasonFirstButton, reportReasonSecondButton, reportReasonThirdButton, reportReasonFourthButton, reportReasonFifthButton, reportReasonSixthButton].forEach { button in
            button.isSelected = false
        }
        sender.isSelected = true
        buttonTagClosure?(sender.tag)
    }
}


