//
//  RequsetListTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class RequsetListTableViewCell: UITableViewCell {
    static let identi = "RequsetListTableViewCellid"
    private lazy var upperView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var requestMajorAndMemeberCountLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.text = "산업시스템 공학부 3명"
        return label
    }()
    private lazy var requestStateLabel : BasePaddingLabel = {
       let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.textColor = .white
        label.text = "대기중"
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension RequsetListTableViewCell{
    private func setAddSubViews() {
        contentView.addSubview(upperView)
      
    }
    private func setAutoLayout() {
        upperView.addSubViews([requestMajorAndMemeberCountLabel,requestStateLabel])
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
        requestMajorAndMemeberCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.bottom.equalToSuperview().offset(-10)
        }
        requestStateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(requestMajorAndMemeberCountLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-10)
        }
        requestStateLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        requestStateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    func setRequestStateLabel(state : RequestState ){
        requestStateLabel.backgroundColor = state.backgroundColor
    }
    
}
