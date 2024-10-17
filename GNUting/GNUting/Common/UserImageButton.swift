//
//  UserImageButton.swift
//  GNUting
//
//  Created by 원동진 on 4/9/24.
//

import UIKit
protocol UserImageButtonDelegate : AnyObject {
    func tappedAction()
}
class UserImageButton: UIButton {
    weak var userImageButtonDelegate : UserImageButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(tapUserImageButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
extension UserImageButton {
    @objc private func tapUserImageButton() {
        let vc = GlobalUtil.currentTopViewController()
        vc?.presentFullScreenVC(viewController: UserDetailVC())
        userImageButtonDelegate?.tappedAction()
    }

}
