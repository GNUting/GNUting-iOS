//
//  ThrottleButton.swift
//  GNUting
//
//  Created by 원동진 on 5/7/24.
//

// MARK: - 중복클릭을 방지하여 API 통신을 여러번 호출하는것을 막는 버튼

import UIKit

class ThrottleButton: UIButton {
    
    // MARK: - deinit
    
    deinit {
        self.removeTarget(self, action: #selector(self.editingChanged(_:)), for: .touchUpInside)
    }

    // MARK: - Properties
    
    private var workItem: DispatchWorkItem?
    private var delay: Double = 0
    private var callback: ((Date) -> Void)? = nil
}

// MARK: - Method

extension ThrottleButton {
    public func throttle(delay: Double, callback: @escaping ((Date) -> Void)) {
        self.delay = delay
        self.callback = callback
        self.addTarget(self, action: #selector(self.editingChanged(_:)), for: .touchUpInside)
    }
}

// MARK: - Action

extension ThrottleButton {
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
