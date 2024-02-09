//
//  SelectDataView.swift
//  GNUting
//
//  Created by 원동진 on 2/9/24.
//

import Foundation
import UIKit
import SnapKit
class SelectDateView : UIView{
    let textColor = UIColor(hexCode: "7D7D7D")
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 25
        return stackView
    }()
    private lazy var innerStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 25
        return stackView
    }()
    private lazy var yearLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Light.rawValue, size:  18)
        label.text = "YYYY"
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }()
    private lazy var monthLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Light.rawValue, size:  18)
        label.text = "MM"
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }()
    private lazy var dayLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Light.rawValue, size:  18)
        label.text = "DD"
        label.textColor = textColor
        label.textAlignment = .center
        return label
    }()
    private lazy var divide1Label : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Light.rawValue, size:  18)
        label.text = "/"
        label.textColor = textColor
        return label
    }()
    private lazy var divide2Label : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Light.rawValue, size:  18)
        label.text = "/"
        label.textColor = textColor
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SelectDateView {
    private func configure(){
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(hexCode: "F5F5F5")
        self.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        self.layer.masksToBounds = true
        addSubview(upperStackView)
        upperStackView.addStackSubViews([yearLabel,innerStackView,dayLabel])
        innerStackView.addStackSubViews([divide1Label,monthLabel,divide2Label])
        upperStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    public func setDateLabel(date : DateModel){
        yearLabel.text = date.year
        monthLabel.text = date.momth
        dayLabel.text = date.day
    }
}
