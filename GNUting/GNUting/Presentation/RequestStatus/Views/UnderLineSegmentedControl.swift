//
//  UnderLineSegmentedControl.swift
//  GNUting
//
//  Created by 원동진 on 2/29/24.
//

// MARK: - 신청목록 / 신청받은 목록 select UISegmentedControl

import UIKit

class UnderLineSegmentedControl: UISegmentedControl {
    
    // MARK: - SubViews
    
    private lazy var underlineView: UIView = {
        let width = self.bounds.size.width / CGFloat(self.numberOfSegments) // 각 세그먼트 width
        let xPosition = CGFloat(self.selectedSegmentIndex * Int(width)) // 선택된 segment x좌표
        let yPosition = self.bounds.size.height - 1.0 // underline y좌표
        let view = UIView(frame: CGRect(x: xPosition, y: yPosition, width: width, height: 2.0))
        view.backgroundColor = UIColor(named: "PrimaryColor")
        self.addSubview(view)
        
        return view
    }()
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        removeBackgroundAndDivider()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        removeBackgroundAndDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - func
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIView.animate(withDuration: 0.1, animations: {
            self.underlineView.frame.origin.x = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
        })
    }
    
    private func removeBackgroundAndDivider() { // 기본 배경색 및 구분선 제거
        let image = UIImage()
        self.setBackgroundImage(image, for: .normal, barMetrics: .default)
        self.setBackgroundImage(image, for: .selected, barMetrics: .default)
        self.setBackgroundImage(image, for: .highlighted, barMetrics: .default)
        self.setDividerImage(image, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    }
}
