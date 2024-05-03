//
//  ChatRoomEnterTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 4/10/24.
//

import UIKit

class ChatRoomEnterTableViewCell: UITableViewCell {
    static let identi = "ChatRoomEnterTableViewCellid"
    private lazy var enterExplainLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        label.textColor = UIColor(named: "636060")
        label.backgroundColor = UIColor(hexCode: "F5F5F5")
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(enterExplainLabel)
        enterExplainLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension ChatRoomEnterTableViewCell {
    func setCell(message: String){
        enterExplainLabel.text = message
    }
    func setSizeToFitMessageLabel() {
        enterExplainLabel.adjustsFontSizeToFitWidth = true
    }
}
