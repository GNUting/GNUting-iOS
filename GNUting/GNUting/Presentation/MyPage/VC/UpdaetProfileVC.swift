//
//  UpdaetProfileVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit
import PhotosUI
// MARK: - 프로필 수정화면

class UpdateProfileVC: UIViewController {
    var userInfo: GetUserDataModel?
    var nicknameCheck: Bool = false
    private lazy var phpickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images,.livePhotos])
        configuration.selectionLimit = 1
        return configuration
    }()
    private lazy var imagePicker: PHPickerViewController = {
        let imaegPicker = PHPickerViewController(configuration: phpickerConfiguration)
        imaegPicker.delegate = self
        
        return imaegPicker
    }()
    private lazy var userImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.layer.cornerRadius = imageView.layer.frame.size.width / 2
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapPhothImageView))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()
    
    private lazy var nickNameInputView : SignUPInputView = {
        let inputView = SignUPInputView()
        inputView.setInputTextTypeLabel(text: "닉네임")
        inputView.setPlaceholder(placeholder: "닉네임을 입력해주세요.")
        inputView.setConfirmButton(text: "중복확인")
        inputView.confirmButtonDelegate = self
        inputView.setConfrimButton()
        
        return inputView
    }()
    
    private lazy var majorInputView : SignUPInputView = {
       let majorInputView = SignUPInputView()
        majorInputView.setInputTextTypeLabel(text: "학과")
        majorInputView.setPlaceholder(placeholder: "힉과를 입력해주세요.")
        return majorInputView
    }()
    
    private lazy var introduceInputView : SignUPInputView = {
       let majorInputView = SignUPInputView()
        majorInputView.setInputTextTypeLabel(text: "한줄 소개")
        majorInputView.setPlaceholder(placeholder: "한줄 소개를 입력해주세요.")
        return majorInputView
    }()
    
    private lazy var updateProfileButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.backgroundColor = UIColor(hexCode: "F5F5F5")
        button.setText("프로필 수정")
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapUpdateProfileButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        self.navigationController?.navigationBar.isHidden = false
        
        setUserInfo()
        setNavigationBar(title: "프로필수정")
    }
 
}

extension UpdateProfileVC{
    private func setAddSubViews() {
        view.addSubViews([userImageView,nickNameInputView,majorInputView,introduceInputView,updateProfileButton])
    }
    private func setAutoLayout(){
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        nickNameInputView.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        majorInputView.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        introduceInputView.snp.makeConstraints { make in
            make.top.equalTo(majorInputView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.equalTo(introduceInputView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
}

extension UpdateProfileVC {
    @objc private func tapUpdateProfileButton() {
        
        APIUpdateManager.shared.updateUserProfile(nickname: nickNameInputView.getTextFieldText(), department: majorInputView.getTextFieldText(), userSelfIntroduction: introduceInputView.getTextFieldText(), image: userImageView.image ?? UIImage()) { statuCode in
            print("updateUserProfile : statusCode\(statuCode)")
        }
    }
    @objc private func tapPhothImageView() {
        present(imagePicker,animated: true)
    }
}
extension UpdateProfileVC {
    private func setUserInfo() {
        nickNameInputView.setTextField(text: userInfo?.result?.nickname ?? "")
        majorInputView.setTextField(text: userInfo?.result?.department ?? "")
        introduceInputView.setTextField(text: userInfo?.result?.userSelfIntroduction ?? "")
        userImageView.setImageFromStringURL(stringURL: userInfo?.result?.profileImage) { image in
            DispatchQueue.main.async {
                self.userImageView.image = image
                self.userImageView.layer.cornerRadius = self.userImageView.layer.frame.size.width / 2
                self.userImageView.layer.masksToBounds = true
            }
            
        }
    }
}
extension UpdateProfileVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { (image,error) in
                DispatchQueue.main.async {
                    self.userImageView.layer.cornerRadius = self.userImageView.frame.width / 2
                    self.userImageView.layer.masksToBounds = true
                    self.userImageView.image = image as? UIImage
                }
            }
        } else {
            
        }
        
    }
}
extension UpdateProfileVC :ConfirmButtonDelegate {
    func action(sendTextFieldText: String) {
        APIGetManager.shared.checkNickname(nickname: sendTextFieldText) { response,statuscode  in
            guard let message = response?.message else { return }
            if statuscode == 200 {
                self.nicknameCheck = true
            }else {
                self.nicknameCheck = false
            }
            
            self.nickNameInputView.setCheckLabel(isHidden: false, text: "\(message)")
        }
    }
}
