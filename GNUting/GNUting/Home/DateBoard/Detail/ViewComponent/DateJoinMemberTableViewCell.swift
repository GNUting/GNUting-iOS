//
//  DateJoinMemberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//

import UIKit

import SnapKit

class DateJoinMemberTableViewCell: UITableViewCell {
    static let identi = "DateJoinMemberTableViewCellid"
    
    private lazy var memberInfoView = UserInfoDetailView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setAddSubView()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DateJoinMemberTableViewCell{
    private func setAddSubView() {
        contentView.addSubview(memberInfoView)
    }
    
    private func setAutoLayout() {
        memberInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
