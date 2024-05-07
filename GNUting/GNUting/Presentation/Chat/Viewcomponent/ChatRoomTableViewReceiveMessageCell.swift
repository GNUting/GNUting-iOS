//
//  ChatRoomTableViewSendMessageCell.swift
//  GNUting
//
//  Created by 원동진 on 3/28/24.
//

import UIKit

class ChatRoomTableViewReceiveMessageCell: UITableViewCell {
    static let identi = "ChatRoomTableViewReceiveMessageCellid"
    private lazy var upperView = UIView()
    
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        label.textColor = .black
        
        return label
    }()
    private lazy var messageLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "6B6B6B")
        
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        label.layer.masksToBounds = true
        return label
    }()
    private lazy var sendDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "DisableColor")
        label.numberOfLines = 0
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
extension ChatRoomTableViewReceiveMessageCell{
    private func setAddSubViews() {
        contentView.addSubViews([userImageView,upperView])
        
        upperView.addSubViews([middleStackView,sendDateLabel])
        middleStackView.addStackSubViews([nickNameLabel,messageLabel])
    }
    private func setAutoLayout(){
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.height.width.equalTo(45)
        }
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(userImageView.snp.right).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        middleStackView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        sendDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(middleStackView.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview()
        }
        middleStackView.setContentHuggingPriority(.init(249), for: .horizontal)
        sendDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
extension ChatRoomTableViewReceiveMessageCell {
    func setCell(nickName: String, UserImage: String, message:String,sendDate: String){
        nickNameLabel.text = nickName
        messageLabel.text = message
        
        
        let time = sendDate.split(separator: "T")[1].split(separator: ":")
        sendDateLabel.text = "\(time[0]):\(time[1])"
        setImageFromStringURL(stringURL: UserImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = self.userImageView.layer.frame.size.width / 2
                self.userImageView.layer.masksToBounds = true
            }
            
        }
        
    }
    func setSizeToFitMessageLabel() {
        messageLabel.adjustsFontSizeToFitWidth = true
    }
}
