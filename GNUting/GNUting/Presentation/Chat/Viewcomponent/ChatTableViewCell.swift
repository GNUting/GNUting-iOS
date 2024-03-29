//
//  ChatTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let identi = "ChatTableViewCellid"
    private lazy var upperView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        view.layer.masksToBounds = true
        return view
    }()
    private lazy var userImageView : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "SampleImg1")
        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
        return imageView
    }()
    private lazy var firstStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 12
        
        return stackView
    }()
    private lazy var secondStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 5
        
        return stackView
    }()
    private lazy var chatTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 16)
        label.text = "4:4 과팅 하실분 알려주세요"
        return label
    }()
    
    private lazy var majorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.text = "컴퓨터 과학과"
        label.textColor = UIColor(hexCode: "767676")
        return label
    }()
    private lazy var newChatLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.text = "저희 주당에서 7시에 볼까요?"
        label.textColor = UIColor(hexCode: "767676")
        
        return label
    }()
    
    private lazy var newChatImage : UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "NewChatImage")
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        newChatLabel.sizeToFit()
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
extension ChatTableViewCell{
    private func setAddSubViews() {
        contentView.addSubview(upperView)
        upperView.addSubViews([firstStackView,userImageView,secondStackView])
        firstStackView.addStackSubViews([chatTitleLabel,majorLabel])
        secondStackView.addStackSubViews([newChatLabel,newChatImage])
    }
    private func setAutoLayout(){
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.bottom.equalToSuperview().offset(-12)
        }
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
        }
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.left.equalTo(firstStackView.snp.right).offset(5)
        }
        
        firstStackView.setContentHuggingPriority(.init(250), for: .horizontal)
        userImageView.setContentHuggingPriority(.init(251), for: .horizontal)
        userImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(12)
            make.right.lessThanOrEqualToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-12)
        }

        newChatImage.setContentHuggingPriority(.init(251), for: .horizontal)
        newChatImage.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        
    }
    
}
extension ChatTableViewCell {
    func setChatTableViewCell(title: String, leaderUserDepartment: String, applyLeaderDepartment: String,newChatMessage: String) {
        chatTitleLabel.text = title
        majorLabel.text = "\(leaderUserDepartment) | \(applyLeaderDepartment)"
        newChatLabel.text = newChatMessage
    }
}
