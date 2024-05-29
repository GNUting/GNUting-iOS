//
//  UsetInfoView.swift
//  GNUting
//
//  Created by 원동진 on 2/20/24.
//

import UIKit
import SnapKit
// 한줄 소개 없는 버젼


class UserInfoView: UIView {
    private lazy var border1 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    private lazy var border2 : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    private lazy var upperStackView = UIView()
        
    
    lazy var userImageButton = UserImageButton()
    
    private lazy var middleStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
   
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
 
    private lazy var nickNameLabel : UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 14)
        label.textAlignment = .left
        
        return label
    }()
    private lazy var majorStudentIDLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = Pretendard.regular(size: 12)
        label.textColor = UIColor(named: "DisableColor")
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UserInfoView {
    private func addSubViews(){
        self.addSubViews([border1,upperStackView,border2])
        upperStackView.addSubViews([userImageButton,middleStackView])
        middleStackView.addStackSubViews([nickNameLabel,majorStudentIDLabel])
        middleStackView.setContentHuggingPriority(.init(250), for: .horizontal)
        userImageButton.setContentHuggingPriority(.init(251), for: .horizontal)
        
    }
    private func setAutoLayout(){
        userImageButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.height.width.equalTo(50)
        }
        middleStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview()
            make.left.equalTo(userImageButton.snp.right).offset(10)
        }
        border1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(1)
        }
        upperStackView.snp.makeConstraints { make in
            make.top.equalTo(border1.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        border2.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    func setUserInfoView(userImage: String?,userNickname: String, major: String, StudentID: String) {
        nickNameLabel.text = userNickname
        majorStudentIDLabel.text = major + " | " + StudentID

        
        setImageFromStringURL(stringURL: userImage) { image in
   
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.height / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
    }
    
}

