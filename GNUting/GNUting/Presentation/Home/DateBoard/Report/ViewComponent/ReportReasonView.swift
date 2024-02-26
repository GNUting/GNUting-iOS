//
//  ReportReasonVioew.swift
//  GNUting
//
//  Created by 원동진 on 2/25/24.
//

import UIKit

class ReportReasonView: UIView {
    private let reportResonLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 12)
        label.textAlignment = .left
        label.text = "신고 사유"
        return label
    }()
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 50
        return stackView
    }()
    private lazy var firstBusttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    private lazy var secondBusttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 20
        return stackView
    }()
    private lazy var reportReasonFirstButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "영리목적/홍보성")
        return button
    }()
    private lazy var reportReasonSecondButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "욕설/인신공격")
        return button
    }()
    private lazy var reportReasonThirdButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "음란성/선정성")
        return button
    }()
    private lazy var reportReasonFourthButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "도배/반복")
        return button
    }()
    private lazy var reportReasonFifthButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "개인정보 노출")
        return button
    }()
    private lazy var reportReasonSixthButton : ReportReasonCheckButton = {
        let button  = ReportReasonCheckButton()
        button.setConfiguration(buttonText: "기타")
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder) has not been implemented")
    }
}
extension ReportReasonView {
    private func configure() {
        self.addSubViews([reportResonLabel,upperStackView])
        upperStackView.addStackSubViews([firstBusttonStackView,secondBusttonStackView])
        firstBusttonStackView.addStackSubViews([reportReasonFirstButton,reportReasonThirdButton,reportReasonFifthButton])
        secondBusttonStackView.addStackSubViews([reportReasonSecondButton,reportReasonFourthButton,reportReasonSixthButton])
    }
    private func setAutoLayout() {
        reportResonLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(reportResonLabel.snp.bottom).offset(15)
            make.bottom.left.right.equalToSuperview()
        }
    }
}
