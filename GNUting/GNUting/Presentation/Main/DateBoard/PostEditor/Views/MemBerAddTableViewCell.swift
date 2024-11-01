//
//  MemBerAddTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 3/15/24.
//

// MARK: - 과팅 참가 멤버 TableView Cell

import UIKit

final class MemBerAddTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "MemBerAddTableViewCell"
    
    // MARK: - SubViews
    
    private lazy var upperView = UIView()

    private lazy var plusImageView: UIImageView = {
        let imagView = UIImageView()
        imagView.image = UIImage(named: "PlusImg")
        
        return imagView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        upperView.setLayerCorner(cornerRaius: 10,borderWidth: 1, borderColor: UIColor(named: "BorderColor"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Helpers
    
    private func configure(){
        contentView.addSubview(upperView)
        upperView.addSubview(plusImageView)
        
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        
        plusImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
}
