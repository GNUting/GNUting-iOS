//
//  DetailDateBoardTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardListTableViewCell: UITableViewCell { // 게시글 목록 타이틀/학과/학번
    static let identi = "DetailDateBoardTableViewCellid"
    private lazy var statsuLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 12)
        return label
    }()
    private lazy var boardTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        label.textAlignment = .left
        return label
    }()
    private lazy var subTitleLableStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private lazy var subInfoLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DisableColor")
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var userCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
        label.textColor = UIColor(named: "DisableColor")
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
    func boardListSetCell(model:BoardResult){
        if model.status == "OPEN"{
            statsuLabel.text = "신청 가능"
            statsuLabel.textColor = UIColor(named: "SecondaryColor")
            boardTitleLabel.textColor = .black
        } else {
            statsuLabel.text = "신청 마감"
            statsuLabel.textColor = UIColor(named: "PrimaryColor")
            boardTitleLabel.textColor = UIColor(named: "DisableColor")
        }
        
        boardTitleLabel.text = model.title
        subInfoLabel.text = "\(model.time) | \(model.user.department) | \((model.user.studentId)) "
       
        userCountLabel.text = "인원 : \(model.inUserCount)명"
        
    }
    func searchSetCell(model: SearchResultContent) {
        if model.status == "OPEN"{
            statsuLabel.text = "신청 가능"
            statsuLabel.textColor = UIColor(named: "SecondaryColor")
            boardTitleLabel.textColor = .black
        } else {
            statsuLabel.text = "신청 마감"
            statsuLabel.textColor = UIColor(named: "PrimaryColor")
            boardTitleLabel.textColor = UIColor(named: "DisableColor")
        }
        boardTitleLabel.text = model.title
        subInfoLabel.text = "\(model.time)|\(model.department) | \((model.studentID)) "
        userCountLabel.text = "인원 : \(model.inUserCount)명"
    }
    func myPostSetCell(model:MyPostResult){
        if model.status == "OPEN"{
            statsuLabel.text = "신청 가능"
            statsuLabel.textColor = UIColor(named: "SecondaryColor")
            boardTitleLabel.textColor = .black
        } else {
            statsuLabel.text = "신청 마감"
            statsuLabel.textColor = UIColor(named: "PrimaryColor")
            boardTitleLabel.textColor = UIColor(named: "DisableColor")
        } 
        boardTitleLabel.text = model.title
        subInfoLabel.text = "\(model.time) | \(model.user.department) | \((model.user.studentId)) "
        userCountLabel.text = "인원 : \(model.inUserCount)명"
    }
    private func configure(){
        contentView.addSubViews([statsuLabel,boardTitleLabel,subTitleLableStackView,borderView])
        subTitleLableStackView.addStackSubViews([subInfoLabel,userCountLabel])
        statsuLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        boardTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(statsuLabel.snp.bottom).offset(3)
            make.left.right.equalToSuperview().inset(Spacing.left)
        }
        subTitleLableStackView.snp.makeConstraints { make in
            make.top.equalTo(boardTitleLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(Spacing.left)
            
        }
        subInfoLabel.setContentHuggingPriority(.init(249), for: .horizontal)
       
        borderView.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
