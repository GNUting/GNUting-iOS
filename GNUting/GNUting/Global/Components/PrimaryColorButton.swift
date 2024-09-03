//
//  ThrottleButton.swift
//  GNUting
//
//  Created by 원동진 on 5/7/24.
//


import UIKit
class PrimaryColorButton: UIButton {
    deinit {
        self.removeTarget(self, action: #selector(self.editingChanged(_:)), for: .touchUpInside)
    }

    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: ((Date) -> Void)? = nil

  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "PrimaryColor")
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = UIColor(named: "PrimaryColor")
            } else {
                self.backgroundColor = UIColor(named: "DisableColor")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text : String,fointSize: Int = 20){
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10)
        
        config.attributedTitle = AttributedString("\(text)", attributes: AttributeContainer([NSAttributedString.Key.font : Pretendard.semiBold(size: CGFloat(fointSize)) ?? .systemFont(ofSize: CGFloat(fointSize)),NSAttributedString.Key.foregroundColor : UIColor.white]))
        config.titleAlignment = .center
        self.configuration = config
    }
    
    func setHeight(height: Int = 60) {
        self.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
    
    func throttle(delay: Double, callback: @escaping ((Date) -> Void)) {
        self.delay = delay
        self.callback = callback
        self.addTarget(self, action: #selector(self.editingChanged(_:)), for: .touchUpInside)
    }

    @objc private func editingChanged(_ sender: UIButton) {
        if self.workItem == nil {
            self.callback?(Date())
            let workItem = DispatchWorkItem(block: { [weak self] in
                self?.workItem?.cancel()
                self?.workItem = nil
            })
            self.workItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay, execute: workItem)
        }
    }
}
