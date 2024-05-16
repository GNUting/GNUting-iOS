//
//  UpdaetProfileVC.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

import UIKit
import PhotosUI
// MARK: - 프로필 수정화면

class UpdateProfileVC: BaseViewController {
    var userInfo: GetUserDataModel?
    
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
    private lazy var userImageButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tapPhothImageView), for: .touchUpInside)

        return button
    }()
    
    private lazy var nickNameInputView : SignUpInputViewNicknameType = {
        let inputView = SignUpInputViewNicknameType()
        inputView.nicknameCheckButtonDelegate = self
        inputView.nicknameTextfiledDelegate = self
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
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.setText("프로필 수정")
        
        button.addTarget(self, action: #selector(tapUpdateProfileButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAddSubViews()
        setAutoLayout()
        self.navigationController?.navigationBar.isHidden = false
        
        setUserInfo()
        setNavigationBar(title: "프로필수정")
    }
    
}

extension UpdateProfileVC{
    private func setAddSubViews() {
        view.addSubViews([userImageButton,nickNameInputView,majorInputView,introduceInputView,updateProfileButton])
    }
    private func setAutoLayout(){
        userImageButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        nickNameInputView.snp.makeConstraints { make in
            make.top.equalTo(userImageButton.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        majorInputView.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.snp.bottom)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        introduceInputView.snp.makeConstraints { make in
            make.top.equalTo(majorInputView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        updateProfileButton.snp.makeConstraints { make in
            
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
    }
    
}

extension UpdateProfileVC {
    @objc private func tapUpdateProfileButton() {
        var userImage = userImageButton.imageView?.image
        if userImageButton.imageView?.image == UIImage(named: "photoImg") {
            userImage = nil
        }
        APIUpdateManager.shared.updateUserProfile(nickname: nickNameInputView.getTextFieldText(), department: majorInputView.getTextFieldText(), userSelfIntroduction: introduceInputView.getTextFieldText(), image: userImage) { response in
            if response.isSuccess {
                self.showMessage(message: "프로필 수정이 완료되었습니다.")
                self.popButtonTap()
            } else {
                if response.code == "TOKEN4001-1" {
                    guard let refreshToken = KeyChainManager.shared.read(key: "RefreshToken") else { return }
                    APIPostManager.shared.updateAccessToken(refreshToken: refreshToken) { response,statusCode  in
                        switch statusCode {
                        case 200..<300:
                            print("🟢 updateAccessToken Success:\(statusCode)")
                            guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return } //🔨
                            KeyChainManager.shared.create(key: email, token: response.result.accessToken)
                            self.tapUpdateProfileButton()
                        default:
                            print("🔴 updateAccessToken Success:\(statusCode)")
                        }
                    }
                    
                } else {
                    self.errorHandling(response: response)
                }
            }
        }
    }
    
    @objc private func tapPhothImageView() {
        let alertController = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "앨범에서 사진/동영상 선택", style: .default, handler: { _ in
            self.present(self.imagePicker,animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "기본 이미지 적용", style: .default, handler: { _ in
            DispatchQueue.main.async {
                self.userImageButton.setImage(UIImage(named: "photoImg"), for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
            }
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .destructive))
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
        
    }
}
extension UpdateProfileVC {
    private func setUserInfo() {
        nickNameInputView.setTextField(text: userInfo?.result?.nickname ?? "")
        majorInputView.setTextField(text: userInfo?.result?.department ?? "")
        introduceInputView.setTextField(text: userInfo?.result?.userSelfIntroduction ?? "")
        userImageButton.setImageFromStringURL(stringURL: userInfo?.result?.profileImage) { image in
            DispatchQueue.main.async {
                self.userImageButton.setImage(image, for: .normal)
                self.userImageButton.layer.cornerRadius = self.userImageButton.layer.frame.size.width / 2
                self.userImageButton.layer.masksToBounds = true
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
                    self.userImageButton.setImage(image as? UIImage, for: .normal)
                    
                    self.userImageButton.layer.cornerRadius = self.userImageButton.frame.width / 2
                    self.userImageButton.layer.masksToBounds = true
                    
                }
            }
        }
    }
}
extension UpdateProfileVC :NicknameCheckButtonDelegate {
    func action(textFieldText: String) {
        APIGetManager.shared.checkNickname(nickname: textFieldText) { response,statuscode  in
            guard let message = response?.message else { return }
            if statuscode == 200 {
                self.updateProfileButton.isEnabled = true
            }else {
                self.updateProfileButton.isEnabled = false
            }
            self.nickNameInputView.setCheckLabel(isHidden: false, text: "\(message)", success: false)
        }
    }
}

extension UpdateProfileVC: NicknameTextfiledDelegate {
    func endEdit() {
        
    }
    func didBegin() {
        updateProfileButton.isEnabled = false
    }
    
}
