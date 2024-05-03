//
//  ChatRoomTableViewReceiveMessageCell.swift
//  GNUting
//
//  Created by 원동진 on 3/28/24.
//

import UIKit

class ChatRoomTableViewSendMessageCell: UITableViewCell {
    static let identi = "ChatRoomTableViewReceiveMessageCellid"
    private lazy var upperView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.spacing = 5
        return stackView
    }()
        
    

    private lazy var messageLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "6B6B6B")
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor(hexCode: "FFE2E0")
        return label
    }()
    private lazy var sendDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "DisableColor")
        
        label.textAlignment = .right
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension ChatRoomTableViewSendMessageCell{
    private func setAddSubViews() {
        contentView.addSubview(upperView)
        
        upperView.addStackSubViews([sendDateLabel,messageLabel])
        
    }
    private func setAutoLayout(){
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
       
        sendDateLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        sendDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
extension ChatRoomTableViewSendMessageCell {
    func setCell(nickName: String, UserImage: String, message:String,sendDate: String){
        messageLabel.text = "\(message)"
        
        let time = sendDate.split(separator: "T")[1].split(separator: ":")
        sendDateLabel.text = "\(time[0]):\(time[1])"

        
    }
    func setSizeToFitMessageLabel() {
        messageLabel.adjustsFontSizeToFitWidth = true
    }
}
