//
//  ChatRoomTableViewSendMessageCell.swift
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
        stackView.spacing = 5
        stackView.alignment = .bottom
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SampleImg1")
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
        label.text = "닉네임1"
        return label
    }()
    private lazy var messageLabel : BasePaddingLabel = {
        let label = BasePaddingLabel(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "6B6B6B")
        label.text = "안녕하세요sdfsdfsdfsdfsdfsdfs\ndfsdfsdfsdfsdwerwerwerwer"
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
        label.textColor = UIColor(named: "979C9E")
        label.text = "16:43"
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("1")
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
        
        upperView.addStackSubViews([userImageView,middleStackView,sendDateLabel])
        middleStackView.addStackSubViews([nickNameLabel,messageLabel])
    }
    private func setAutoLayout(){
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().offset(-10)
        }
        userImageView.snp.makeConstraints { make in
            make.height.width.equalTo(45)
        }
        sendDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
}
