//
//  AdvertCollectionViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class AdvertCollectionViewCell: UICollectionViewCell {
    static let identi = "AdvertCollectionViewCellid"
    private lazy var adverImageView : UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func configure(){
        contentView.addSubview(adverImageView)
        adverImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    func setCell(_ model : UIImage){
        adverImageView.image = model
    }
}
