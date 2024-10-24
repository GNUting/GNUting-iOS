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
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var contentView : UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        
        return view
    }()
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
    
    private lazy var nickNameInputView : NicknameTypeInputView = {
        let inputView = NicknameTypeInputView()
        inputView.nicknameCheckButtonDelegate = self
        inputView.nicknameTextfiledDelegate = self
        return inputView
    }()
    
  
    private lazy var majorInputView : MajorInputView = {
        let majorInputView = MajorInputView()
        majorInputView.majorInputViewDelegate = self
        
        return majorInputView
    }()
    private lazy var introduceInputView : CommonInputView = {
        let majorInputView = CommonInputView()
        majorInputView.setInputTextTypeLabel(text: "한줄 소개")
        majorInputView.setPlaceholder(placeholder: "한줄 소개를 입력해주세요.")
        return majorInputView
    }()
    
    private lazy var updateProfileButton : PrimaryColorButton = {
        let button = PrimaryColorButton()
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.setText("프로필 수정")
        button.throttle(delay: 3.0) { _ in
            self.tapUpdateProfileButton()
        }
        
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

extension UpdateProfileVC{
    private func setAddSubViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubViews([userImageButton, nickNameInputView, majorInputView, introduceInputView, updateProfileButton])
    }
    private func setAutoLayout(){
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        userImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        nickNameInputView.snp.makeConstraints { make in
            make.top.equalTo(userImageButton.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        majorInputView.snp.makeConstraints { make in
            make.top.equalTo(nickNameInputView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        introduceInputView.snp.makeConstraints { make in
            make.top.equalTo(majorInputView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
        updateProfileButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(introduceInputView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
}

extension UpdateProfileVC {
    private func tapUpdateProfileButton() {
        var userImage = userImageButton.imageView?.image
        if userImageButton.imageView?.image == UIImage(named: "photoImg") {
            userImage = nil
        }
      
        APIUpdateManager.shared.updateUserProfile(nickname: nickNameInputView.getTextFieldText(), department: majorInputView.getContentLabelText() ?? "영어영문학부", userSelfIntroduction: introduceInputView.getTextFieldText(), image: userImage) { response in
            if response.isSuccess {
                self.showAlert(message: "프로필 수정이 완료되었습니다.")
                self.popButtonTap()
            } else {
                if response.code == "TOKEN4001-1" {
                    guard let refreshToken = KeyChainManager.shared.read(key: "RefreshToken") else { return }
                    APIPostManager.shared.updateAccessToken(refreshToken: refreshToken) { response,statusCode  in
                        switch statusCode {
                        case 200..<300:
                            print("🟢 updateAccessToken Success:\(statusCode)")
                            guard let email = KeyChainManager.shared.read(key: "UserEmail") else { return } //🔨
                            KeyChainManager.shared.create(key: email, token: response.result?.accessToken ?? "")
                            self.tapUpdateProfileButton()
                        case 400..<500:
                            if response.code == "TOKEN4001-3" {
                                self.expirationRefreshtoken()
                            }
                            print("🔴 updateAccessToken failure:\(statusCode)")
                        default:
                            print("🔴 updateAccessToken failure:\(statusCode)")
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
        majorInputView.setContentLabelText(text: userInfo?.result?.department ?? "학과")
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
        APIGetManager.shared.checkNickname(nickname: textFieldText) { response  in
            guard let success = response?.isSuccess else { return }
            self.updateProfileButton.isEnabled = success ? true : false
            self.nickNameInputView.setCheckLabel(isHidden: false, text: "\(response?.message ?? "재시도 해주세요.")", success: false)
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
extension UpdateProfileVC: MajorInputViewDelegate {
    func tapMajorInputView() {
        let vc = SearchMajorVC()
        vc.searchMajorSelectCellDelegate = self
        let navigationVC = UINavigationController(rootViewController: vc)
        
        present(navigationVC, animated: true)
    }
}
extension UpdateProfileVC: SearchMajorSelectCellDelegate {
    func sendSeleceted(major: String) {
        majorInputView.setContentLabelText(text: major)
    }
}
