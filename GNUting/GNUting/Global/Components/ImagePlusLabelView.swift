//
//  ImagePlusLabelView.swift
//  GNUting
//
//  Created by 원동진 on 5/3/24.
//

import UIKit

class ImagePlusLabelView: UIView {

    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension ImagePlusLabelView{
    private func setAddSubViews() {
        addSubViews([imageView, label])
    }
    private func setAutoLayout(){
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(20)
        }
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
extension ImagePlusLabelView {
    func setImagePlusLabelView(imageName: String, textFont : UIFont, labelText: String) {
        imageView.image = UIImage(named: imageName)
        label.font = textFont
        label.text = labelText
    }
}
