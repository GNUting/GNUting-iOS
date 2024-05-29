//
//  TermsTVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

import UIKit
protocol PushButtonDelegate: AnyObject {
    func buttonAction(indexPath: IndexPath)
}
class TermsTableViewCell: UITableViewCell {
    static let identi = "TermsTableViewCellid"
    var tapCheckButtonClosure : ((Bool)->())?
    var pushButtonDelegate : PushButtonDelegate?
    var selectedState : Bool = false
    var indexPath : IndexPath?
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
    private lazy var termsTextLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 15)
        return label
    }()
    private lazy var pushButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pushImg"), for: .normal)
        button.addTarget(self, action: #selector(tapPushButton), for: .touchUpInside)
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
    override func prepareForReuse() {
        super.prepareForReuse()
        pushButton.isHidden = false
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
            checkButton.setImage(UIImage(named: "SelectedCheckImage"), for: .selected)
        }else{
            checkButton.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        }
    }
}

// MARK: - Method

extension TermsTableViewCell {
    func setAllCheckButton(AllCheckButtonSelected : Bool){
        if AllCheckButtonSelected{
            checkButton.isSelected = true
            checkButton.setImage(UIImage(named: "SelectedCheckImage"), for: .selected)
        }else{
            checkButton.isSelected = false
            checkButton.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        }
    }
    
    func setTextLabel(_ text : String,indexPath: IndexPath){
        termsTextLabel.text = text
        let attribtuedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "(필수)")
        if text == "(필수) 경상국립대학교 재학중입니다." {
            let range = (text as NSString).range(of: "경상국립대학교")
            attribtuedString.addAttribute(.font, value: Pretendard.bold(size: 15) ?? .boldSystemFont(ofSize: 15), range: range)
            
        }
        self.indexPath = indexPath
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryColor") ?? .red, range: range)
        termsTextLabel.attributedText = attribtuedString
    }
    func hiddenPushButton() {
        pushButton.isHidden = true
    }
  
}
extension TermsTableViewCell {
    @objc private func tapPushButton(){
        pushButtonDelegate?.buttonAction(indexPath: self.indexPath ?? IndexPath(row: 1, section: 0))
    }
}
