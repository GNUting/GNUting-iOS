//
//  NotificationTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identi = "NotificationTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var notificationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MeetingAlertImage")
        
        return imageView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private lazy var notificationTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Pretendard.medium(size: 14)
        
        return label
    }()
    
    private lazy var notificationBodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Pretendard.regular(size: 13)
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DisableColor")
        label.font = Pretendard.regular(size: 12)
        
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
}

// MARK: - Method

extension NotificationTableViewCell {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        contentView.addSubViews([notificationImageView, labelStackView])
        labelStackView.addStackSubViews([notificationTitleLabel, notificationBodyLabel, dateLabel])
    }
    
    private func setAutoLayout() {
        notificationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(25)
            make.width.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalTo(notificationImageView.snp.right).offset(15)
            make.bottom.equalToSuperview().offset(-12)
            make.right.equalToSuperview().offset(-25)
        }
    }
    
    // MARK: - SetCell
    
    func setCell(model: NotificationModelResult) {
        notificationTitleLabel.text = model.title
        notificationBodyLabel.text = model.body
        dateLabel.text = model.time
    }
}
