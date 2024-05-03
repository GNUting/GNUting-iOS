//
//  NoDataScreenView.swift
//  GNUting
//
//  Created by 원동진 on 5/3/24.
//

import UIKit

class NoDataScreenView: UIView {
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "NoDataImage")
        return imageView
    }()
    private lazy var label: UILabel = {
       let label = UILabel()
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 18)
        label.textColor = UIColor(named: "DisableColor")
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension NoDataScreenView{
    private func setAddSubViews() {
        addSubViews([imageView,label])
    }
    private func setAutoLayout(){
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
extension NoDataScreenView {
    func setLabel(text: String,range:String) {
        label.text = text
        label.setRangeTextFont(fullText: text, range: range, uiFont: UIFont(name: Pretendard.Regular.rawValue, size: 14) ?? .systemFont(ofSize: 14))
    }
}
