//
//  MemberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    static let identi = "MemberTableViewCellid"
    private lazy var upperView : UIView = {
       let view = UIView()
        return view
    }()
    private lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.textColor = UIColor(hexCode: "636060")
        label.numberOfLines = 0
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    public func setContentLabel(model : String){
        contentLabel.text = model
    }
    private func configure(){
        upperView.layer.cornerRadius = 10
        upperView.backgroundColor = UIColor(hexCode: "F5F5F5")
        upperView.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        upperView.layer.borderWidth = 1
        upperView.layer.masksToBounds = true
        contentView.addSubview(upperView)
        upperView.addSubview(contentLabel)
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-5)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
}
