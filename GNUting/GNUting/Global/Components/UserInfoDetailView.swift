//
//  UserInfoDetailView.swift
//  GNUting
//
//  Created by 원동진 on 2/27/24.
//

import UIKit


class UserInfoDetailView: UIView { // 한줄소개 있음

    private lazy var upperView : UIView = {
        let stackView = UIView()
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        stackView.layer.masksToBounds = true
        return stackView
    }()
    
    private lazy var firstStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    lazy var userImageButton = UserImageButton()
 
    private lazy var userNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subInfoLabel : UILabel = { // 학번 나이
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var selfIntroduceLabel : UILabel = { // 한줄 소개
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 16)
        label.textColor = .black
        label.textAlignment = .left
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddsubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension UserInfoDetailView{
    private func setAddsubViews() {
        self.addSubview(upperView)
        upperView.addSubViews([firstStackView,subInfoLabel,selfIntroduceLabel])
        firstStackView.addStackSubViews([userImageButton,userNameLabel])
    }

    private func setAutoLayout() {
        upperView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        subInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        selfIntroduceLabel.snp.makeConstraints { make in
            make.top.equalTo(subInfoLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(-10)
        }
        userImageButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
        }
        userImageButton.setContentHuggingPriority(.init(251), for: .horizontal)
    }
    func selected(isSelected: Bool){
        if isSelected {
            upperView.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        } else {
            upperView.layer.borderColor = UIColor(hexCode: "EAEAEA").cgColor
        }
        
    }
    func hiddenBorder() {
        upperView.layer.borderWidth = 0
    }
    
    func setUserInfoDetailView(name :String?,major: String?,studentID: String?, age: String?, introduce: String?, image : String? ) {
        self.userNameLabel.text = name
        self.subInfoLabel.text = "\(major ?? "과") | \(studentID ?? "학번") | \(age ?? "나이")"
        self.selfIntroduceLabel.text = introduce
        self.setImageFromStringURL(stringURL: image)
    }
}
extension UserInfoDetailView {
    private func setImageFromStringURL(stringURL : String?) {
        if let url = URL(string: stringURL ?? "") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data else { return }
                DispatchQueue.main.async {
                    self.userImageButton.setImage(UIImage(data: imageData), for: .normal)
                    self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                    self.userImageButton.layer.masksToBounds = true
                }
            }.resume()
        }else {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
            userImageButton.configuration = config
            self.userImageButton.setImage(UIImage(named: "ProfileImg"), for: .normal)
        }
    }
}
