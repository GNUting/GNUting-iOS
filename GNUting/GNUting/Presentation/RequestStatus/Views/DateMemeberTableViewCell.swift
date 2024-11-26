//
//  DateMemeberTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 5/3/24.
//

// MARK: - 신청현황 Detail 유저 이미지, 이름, 학번,나이 ,한줄소개

import UIKit

final class DateMemeberTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var userImageTappedClosure: (()->())?
    static let identi = "DateMemeberTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var upperView = UIView()
    
    private lazy var userInfoView: UserInfoDetailView = {
        let view = UserInfoDetailView()
        view.userInfoDetailViewDelegate = self
        
        return view
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DateMemeberTableViewCell {
    
    // MARK: - Layout Helpers
    
    private func configure() {
        contentView.addSubview(upperView)
        upperView.addSubview(userInfoView)
        
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.right.equalToSuperview().inset(Spacing.size20)
            make.bottom.equalToSuperview()
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.size10)
            make.left.right.equalToSuperview()
        }
    }
 
    // MARK: - SetView
    func setDateMember(model: ApplicationStatusUser){
        userInfoView.setUserInfoDetailView(name: model.nickname,
                                           major: model.department,
                                           studentID: model.studentId,
                                           introduce: model.userSelfIntroduction,
                                           image: model.profileImage)
    }
}

// MARK: - Delegate

extension DateMemeberTableViewCell: UserInfoDetailViewDelegate {
    func tapUserImageButton() {
        userImageTappedClosure?()
    }
}

