//
//  AddMemeberCollectionViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

class AddMemeberCollectionViewCell: UICollectionViewCell {
    static let identi = "AddMemeberCollectionViewCellid"
    var config = UIButton.Configuration.plain()
    private lazy var containerView = UIView()
    private lazy var userIDNameLabel : UILabel = {
       let label = UILabel()
        label.font = Pretendard.semiBold(size: 15)
        
        label.textColor = UIColor(named: "DisableColor")
        return label
    }()
    private lazy var cancelImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CancelImg")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        setlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddMemeberCollectionViewCell{
    private func setAddSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubViews([userIDNameLabel, cancelImageView])
    }
    private func setAutoLayout(){
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userIDNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-8)
        }
        cancelImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(userIDNameLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    private func setlayer() {
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "SecondaryColor")?.cgColor
        self.layer.masksToBounds = true
    }
    func setCell(text: String) {
        userIDNameLabel.text = text
    }
}
