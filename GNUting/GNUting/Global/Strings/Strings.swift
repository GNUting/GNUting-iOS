//
//  ExplainStrings.swift
//  GNUting
//
//  Created by 원동진 on 10/24/24.
//

// MARK: - 정적인 String값 관리

import Foundation

enum Strings {
    enum Report {
        static let explain = """
        신고하기 전에 잠깐!
        
        이 글이 운영진에 의해 삭제되어야 마땅하다고 생각된다면 신고해주세요!
        이용규칙에 위배되는 글을 여러 차례 계시하여 신고를 많이 받은 회원은 제한 조취가 취해집니다.
        
        신고는 사용자의 반대 의견을 표시하는 것이 아닙니다.
        사용자의 신고가 건전하고 올바른 지누팅 문화를 만듭니다.
        허위 신고의 경우 신고자가 제재를 받을 수 있습니다.
        """
        
        static let textViewPlaceHolder = "기타 사유를 입력해주세요."
    }
    
    enum WriteDateBoard {
        static let textPlaceHolder = "내용을 입력해주세요."
    }
    
    enum RequestState {
        static let emptyDataExplain = "신청현황이 비어있습니다.\n과팅 게시판을 이용하거나 게시글을 써보세요!"
        static let segmentIndexStrings = ["신청목록","신청 받은 목록"]
    }
}
