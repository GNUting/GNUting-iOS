//
//  ChatRoomMemberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 5/5/24.
//

import UIKit

class ChatRoomMemberTableViewCell: UITableViewCell {
    static let identi = "ChatRoomMemberTableViewCellid"
    var closure: ((ChatRommUserModelResult?)-> ())?
    var chatRommUserModelResult: ChatRommUserModelResult?
    private lazy var upperStackView : UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    private lazy var userImageButton : UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(tapUserImageButton), for: .touchUpInside)
        return button
    }()
        
    private lazy var markMeImaegView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MarkMeImage")
        imageView.isHidden = true
        return imageView
    }()
    private lazy var nameLabel : UILabel = {
       let label = UILabel()

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
extension ChatRoomMemberTableViewCell{
    private func setAddSubViews() {
        contentView.addSubview(upperStackView)
        upperStackView.addStackSubViews([userImageButton, markMeImaegView, nameLabel])
    }
    private func setAutoLayout(){
        upperStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().offset(-16)
        }
        userImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(45)
        }
        markMeImaegView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
        }
    }
    
}
extension ChatRoomMemberTableViewCell{
    func setCell(model: ChatRommUserModelResult) {
        nameLabel.text = model.nickname
        self.chatRommUserModelResult = model
        setImageFromStringURL(stringURL: model.profileImage) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.height / 2
                self.userImageButton.clipsToBounds = true
            }
            
        }
    }
    func showMarkMeImaegView(){
        markMeImaegView.isHidden = false
    }
    @objc private func tapUserImageButton(){
        closure?(self.chatRommUserModelResult)
    }
}

