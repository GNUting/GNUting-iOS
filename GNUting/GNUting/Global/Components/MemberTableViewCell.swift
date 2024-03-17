//
//  MemberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class MemberTableViewCell: UITableViewCell { // 유저 이미지, 이름, 학번,나이 ,한줄소개
    static let identi = "MemberTableViewCellid"
    private lazy var userInfoView = UserInfoDetailView()
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
  
}
extension MemberTableViewCell {
    private func configure(){
        contentView.addSubview(userInfoView)
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Spacing.top)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalToSuperview()
        }
    }
    func setUserInfoViews(model: UserInfosModel ){
        userInfoView.setUserInfoDetailView(name: model.name, studentID: model.studentId, age: model.age, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
    func setUserInfoViewsPost(model: UserInfosModel ){
        userInfoView.setUserInfoDetailView(name: model.name, studentID: model.studentId, age: model.age, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
}
