//
//  MyPageTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {
    static let identi = "MyPageTableViewCellid"
    private lazy var upperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private lazy var elementLabel : UILabel = {
       let label = UILabel()
        label.font = Pretendard.semiBold(size: 15)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var pushImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "pushImg")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(upperStackView)
        upperStackView.addStackSubViews([elementLabel,pushImageView])
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-15)
        }
        
        elementLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        pushImageView.setContentHuggingPriority(.init(250), for: .horizontal)
        pushImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setCell(text: String) {
        elementLabel.text = text
    }
}
