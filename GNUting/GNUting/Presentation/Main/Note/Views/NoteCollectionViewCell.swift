//
//  NoteCollectionViewCell.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 메모팅 collectionView Cell

import UIKit

class NoteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identi = "AddMemeberCollectionViewCellid"
    
    // MARK: - SubViews
    
    let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NoteImage")
        
        return imageView
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium(size: 12)
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAddSubViews()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteCollectionViewCell {
    
    // MARK: - Layout Helpers
    
    private func setAddSubViews() {
        self.addSubview(noteImageView)
        noteImageView.addSubview(noteLabel)
    }
    
    private func setAutoLayout() {
        noteImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noteLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
    }
    
    // MARK: - Set Cell
    
    func setCell(content: String?) {
        noteLabel.text = content
    }
}
