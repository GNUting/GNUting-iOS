//
//  MemBerAddTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit


class MemBerAddTableViewCell: UITableViewCell {
    static let identi = "MemBerAddTableViewCell"
    private lazy var upperView : UIView = {
       let view = UIView()
        return view
    }()
    private lazy var plusImageView : UIImageView = {
        let imagView = UIImageView()
        imagView.image = UIImage(named: "PlusImg")
        return imagView
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
    private func configure(){
        upperView.layer.cornerRadius = 10
        upperView.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        upperView.layer.borderWidth = 1
        upperView.layer.masksToBounds = true
        contentView.addSubview(upperView)
        upperView.addSubview(plusImageView)
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-5)
        }
        plusImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
