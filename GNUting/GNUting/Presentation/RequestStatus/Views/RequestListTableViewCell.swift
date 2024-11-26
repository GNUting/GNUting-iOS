//
//  RequsetListTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

// MARK: - 신청 현황 신청 & 신청 받은 목록 UITableViewCell

import UIKit

final class RequestListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "RequsetListTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var upperView: UIView = {
        let view = UIView()
        view.setLayerCorner(cornerRaius: 10,borderColor: UIColor(named: "BorderColor"))
        
        return view
    }()
    
    private lazy var requestTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 13)
        
        return label
    }()
    
    private lazy var requestStateLabel: BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
                                     text: "대기중",
                                     textColor: .white,
                                     textAlignment: .center,
                                     font: Pretendard.semiBold(size: 14)!)
        label.setLayerCorner(cornerRaius: 10)
        
        return label
    }()
    
    // MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RequestListTableViewCell {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        contentView.addSubview(upperView)
        upperView.addSubViews([requestTitleLabel, requestStateLabel])
    }
    
    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.size7)
            make.left.right.equalToSuperview()
        }
        
        requestTitleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.size10)
            make.left.equalToSuperview().offset(Spacing.size25)
        }
        
        requestStateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.size10)
            make.left.equalTo(requestTitleLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(Spacing.right)
            make.width.equalTo(110)
        }
        
        requestStateLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        requestStateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    // MARK: - SetView
    
    func setCell(model: ApplicationInfo) {
        let memberCount = model.memberCount
        let countStr = "\(memberCount) : \(memberCount) 매칭"
        let requestTitle = memberCount == 1 ? countStr : "과팅 (\(countStr))"
        
        requestTitleLabel.text = requestTitle
        requestStateLabel.text = "\(model.applyStatus.statusString)"
        requestStateLabel.backgroundColor = model.applyStatus.backgroundColor
    }
}
