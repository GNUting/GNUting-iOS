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
                }        }
    }
    
}

