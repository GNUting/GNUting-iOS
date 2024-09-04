//
//  ChatRoomSecondImageView.swift
//  GNUting
//
//  Created by 원동진 on 5/16/24.
//


import UIKit

class ChatRoomFirstImageView: UIView { 
    private lazy var firstImageButton = UIButton()
  
    private lazy var secondImageButton = UIButton()
 
    private lazy var thirdImageButton = UIButton()

    private lazy var forthImageButton = UIButton()
      
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  
}

extension ChatRoomFirstImageView{
    
    private func setAddSubViews() {
        self.addSubViews([firstImageButton, secondImageButton, thirdImageButton, forthImageButton])
      
    }
    private func setAutoLayout() {
        
        firstImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(1)
        }
        secondImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(1)
        }
        thirdImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(1)
        }
        forthImageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(1)
        }
    }
    
}

extension ChatRoomFirstImageView {
    func setImage(imageArr: [String?],title: String) {
    
        switch imageArr.count{
        case 1:
            self.addSubview(firstImageButton)
            firstImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.width.equalTo(45)
            }
            secondImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            thirdImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            forthImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            
        case 2:
            self.addSubViews([firstImageButton, secondImageButton])
            firstImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(11)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(30)
            }
            secondImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(-11)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(30)
            }
            thirdImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            forthImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
        case 3:
            
            self.addSubViews([firstImageButton, secondImageButton, thirdImageButton])
            firstImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(-11)
                make.height.width.equalTo(30)
            }
            secondImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(11)
                make.centerY.equalToSuperview().offset(11)
                make.height.width.equalTo(30)
            }
            thirdImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(-11)
                make.centerY.equalToSuperview().offset(11)
                make.height.width.equalTo(30)
            }
            forthImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
        case 4:
            self.addSubViews([firstImageButton, secondImageButton, thirdImageButton, forthImageButton])
            firstImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(11)
                make.centerY.equalToSuperview().offset(11)
                make.height.width.equalTo(25)
            }
            secondImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(11)
                make.centerY.equalToSuperview().offset(-11)
                make.height.width.equalTo(25)
            }
            thirdImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(-11)
                make.centerY.equalToSuperview().offset(11)
                make.height.width.equalTo(25)
            }
            forthImageButton.snp.updateConstraints { make in
                make.centerX.equalToSuperview().offset(-11)
                make.centerY.equalToSuperview().offset(-11)
                make.height.width.equalTo(25)
            }
        default:
            firstImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            secondImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            thirdImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
            forthImageButton.snp.updateConstraints { make in
                make.height.width.equalTo(0)
            }
        }
        for (idx,image) in imageArr.enumerated() {
          
           
            switch idx{
            case 0:
                getCacheImageData(imageButton: firstImageButton, imageString: image)

            case 1:
                getCacheImageData(imageButton: secondImageButton, imageString: image)
            case 2:
                getCacheImageData(imageButton: thirdImageButton, imageString: image)
            case 3:
                getCacheImageData(imageButton: forthImageButton, imageString: image)
            default:
                break
            }
        }
    }
    func removeSubViewAll() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    private func getCacheImageData(imageButton: UIButton, imageString: String?) {
        let cacheKey = NSString(string: imageString ?? "")
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
            DispatchQueue.main.async {
                imageButton.setImage(cachedImage, for: .normal)
                imageButton.layer.cornerRadius = imageButton.layer.frame.size.width / 2
                imageButton.layer.masksToBounds = true
            }
        } else {
            imageButton.setImageFromStringURL(stringURL: imageString) { image in
                DispatchQueue.main.async {
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    imageButton.setImage(image, for: .normal)
                    imageButton.layer.cornerRadius = imageButton.layer.frame.size.width / 2
                    imageButton.layer.masksToBounds = true
                }
            }
        }
    }

}
