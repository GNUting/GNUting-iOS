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
        label.font = UIFont(name: Pretendard.SemiBold.rawValue, size: 15)
        label.text = "짱짱맨(asd123)"
        label.textColor = .white
        return label
    }()
    private lazy var cancelImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CancelImg")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexCode: "D5CFCF")
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
        containerView.addSubViews([userIDNameLabel,cancelImageView])
    }
    private func setAutoLayout(){
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userIDNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
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
        self.layer.masksToBounds = true
    }
    func setCell(text: String) {
        userIDNameLabel.text = text
    }
}
