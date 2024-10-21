//
//  AddMemeberCollectionViewCell.swift
//  GNUting
//
//  Created by 원동진 on 2/28/24.
//

import UIKit

class AddMemeberCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identi = "AddMemeberCollectionViewCellid"
    
    // MARK: - SubViews
    
    private lazy var containerView = UIView()
    
    private lazy var userIDNameLabel: UILabel = {
       let label = UILabel()
        label.font = Pretendard.semiBold(size: 15)
        label.textColor = UIColor(named: "DisableColor")
        
        return label
    }()
    
    private lazy var cancelImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CancelImg")
        
        return imageView
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        setAddSubViews()
        setAutoLayout()
        self.setLayerCorner(cornerRaius: 10,borderColor: UIColor(named: "SecondaryColor"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddMemeberCollectionViewCell {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        contentView.addSubview(containerView)
        containerView.addSubViews([userIDNameLabel, cancelImageView])
    }
    private func setAutoLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userIDNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.verticalSpacing8)
            make.left.equalToSuperview().offset(10)
        }
        cancelImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Spacing.verticalSpacing10)
            make.left.equalTo(userIDNameLabel.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: - SetView
    
    func setCell(text: String) {
        userIDNameLabel.text = text
    }
}
