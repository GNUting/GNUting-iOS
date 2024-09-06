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
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var majorAndMemeberCountLabel : UILabel = {
       let label = UILabel()
        label.font = Pretendard.semiBold(size: 16)
        
        return label
    }()
    private lazy var requestStateLabel : BasePaddingLabel = {
       let label = BasePaddingLabel(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        label.font = Pretendard.semiBold(size: 16)
        label.textColor = .white
        label.text = "대기중"
        label.textAlignment = .center
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
        upperView.addSubViews([majorAndMemeberCountLabel, requestStateLabel])
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-7)
        }
        majorAndMemeberCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(Spacing.left)
            make.bottom.equalToSuperview().offset(-10)
        }
        requestStateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(majorAndMemeberCountLabel.snp.right).offset(12)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(110)
        }
        requestStateLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        requestStateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    func setCell(model : DateStateModel ){
        majorAndMemeberCountLabel.text = "\(model.major) \(model.memeberCount)명"
        requestStateLabel.text = "\(model.applyStatus.statusString)"
        requestStateLabel.backgroundColor = model.applyStatus.backgroundColor
    }
    
}
