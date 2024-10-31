//
//  MemberTableViewHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

// MARK: - 과팅 참가 멤버 TableView Header

import UIKit

class MemberTableViewHeader: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static let identi = "MemberTableViewHeaderoid"
    
    // MARK: - SubViews
    
    private let memberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = Pretendard.medium(size: 18)
        
        return label
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Helpers
    
    private func configure() {
        contentView.addSubview(memberLabel)
        memberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    // MARK: - Set View
    
    func setMemberLabelCount(memberCount : Int){
        memberLabel.text = "멤버(\(memberCount))"
    }
}
