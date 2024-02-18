//
//  DateBoardTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardTableViewCell: UITableViewCell {
    static let identi = "DateBoardTableViewCellid"
    private lazy var upperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private lazy var majorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    private lazy var boardTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 15)
        label.textColor = .black
        label.textAlignment = .right
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
    public func setCell(model : DateBoardModel){
        majorLabel.text = model.major
        boardTitleLabel.text = model.title
    }
    private func configure(){
        contentView.addSubview(upperStackView)
        upperStackView.addStackSubViews([majorLabel,boardTitleLabel])
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.left.right.equalToSuperview()
        }
        majorLabel.setContentHuggingPriority(.init(250), for: .horizontal)
        boardTitleLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        majorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
