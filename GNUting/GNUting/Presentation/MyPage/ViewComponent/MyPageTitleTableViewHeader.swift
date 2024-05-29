//
//  MyPageTitleHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class MyPageTitleTableViewHeader: UITableViewHeaderFooterView {
    static let identi = "MyPageTitleHeaderid"
    private lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.font = Pretendard.semiBold(size: 14)
        label.textColor = UIColor(hexCode: "767676")
        label.textAlignment = .left
        return label
    }()
    private lazy var borderView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubViews([titleLabel,borderView])
        setHeader()
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTitleLabel(text: String) {
        titleLabel.text = text
    }
}
