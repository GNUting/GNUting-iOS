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
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
                                     textColor: UIColor(hexCode: "636060"),
                                     textAlignment: .center, font: Pretendard.regular(size: 12)!)
        label.backgroundColor = UIColor(hexCode: "F5F5F5")
        label.setLayerCorner(cornerRaius: 10)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.sizeToFit()
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(enterExplainLabel)
        enterExplainLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.left.right.equalToSuperview()
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
    func setCell(message: String,enterType: String){
        
        
        enterExplainLabel.text = message
    }
    func setSizeToFitMessageLabel() {
        enterExplainLabel.adjustsFontSizeToFitWidth = true
    }
}
