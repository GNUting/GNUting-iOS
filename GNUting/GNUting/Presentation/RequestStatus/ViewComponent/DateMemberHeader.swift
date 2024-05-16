//
//  DateMemberHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class DateMemberHeader: UITableViewHeaderFooterView {
    static let identi = "DateMemberHeaderid"
    var requestStatus : Bool = true // false : Received
    private lazy var majorLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 18)
 
        label.textAlignment = .left
      
        return label
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension DateMemberHeader {
    private func setUpHeader() {
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
    func setHeader(major: String?){
        
        
        if requestStatus {
            majorLabel.text = "▶ \(major ?? "학과")"
            majorLabel.textColor = UIColor(named: "SecondaryColor")
        } else {
            majorLabel.text = "◀ \(major ?? "학과")"
            majorLabel.textColor = UIColor(named: "PrimaryColor")
        }
        
    }
}
