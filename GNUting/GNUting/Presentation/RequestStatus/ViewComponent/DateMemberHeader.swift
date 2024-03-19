//
//  DateMemberHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class DateMemberHeader: UITableViewHeaderFooterView {
    static let identi = "DateMemberHeaderid"
    private lazy var majorLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 18)
        label.text = "미술 교육과"
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

        majorLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(20)
        }
    }
    func setHeader(major: String?,count: Int?){
        majorLabel.text = "\(major ?? "학과") \(count ?? 0)명"
    }
}
