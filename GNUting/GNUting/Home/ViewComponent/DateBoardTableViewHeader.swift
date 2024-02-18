//
//  DateBoardTableViewHeader.swift
//  GNUting
//
//  Created by 원동진 on 2/18/24.
//

import UIKit

class DateBoardTableViewHeader: UITableViewHeaderFooterView {
    static let identi = "DateBoardTableViewHeaderid"
    private lazy var upperStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    private let boardNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.Bold.rawValue, size: 18)
        label.text = "과팅 게시판"
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private lazy var moreViewButton : UIButton = {
        let button = UIButton()
        button.setTitle("더보기 >", for: .normal)
        button.setTitleColor(UIColor(hexCode: "767676"), for: .normal)
        button.titleLabel?.font = UIFont.init(name: Pretendard.SemiBold.rawValue, size: 15)
        return button
    }()
    private let borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "E9E9E9")
        return view
    }()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure(){
        contentView.addSubViews([upperStackView,borderView])
        upperStackView.addStackSubViews([boardNameLabel,moreViewButton])
        upperStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        borderView.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(15)
            make.left.bottom.right.equalToSuperview()
        }
    }
}
