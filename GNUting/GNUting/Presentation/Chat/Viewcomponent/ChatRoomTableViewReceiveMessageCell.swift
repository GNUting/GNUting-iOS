//
//  ChatRoomTableViewSendMessageCell.swift
//  GNUting
//
//  Created by 원동진 on 3/28/24.
//

import UIKit

class ChatRoomTableViewReceiveMessageCell: UITableViewCell {
    static let identi = "ChatRoomTableViewReceiveMessageCellid"
    var closure: ((ChatRoomMessageModelResult)-> ())?
    var chatRommUserModelResult: ChatRoomMessageModelResult?
    private lazy var upperView = UIView()
    private lazy var userImageButton : UIButton = {
        let button = UIButton()
         button.addTarget(self, action: #selector(tapUserImageButton), for: .touchUpInside)
         return button
    }()
    private lazy var middleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var messageUpperView = UIView()
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        label.textColor = .black
        
        return label
    }()
    private lazy var messageView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var messageLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
        label.textColor = UIColor(named: "6B6B6B")
        label.sizeToFit()
        label.numberOfLines = 0
  
        return label
    }()
    private lazy var sendDateLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.regular(size: 12)
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
        contentView.addSubViews([userImageButton, upperView])
        
        upperView.addSubViews([middleStackView])
        middleStackView.addStackSubViews([nickNameLabel, messageUpperView])
        messageUpperView.addSubViews([messageView, sendDateLabel])
        messageView.addSubview(messageLabel)
    }
    private func setAutoLayout(){
        userImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.height.width.equalTo(45)
        }
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(userImageButton.snp.right).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        middleStackView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        messageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }
        sendDateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(messageView.snp.right).offset(5)
            make.right.lessThanOrEqualToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        messageUpperView.setContentHuggingPriority(.init(249), for: .horizontal)
        sendDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
extension ChatRoomTableViewReceiveMessageCell {
    func setCell(model: ChatRoomMessageModelResult?){
        nickNameLabel.text = model?.nickname == nil ? "(알 수 없음)" : model?.nickname
        messageLabel.text = model?.message
        guard let chatRoomData = model else { return }
        
        self.chatRommUserModelResult = ChatRoomMessageModelResult(id: chatRoomData.id, chatRoomId: chatRoomData.chatRoomId , messageType: chatRoomData.messageType , email: chatRoomData.email, nickname: chatRoomData.nickname, profileImage: chatRoomData.profileImage, message: chatRoomData.message , createdDate: chatRoomData.createdDate , studentId: chatRoomData.studentId , department: chatRoomData.department)
        let sendDate = model?.createdDate
        let time = sendDate!.split(separator: "T")[1].split(separator: ":")
        sendDateLabel.text = "\(time[0]):\(time[1])"
        let cacheKey = NSString(string: model?.profileImage ?? "")
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            DispatchQueue.main.async {
                self.userImageButton.setImage(cachedImage, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        } else {
            setImageFromStringURL(stringURL: model?.profileImage) { image in
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    self.userImageButton.setImage(image, for: .normal)
                    self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                    self.userImageButton.layer.masksToBounds = true
                }
            }
        }
  
    }
    func setSizeToFitMessageLabel() {
        messageLabel.adjustsFontSizeToFitWidth = true
    }
    @objc private func tapUserImageButton(){
        closure?(self.chatRommUserModelResult!)
    }
}
