//
//  ReportVC.swift
//  GNUting
//
//  Created by 원동진 on 2/23/24.
//

import UIKit

class ReportVC: UIViewController {
    private let explainLabel : UILabel = {
        let fullText = """
신고하기 전에 잠깐!
이 글이 운영진에 의해 삭제되어야 마땅하다고 생각된다면 신고해주세요!
이용규칙에 위배되는 글을 여러 차례 계시하여 신고를 많이 받은 회원은 제한 조취가 취해집니다.

신고는 사용자의 반대 의견을 표시하는 것이 아닙니다.
사용자의 신고가 건전하고 올바른 지누팅 문화를 만듭니다.
허위 신고의 경우 신고자가 제재를 받을 수 있습니다.
"""
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont(name: Pretendard.Medium.rawValue, size: 15)
        label.numberOfLines = 0
        
        label.text = fullText
        label.setRangeTextFont(fullText: fullText, range: "신고하기 전에 잠깐!", uiFont: UIFont(name: Pretendard.Bold.rawValue, size: 25)!)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setVC()
        addSubViews()
        setAutoLayout()
    }
}
extension ReportVC{
    private func setVC(){
        view.backgroundColor = .white
    }
    private func setNavigationBar(){
        navigationItem.title = "신고하기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont(name: Pretendard.Medium.rawValue, size: 18)! ]
    }
    
}
extension ReportVC{
    private func addSubViews() {
        view.addSubViews([explainLabel])
    }
    private func setAutoLayout() {
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Spacing.top)
            make.left.equalToSuperview().offset(Spacing.left)
            make.right.equalToSuperview().offset(Spacing.right)
        }
    }
    
}
