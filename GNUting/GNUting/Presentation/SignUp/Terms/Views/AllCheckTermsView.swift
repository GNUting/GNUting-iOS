//
//  AllCheckTermsView.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit

class AllCheckTermsView: UIView {
    var tapAllCheckButtonClosure : ((Bool)->())?
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    private lazy var checkButton  : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        button.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        return button
    }()
    let termsTextLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.semiBold(size: 20)
        label.text = "약관 전체 동의"
        return label
    }()
    private lazy var borderView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E8E8E8")
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubViews([upperStackView,borderView])
        upperStackView.addStackSubViews([checkButton,termsTextLabel])
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(1)
        }
        checkButton.setContentHuggingPriority(.init(751), for: .horizontal)
        termsTextLabel.setContentHuggingPriority(.init(750), for: .horizontal)
        checkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func tapCheckButton(_ sender: UIButton){
        sender.isSelected.toggle()
        tapAllCheckButtonClosure?(sender.isSelected)
        if sender.isSelected {
            checkButton.setImage(UIImage(named: "SelectedCheckImage"), for: .selected)
        }else{
            checkButton.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        }
    }
}
extension AllCheckTermsView {
    func checkButtonSelected(isSelected : Bool) {
        checkButton.isSelected = isSelected
    }
}
