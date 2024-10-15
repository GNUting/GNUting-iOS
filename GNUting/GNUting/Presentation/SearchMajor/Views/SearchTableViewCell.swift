//
//  MajorSearchTableViewCell.swift
//  GNUting
//
//  Created by 원동진 on 3/19/24.
//

// MARK: - 학과 검색 VC TableView Cell

import UIKit

class SearchTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identi = "SearchTableViewCellid"
    
    // MARK: - SubViews
    
    private lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.bold(size: 16)
        label.textAlignment = .left
        
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTableViewCell {
    
    // MARK: - Layout Helpers
    
    private func configure() {
        contentView.addSubview(majorLabel)
        majorLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(26)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - SetView
    
    func setCell(model : SearchMajorModelResult){
        majorLabel.text = model.name
    }
}
