//
//  DetailDateBoardTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

//MARK: - 게시글 리스트(게시글 검색, 게시글 리스트, 내가 쓴 게시글 TableViewCell로 이용)  목록 내용 : 타이틀/학과/학번

import UIKit

// MARK: protocol

protocol BoardListCellconfiguration {
    var status: String { get }
    var title: String { get }
    var time: String { get }
    var department: String { get }
    var studentID: String { get }
    var inUserCount: Int { get }
}


final class BoardListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "DateBoardTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var statsuLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.semiBold(size: 12)
        
        return label
    }()
    
    private lazy var titleLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var subTitleLableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private lazy var subInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DisableColor")
        label.font = Pretendard.regular(size: 12)
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var userCountLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8))
        label.font = Pretendard.regular(size: 11)
        label.backgroundColor = UIColor(named: "BackGroundColor")
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.textColor = UIColor(hexCode: "696969")
        
        return label
    }()
    
    private let borderView = BorderView()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Method

extension BoardListTableViewCell {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        contentView.addSubViews([statsuLabel, titleLabelStackView, subInfoLabel, borderView])
        titleLabelStackView.addStackSubViews([userCountLabel, titleLabel])
    }
    
    private func setAutoLayout() {
        statsuLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        
        titleLabelStackView.snp.makeConstraints { make in
            make.top.equalTo(statsuLabel.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabelStackView.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(Spacing.left)
            
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalToSuperview()
        }
        
        userCountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(249), for: .horizontal)
    }
    
    // MARK: - Internal SetCell
    
    func setCell<T: BoardListCellconfiguration>(model: T) {
        if model.status == "OPEN" {
            statsuLabel.text = "신청 가능"
            statsuLabel.textColor = UIColor(named: "SecondaryColor")
            titleLabel.textColor = .black
        } else {
            statsuLabel.text = "신청 마감"
            statsuLabel.textColor = UIColor(named: "PrimaryColor")
            titleLabel.textColor = UIColor(named: "DisableColor")
        }
        
        titleLabel.text = model.title
        subInfoLabel.text = "\(model.time) | \(model.department) | \((model.studentID)) "
        userCountLabel.text = "\(model.inUserCount):\(model.inUserCount)"
    }
}
