//
//  NoteViewController.swift
//  GNUting
//
//  Created by 원동진 on 9/11/24.
//

// MARK: - 메모팅 VC

import UIKit

final class NoteViewController: BaseViewController {
    
    let noticeStackView = NoticeStackView(text: "업로드 된 메모는 매일 자정에 초기화됩니다.")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAddSubViews()
        setAutoLayout()
    }

}

extension NoteViewController{
    private func setAddSubViews() {
        
    }
    private func setAutoLayout(){
        
    }
    
}
