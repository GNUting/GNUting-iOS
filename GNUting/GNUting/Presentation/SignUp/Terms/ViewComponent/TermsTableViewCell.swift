//
//  TermsTVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit

class TermsTableViewCell: UITableViewCell {
    static let identi = "TermsTableViewCellid"
    var tapCheckButtonClosure : ((Bool)->())?
    var selectedState : Bool = false
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
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = UIColor(hexCode: "DFDFDF")
        button.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var termsTextLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 18)
        return label
    }()
    private lazy var pushButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pushImg"), for: .normal)
        return button
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(upperStackView)
        upperStackView.addStackSubViews([checkButton,termsTextLabel,pushButton])
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13)
        }
        checkButton.setContentHuggingPriority(.init(751), for: .horizontal)
        termsTextLabel.setContentHuggingPriority(.init(750), for: .horizontal)
        pushButton.setContentHuggingPriority(.init(751), for: .horizontal)
        checkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        pushButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
 
}

// MARK: - ButtonAction

extension TermsTableViewCell {
    @objc func tapCheckButton(_ sender: UIButton){
        sender.isSelected.toggle()
        selectedState = sender.isSelected
        tapCheckButtonClosure?(sender.isSelected)
        if sender.isSelected {
            checkButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        }else{
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
}

// MARK: - Method

extension TermsTableViewCell {
    func setAllCheckButton(AllCheckButtonSelected : Bool){
        if AllCheckButtonSelected{
            checkButton.isSelected = true
            checkButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        }else{
            checkButton.isSelected = false
            checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    func setTextLabel(_ text : String){
        termsTextLabel.text = text
    }
    
    
}
