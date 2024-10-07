//
//  MemberTableViewHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class MemberTableViewHeader: UITableViewHeaderFooterView {
    static let identi = "MemberTableViewHeaderoid"
    private let memberLabel : UILabel = {
        let label = UILabel()

        label.font = Pretendard.medium(size: 18)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(memberLabel)
        memberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setMemberLabelCount(memberCount : Int){
        memberLabel.text = "멤버(\(memberCount))"
    }
}
