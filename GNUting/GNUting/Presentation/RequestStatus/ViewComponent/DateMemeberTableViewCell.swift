//
//  DateMemeberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 5/3/24.
//

import UIKit

class DateMemeberTableViewCell: UITableViewCell {
    var userImageTappedClosure: (()->())?
    // 유저 이미지, 이름, 학번,나이 ,한줄소개
    static let identi = "DateMemeberTableViewCellid"
    private lazy var upperView : UIView = {
        let view = UIView()
        
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
extension DateMemeberTableViewCell {
    private func configure(){
        contentView.addSubview(upperView)
   
        upperView.addSubview(userInfoView)
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
 
    func setDateMember(model: ApplicationStatusUser ){
        userInfoView.setUserInfoDetailView(name: model.nickname, major: model.department, studentID: model.studentId, introduce: model.userSelfIntroduction, image: model.profileImage)
    }
}

extension DateMemeberTableViewCell: UserImageButtonDelegate{
    func tappedAction() {
        userImageTappedClosure?()
    }
}

