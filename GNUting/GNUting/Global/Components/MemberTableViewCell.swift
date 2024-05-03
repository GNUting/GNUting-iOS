//
//  MemberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/19/24.
//

import UIKit

class MemberTableViewCell: UITableViewCell {
    var userImageTappedClosure: (()->())?
    // 유저 이미지, 이름, 학번,나이 ,한줄소개
    static let identi = "MemberTableViewCellid"
    private lazy var upperView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "BorderColor")?.cgColor
        return view
    }()
    private lazy var userInfoView : UserInfoDetailView = {
        let view = UserInfoDetailView()
        view.userImageButton.userImageButtonDelegate = self
        
        return view
    }()
    
    
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
        contentView.addSubview(upperView)
   
        upperView.addSubview(userInfoView)
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(Spacing.left)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    func setUserInfoViews(model: UserInfosModel ){
        userInfoView.setUserInfoDetailView(name: model.name, major: model.department, studentID: model.studentId, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
    func setUserInfoViewsPost(model: UserInfosModel ){
        userInfoView.setUserInfoDetailView(name: model.name, major: model.department, studentID: model.studentId, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
    func setDateMember(model: ApplicationStatusUser ){
        userInfoView.setUserInfoDetailView(name: model.name, major: model.department, studentID: model.studentId, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
}

extension MemberTableViewCell: UserImageButtonDelegate{
    func tappedAction() {
        userImageTappedClosure?()
    }
}
