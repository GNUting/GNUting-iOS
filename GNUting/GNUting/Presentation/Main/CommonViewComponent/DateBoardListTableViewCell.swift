//
//  DetailDateBoardTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardListTableViewCell: UITableViewCell { // 게시글 목록 타이틀/학과/학번
    static let identi = "DetailDateBoardTableViewCellid"
    private lazy var boardTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 16)
        label.textAlignment = .left
        return label
    }()
    private lazy var majorStudentIDLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 14)
        label.textAlignment = .left
        return label
    }()
    private let borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    public func setCell(model:DetailDateBoardModel){
        boardTitleLabel.text = model.title
        majorStudentIDLabel.text = "\(model.major)|\(model.studentID)"
    }
    private func configure(){
        contentView.addSubViews([boardTitleLabel,majorStudentIDLabel,borderView])
        boardTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.equalToSuperview()
        }
        majorStudentIDLabel.snp.makeConstraints { make in
            make.top.equalTo(boardTitleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(majorStudentIDLabel.snp.bottom).offset(Spacing.top)
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
