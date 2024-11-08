//
//  DateMemberHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

// MARK: - 과팅 멤버 참여 인원 명수를 나타내는 UITableView Header

import UIKit

final class DateMemberHeader: UITableViewHeaderFooterView {
    
    // MARK: - Properties
    
    static let identi = "DateMemberHeaderid"
    var requestStatus: Bool = true // false : Received
    
    // MARK: - SubViews
    
    private lazy var majorLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.semiBold(size: 18)
        label.textAlignment = .left
        
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
}

extension DateMemberHeader {
    
    // MARK: - Layout Helpers
    
    private func configure() {
        contentView.addSubview(majorLabel)
        contentView.roundCorners(cornerRadius: 10, maskedCorners: [.layerMinXMinYCorner,.layerMaxXMinYCorner])
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        
        majorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-11)
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Set View
    
    func setHeader(major: String?) {
        let arrow = requestStatus ? "▶" : "◀"
        majorLabel.text =  "\(arrow) \(major ?? "학과")"
        majorLabel.textColor = requestStatus ? UIColor(named: "SecondaryColor") : UIColor(named: "PrimaryColor")
    }
}
