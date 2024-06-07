//
//  ChatRoomTableViewReceiveMessageCell.swift
//  GNUting
//
//  Created by 원동진 on 3/28/24.
//

import UIKit

class ChatRoomTableViewSendMessageCell: UITableViewCell {
    static let identi = "ChatRoomTableViewSendMessageCellid"
    private lazy var upperView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .bottom
        stackView.spacing = 5
        return stackView
    }()
    private lazy var messageView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "FFE2E0")
        view.layer.cornerRadius = 10
        
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
        label.textColor = UIColor(named: "6B6B6B")
        label.numberOfLines = 0
 
        label.backgroundColor = UIColor(hexCode: "FFE2E0")
        return label
    }()
    private lazy var sendDateLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
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
        
        upperView.addStackSubViews([sendDateLabel,messageView])
        messageView.addSubview(messageLabel)
    }
    private func setAutoLayout(){
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
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
