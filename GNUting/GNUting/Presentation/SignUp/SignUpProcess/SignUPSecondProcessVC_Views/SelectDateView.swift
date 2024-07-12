//
//  SelectDataView.swift
//  GNUting
//
//  Created by 원동진 on 2/9/24.
//

// MARK: - 날짜 선택 View, 회원가입 2

import UIKit

import SnapKit

final class SelectDateView: UIView{
    
    // MARK: - SubViews
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = Pretendard.semiBold(size: 14)
        
        return label
    }()
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true // 해당 프로퍼티는 margin을 사용하겠다는 플래그값 의미
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = UIColor(hexCode: "F5F5F5")
        stackView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.masksToBounds = true
        
        return stackView
    }()
    
    private lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private lazy var yearLabel = makeDateViewLabel(text: "YYYY")
    private lazy var monthLabel = makeDateViewLabel(text: "MM")
    private lazy var dayLabel = makeDateViewLabel(text: "DD")
    private lazy var divide1Label = makeDateViewLabel(text: "/")
    private lazy var divide2Label = makeDateViewLabel(text: "/")
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Helpers

extension SelectDateView {
    private func setAddSubViews() {
        addSubViews([upperStackView, typeLabel])
        upperStackView.addStackSubViews([yearLabel, innerStackView, dayLabel])
        innerStackView.addStackSubViews([divide1Label, monthLabel, divide2Label])
    }
    
    private func setAutoLayout() {
        typeLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-14)
        }
    }
    

}

// MARK: - Method private

extension SelectDateView {
    private func makeDateViewLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = Pretendard.light(size: 18)
        label.text = text
        label.textColor = UIColor(named: "Gray")
        label.textAlignment = .center
        
        return label
    }
}

// MARK: - Method public


extension SelectDateView {
    public func setDateLabel(date : DateModel) {
        yearLabel.text = date.year
        monthLabel.text = date.momth
        dayLabel.text = date.day
    }
}
