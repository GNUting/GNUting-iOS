//
//  TermsTVC.swift
//  GNUting
//
//  Created by 원동진 on 2/7/24.
//

// MARK: 이용약관 TableView Cell

import UIKit

// MARK: - Protocol

protocol TermsTableViewCellDelegate: AnyObject {
    func pushButtonAction(indexPath: IndexPath)
    func checkButtonAction(isSelected: Bool, indexPath: IndexPath)
}
final class TermsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "TermsTableViewCellid"
    weak var termsTableViewCellDelegate: TermsTableViewCellDelegate?
    private var selectedState: Bool = false
    private var indexPath: IndexPath?
    
    // MARK: - SubViews
    
    private lazy var upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        button.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var termsTextLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 15)
        
        return label
    }()
    
    private lazy var pushButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pushImg"), for: .normal)
        button.addAction(UIAction { _ in
            self.termsTableViewCellDelegate?.pushButtonAction(indexPath: self.indexPath ?? IndexPath(row: 0, section: 0))
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pushButton.isHidden = false // 151 번 코드로 인해 셀 재사용시 pushButton 사라지는 형상을 막고자함
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - Layout Helpers

extension TermsTableViewCell {
    private func setAddSubViews() {
        contentView.addSubview(upperStackView)
        upperStackView.addStackSubViews([checkButton, termsTextLabel, pushButton])
    }
    
    private func setAutoLayout() {
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-13)
        }
        
        checkButton.setContentHuggingPriority(.init(751), for: .horizontal)
        checkButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        termsTextLabel.setContentHuggingPriority(.init(750), for: .horizontal)
        pushButton.setContentHuggingPriority(.init(751), for: .horizontal)
        pushButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}


// MARK: - ButtonAction

extension TermsTableViewCell {
    @objc func tapCheckButton(_ sender: UIButton){
        sender.isSelected.toggle()
        selectedState = sender.isSelected
        termsTableViewCellDelegate?.checkButtonAction(isSelected: sender.isSelected, indexPath: self.indexPath ?? IndexPath(row: 0, section: 0))
        
        if sender.isSelected {
            checkButton.setImage(UIImage(named: "SelectedCheckImage"), for: .selected)
        } else {
            checkButton.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
        }
    }
}

// MARK: - Method

extension TermsTableViewCell {
    
    // MARK: - Internal
    
    func setAllCheckButton(AllCheckButtonSelected : Bool){
        checkButton.isSelected = AllCheckButtonSelected
        AllCheckButtonSelected ? checkButton.setImage(UIImage(named: "SelectedCheckImage"), for: .selected) : checkButton.setImage(UIImage(named: "noSelectedCheckImage"), for: .normal)
    }
    
    func setTextLabel(type: String,description : String){
        let labelString = "\(type) \(description)"
        let attribtuedString = NSMutableAttributedString(string: labelString)
        let range = (labelString as NSString).range(of: type)
        
        attribtuedString.addAttribute(.font, value: Pretendard.bold(size: 15) ?? .boldSystemFont(ofSize: 15), range: range)
        attribtuedString.addAttribute(.foregroundColor, value: UIColor(named: "PrimaryColor") ?? .red, range: range)
        focusUniversityWord(attribtuedString: attribtuedString, labelString: labelString)
        termsTextLabel.attributedText = attribtuedString
    }
    
    func setIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
        if indexPath.row == 0 {
            pushButton.isHidden = true
        }
    }
    
    // MARK: - Private
    
    private func focusUniversityWord(attribtuedString: NSMutableAttributedString, labelString: String) {
        let range = (labelString as NSString).range(of: "경상국립대학교")
        attribtuedString.addAttribute(.font, value: Pretendard.bold(size: 15) ?? .boldSystemFont(ofSize: 15), range: range)
    }
}

