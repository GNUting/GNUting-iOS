//
//  HomeBottomView.swift
//  GNUting
//
//  Created by 원동진 on 9/5/24.
//

// MARK: 홈 하단 화면

import UIKit

// MARK: - Protocol

protocol HomeBottomViewDelegate: AnyObject {
    func tapPostBoardCardView()
    func tapMypostCardView()
}

class HomeBottomView: UIView {
    
    // MARK: - Properties
    
    weak var homeBottomViewDelegate: HomeBottomViewDelegate?
    
    // MARK: - SubViews
    
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bannerImage")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let postSubView: ImagePlusLabelView = {
        let view = ImagePlusLabelView()
        view.setImagePlusLabelView(imageName: "PostImage", textFont: Pretendard.bold(size: 16) ?? .boldSystemFont(ofSize: 16), labelText: "모든 게시글은 여기서 볼 수 있어요")
        
        return view
    }()
    
    let cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private lazy var postBoardCardView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "PostBoardCardImage"), for: .normal)
        button.addAction(UIAction { [self] _ in
            homeBottomViewDelegate?.tapPostBoardCardView()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mypostCardView: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "MypostCardImage"), for: .normal)
        button.addAction(UIAction { [self] _ in
            homeBottomViewDelegate?.tapMypostCardView()
        }, for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Init
    
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

// MARK: - Layout Helpers

extension HomeBottomView {
    private func setAddSubViews() {
        self.addSubViews([bannerImageView, postSubView, cardStackView])
        cardStackView.addStackSubViews([postBoardCardView, mypostCardView])
    }
    
    private func setAutoLayout(){
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.left.right.equalToSuperview().inset(25)
        }
        
        postSubView.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(27)
            make.left.right.equalToSuperview().inset(25)
        }
        
        cardStackView.snp.makeConstraints { make in
            make.top.equalTo(postSubView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview()
        }
    }
}
