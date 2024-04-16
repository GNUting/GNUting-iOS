//
//  NotificationTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 4/8/24.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    static let identi = "NotificationTableViewCellid"
    private lazy var notificationBodyLabel : UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        return label
    }()
    private lazy var dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        return label
    }()
    private let borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
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
extension NotificationTableViewCell{
    private func setAddSubViews() {
        contentView.addSubViews([notificationBodyLabel,dateLabel,borderView])
    }
    private func setAutoLayout(){
        notificationBodyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
            
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview()
            make.left.equalTo(notificationBodyLabel.snp.right).offset(10)
            
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(notificationBodyLabel.snp.bottom).offset(12)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        dateLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
extension NotificationTableViewCell{
    func setCell(model : NotificationModelResult){
        notificationBodyLabel.text = model.body
        dateLabel.text = model.time
    }
}
