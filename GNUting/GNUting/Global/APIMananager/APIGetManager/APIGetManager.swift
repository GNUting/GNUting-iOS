//
//  APIGetManager.swift
//  GNUting
//
//  Created by 원동진 on 3/12/24.
//
// ✅ : 분기 처리 완료
import Foundation

import Alamofire

class APIGetManager: RequestInterceptor {
    static let shared = APIGetManager()
    
    // MARK: - 회원 가입 : 닉네임 중복확인 ✅
    func checkNickname(nickname: String, completion: @escaping(NicknameCheckModel?,Int) -> Void) {
        let url = EndPoint.checkNickname.url
        let parameters : [String : String] = ["nickname": nickname]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default)
            .responseDecodable(of: NicknameCheckModel.self){ response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch statusCode {
                case 200..<300:
                    print("🟢 checkNickname Success:\(statusCode)")
                    completion(response.value,statusCode)
                default:
                    guard let data = response.value else { return }
                    print("🔴 checkNickname Data: \(data)")
                    completion(data,statusCode)
                }
            }
    }
    
    // MARK: - 회원가입 : 학과 검색 ✅ 없는것 검색하면 데이터 안나옴
    func searchMajor(major: String,completion:@escaping(SearchMajorModel?,Int) -> Void) { // 학과검색
        let url = EndPoint.searchMajor.url
        let parameters: [String:Any] = ["name": major]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default)
            .responseDecodable(of: SearchMajorModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch statusCode {
                case 200..<300:
                    print("🟢 searchMajor Success:\(statusCode)")
                    completion(response.value,statusCode)
                default:
                    print("🔴 searchMajor Data:\(statusCode)")
                    completion(response.value,statusCode)
                    break
                }
            }
    }
    
    // MARK: - 사용자 정보 ✅ 에러메시지 출력
    func getUserData(completion: @escaping(GetUserDataModel?,DefaultResponse?) -> Void) {
        let url = EndPoint.getUserData.url
        
        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GetUserDataModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 getUserData statusCode :\(statusCode)")
                    completion(response.value,nil)
                case .failure:
                    print("🔴 getUserData statusCode :\(statusCode)")
                    
                    completion(response.value,json)
                    break
                }
            }
    }
    // MARK: - 게시글 : 모든 게시물 보기 ✅ 에러메시지 출력
    
    func getBoardText(page:Int, size: Int, completion: @escaping(BoardModel?,DefaultResponse?)-> Void) {
        let url = EndPoint.getBoardData.url
        
        let parameters: [String:Any] = ["page": page, "size": size]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:BoardModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 getBoardText statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getBoardText statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    

    // MARK: - 게시글 : 검색 ✅ 에러메시지 출력
    func getSearchBoardText(searchText: String,page: Int, completion: @escaping(SearchBoardTextModel?,DefaultResponse?)->Void) {
        let url = EndPoint.searchGetBoardData.url
        let parameters: [String:Any] = ["keyword": searchText,"page": page]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:SearchBoardTextModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getSearchBoardText statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getSearchBoardText statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    // MARK: - 게시글 : 내 글 정보 ✅ 에러메시지 출력
    
    func getMyPost(completion: @escaping(MyPostModel?,DefaultResponse?) -> Void) {
        let url = EndPoint.mypost.url
        
        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:MyPostModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getMyPost statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getMyPost statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    // MARK: - 게시물 : Detail ✅  쿼리파라미터로 id값넣으면 안됨
    
    func getBoardDetail(id: Int, completion: @escaping(BoardDetailModel?,DefaultResponse?) -> Void) {
        let urlString = BaseURL.shared.urlString + "board/\(id)"
        guard let url = URL(string: urlString) else { return }
        
        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:BoardDetailModel.self){ response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
     
                switch response.result {
                case .success:
                    print("🟢 getBoardDetail statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getBoardDetail statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    // MARK: - 신청 현황: 신청받은 목록 ✅
    
    func getReceivedChatState(completion: @escaping(ApplicationStatusModel?,DefaultResponse?)->Void) {
        let url = EndPoint.receivedState.url
        
        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:ApplicationStatusModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
     
                switch response.result {
                case .success:
                    print("🟢 getReceivedChatState statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getReceivedChatState statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    // MARK: - 신청 현황: 신청 목록 ✅
    
    func getRequestChatState(completion: @escaping(ApplicationStatusModel?,DefaultResponse?)->Void) {
        let url = EndPoint.requestStatus.url
        
        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .responseDecodable(of:ApplicationStatusModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
     
                switch response.result {
                case .success:
                    print("🟢 getRequestChatState statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getRequestChatState statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    
    // MARK: - 사용자 검색 ✅
    
    func getSearchUser(searchNickname: String, completion:@escaping(SearchUserModel?,DefaultResponse?)-> Void) {
        let url = EndPoint.searchGetUserData.url
        
        let parameters: [String:Any] = ["nickname": searchNickname]
        AF.request(url,method: .get,parameters: parameters,encoding: URLEncoding.default,interceptor: APIInterceptorManager())
            .responseDecodable(of: SearchUserModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getSearchUser statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getSearchUser statusCode: \(statusCode)")
                    completion(response.value,json)
                    break
                }
            }
    }
    
    // 채팅 리스트 조회
    
    func getChatRoomData(completion: @escaping(ChatRoomModel?,DefaultResponse)->Void) {
        let url = EndPoint.chatRoom.url
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatRoomModel.self) { response in
                    guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                    guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                    switch response.result {
                    case .success:
                        print("🟢 getChatRoomData statusCode: \(statusCode)")
                        completion(response.value,json)
                    case .failure:
                        print("🔴 getChatRoomData statusCode: \(statusCode)")
                        
                        completion(response.value,json)
                        break
                    }
            }
    }
    
    // 채팅방 채팅 조회
    
    func getChatMessageData(chatRoomID: Int,completion: @escaping(ChatRoomMessageModel?,DefaultResponse)->Void) {
        let urlString = BaseURL.shared.urlString + "chatRoom/\(chatRoomID)/chats"
        guard let url = URL(string: urlString) else { return }

        AF.request(url,method: .get,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:ChatRoomMessageModel.self) { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getChatMessageData statusCode: \(statusCode)")
                    completion(response.value,json)
                case .failure:
                    print("🔴 getChatMessageData statusCode: \(statusCode)")
    
                    completion(response.value,json)
                    break
                }
            }
        
    }
    
    // MARK: - 알림 모두 보기
    
    func getNotificationData(completion: @escaping(NotificationModel?)->Void) {
        let url = EndPoint.notification.url
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: NotificationModel.self) { response in
                    guard let statusCode = response.response?.statusCode else { return }
             
                    switch response.result {
                    case .success:
                        print("🟢 getNotificationData statusCode: \(statusCode)")
                        completion(response.value)
                    case .failure:
                        print("🔴 getNotificationData statusCode: \(statusCode)")
                        completion(response.value)
                        break
                    }
            }
    }
    
    // MARK: - 새알림 확인
    
    func getNotificationCheck(completion: @escaping(NotificationCheckModel?)->Void){
        let url = EndPoint.notificationCheck.url
        AF.request(url,interceptor: APIInterceptorManager())
            .responseDecodable(of: NotificationCheckModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                    switch response.result {
                    case .success:
                        print("🟢 getNotificationCheck statusCode: \(statusCode)")
                        completion(response.value)
                    case .failure:
                        print("🔴 getNotificationCheck statusCode: \(statusCode)")
                        completion(response.value)
                        break
                    }
            }
    }
    
    // MARK: - 사용자 채팅알림 세팅값 API
    
    func getChatRoomSetAlertStatus(chatRoomID: Int, completion: @escaping(ChatRoomAlertStatusModel?) -> Void) {
        let url = BaseURL.shared.urlString + "\(chatRoomID)" + "/show/notificationSetting"
        AF.request(url,interceptor: APIInterceptorManager())
            .responseDecodable(of: ChatRoomAlertStatusModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success:
                    print("🟢 getNotificationCheck statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getNotificationCheck statusCode: \(statusCode)")
                    completion(response.value)
                    break
                }
        }
    }
    
    // MARK: - 전체 알람보기 세팅값 API
    
    func getTotalSetAlertStatus(completion: @escaping(ChatRoomAlertStatusModel?) -> Void) {
        let url = EndPoint.notificationShowAllsetting.url
        AF.request(url,interceptor: APIInterceptorManager())
            .responseDecodable(of: ChatRoomAlertStatusModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success:
                    print("🟢 getTotalSetAlertStatus statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getTotalSetAlertStatus statusCode: \(statusCode)")
                    completion(response.value)
                    break
                }
        }
    } 
    
    // MARK: - 채팅 참여인원 Get
    
    func getChatRoomUserList(chatRoomID: Int,completion: @escaping(ChatRoomUserModel?) -> Void) {
        let url = BaseURL.shared.urlString + "chatRoom/\(chatRoomID)" + "/chatRoomUsers"
        
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ChatRoomUserModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getChatRoomUser statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getChatRoomUser statusCode: \(statusCode)")
                    completion(response.value)
                    
                    break
                }
        }
    }
    // MARK: - 알림 클릭시 클릭한 신천받은 현황 ID로 조회하는 API
    func getApplicationReceivedData(applcationID: String,completion: @escaping(ApplicationReceivedModel?) -> Void) {
        let url = BaseURL.shared.urlString + "notification/application/click/" + applcationID
        
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ApplicationReceivedModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success:
                    print("🟢 getApplicationReceivedData statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getApplicationReceivedData statusCode: \(statusCode)")
                    completion(response.value)
                    break
                }
        }
    }
    // MARK: - 채팅 알림 클릭시 이동에 필요한 데이터 API 채팅방 제목, 학과
    func getChatRoomNavigationInfo(chatRoomID: Int,completion: @escaping(AlertChatModel?) -> Void) {
        let url = BaseURL.shared.urlString + "notification/chat/click/" + "\(chatRoomID)"
        
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AlertChatModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                
                switch response.result {
                case .success:
                    print("🟢 getChatRoomNavigationInfo statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getChatRoomNavigationInfo statusCode: \(statusCode)")
                    completion(response.value)
                    
                    break
                }
        }
    }
    
    // MARK: - 메모리스트 읽기
    
    func getNoteInformation(completion: @escaping(NoteGetModel?)->Void) {
        let url = EndPoint.noteRead.url
        AF.request(url,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseDecodable(of:NoteGetModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success:
                    print("🟢 getNoteInformation statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getNoteInformation statusCode: \(statusCode)")
                    completion(response.value)
                    break
                }
            }
    }
    
    // MARK: - 신청 남은 횟수 Read
    
    func getNoteTingRemainApply(completion: @escaping(NoteApplRemainModel?) -> Void) {
        let url = EndPoint.noteApplyRemainCount.url
        AF.request(url,interceptor: APIInterceptorManager())
            .responseDecodable(of:NoteApplRemainModel.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                switch response.result {
                case .success:
                    print("🟢 getNoteTingRemainApply statusCode: \(statusCode)")
                    completion(response.value)
                case .failure:
                    print("🔴 getNoteTingRemainApply statusCode: \(statusCode)")
                    completion(response.value)
                    break
                }
            }
    }
    
    // MARK: - Evnet 총학생회 이벤트 open Close
    
    func getEventSeverOpen() {
        let url = EndPoint.eventIsOpenSever.url
        AF.request(url,interceptor: APIInterceptorManager())
            .response { response in
                print(response)
            }
    }
}

