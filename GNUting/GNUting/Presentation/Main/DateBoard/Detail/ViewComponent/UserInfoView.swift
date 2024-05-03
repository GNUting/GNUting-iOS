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
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var userImageButton = UserImageButton()
    
    private lazy var middleStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
 
    private lazy var nickNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 14)
        label.textAlignment = .left
        
        return label
    }()
    private lazy var majorStudentIDLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Pretendard.Regular.rawValue, size: 12)
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
        upperStackView.addStackSubViews([userImageButton,middleStackView])
        middleStackView.addStackSubViews([nickNameLabel,majorStudentIDLabel])
        middleStackView.setContentHuggingPriority(.init(250), for: .horizontal)
        userImageButton.setContentHuggingPriority(.init(251), for: .horizontal)
        
    }
    private func setAutoLayout(){
        userImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
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
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }
    }
    
}

