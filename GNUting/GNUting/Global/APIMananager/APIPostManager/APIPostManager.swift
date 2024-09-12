//
//  APIPostManager.swift
//  GNUting
//
//  Created by 원동진 on 3/11/24.
//
import UIKit

import Alamofire
// ✅ : 분기 처리 완료

class APIPostManager {
    static let shared = APIPostManager()
    
    // MARK: - 토큰 : AT 갱신
    func updateAccessToken(refreshToken: String, completion: @escaping(RefreshAccessTokenResponse,Int)->Void){
        let url = EndPoint.updateAccessToken.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["refreshToken": refreshToken]
        
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseDecodable(of:RefreshAccessTokenResponse.self) { response in
                guard let statusCode = response.response?.statusCode else { return }
                guard let responseData = response.value else { return }
                switch statusCode {
                case 200..<300:
                    completion(responseData, statusCode)
                case 400..<500:
                    completion(responseData, statusCode)
                default:
                    completion(responseData, statusCode)
                }
                
                
                
            }
    }
    
    // MARK: - 토큰 : FCM토큰
    
    func postFCMToken(fcmToken: String, completion: @escaping(DefaultResponse?) -> Void) {
        let url = EndPoint.fcmToken.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = FcmTokenModel(fcmToken: fcmToken)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postFCMToken statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postFCMToken statusCode: \(statusCode)")
                    completion(json)
                    break
                }
                
            }
        
    }
    // MARK: - 회원가입 : 이메일 인증 번호 전송 ✅
    
    func postEmailCheck(email: String,completion: @escaping(EmailCheckResponse?,FailureResponse?)->Void) {
        let url = EndPoint.emailCheck.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .responseData { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                switch statusCode {
                case 200..<300:
                    guard let json = try? JSONDecoder().decode(EmailCheckResponse.self, from: data) else { return }
                    print("🟢 postEmailCheck statusCode :\(statusCode)")
                    print("\(json)")
                    completion(json,nil)
                default:
                    guard let json = try? JSONDecoder().decode(FailureResponse.self, from: data) else { return }
                    print("🔴 postEmailCheck statusCode :\(statusCode)")
                    completion(nil,json)
                }
            }
         
    }
    // MARK: - 비밀번호 변경 : 이메일 인증 번호 전송
    func postEmailCheckChangePassword(email: String,completion: @escaping(EmailCheckResponse)->Void) {
        let url = EndPoint.emailCheckChangePassword.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(EmailCheckResponse.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    print("🟢 postEmailCheckChangePassword statusCode :\(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postEmailCheckChangePassword statusCode :\(statusCode)")
                    completion(json)
                }
            }
    }
    // MARK: - 회원가입 : 인증 번호 확인 ✅
    func postAuthenticationCheck(email: String, number: String, completion: @escaping(DefaultResponse)->Void) {
        let url = EndPoint.checkMailVerify.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email,"number":number]
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postAuthenticationCheck statusCode :\(statusCode)")
                    
                    completion(json)
                case .failure:
                    print("🔴 postAuthenticationCheck statusCode :\(statusCode)")
                    
                    completion(json)
                    break
                }
            }
        
    }
    // MARK: - 회원가입  ✅
    func postSignUP(signUpdata : SignUpModel,image : UIImage?,completion: @escaping (DefaultResponse) -> Void) {
        let url = EndPoint.signUp.url
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        let parameters : [String : String] = ["birthDate":signUpdata.birthDate,"department":signUpdata.department,"email": signUpdata.email,"gender": signUpdata.gender," name": signUpdata.name,"nickname": signUpdata.nickname, "password": signUpdata.password, "phoneNumber" : signUpdata.phoneNumber, "studentId": signUpdata.studentId,"userSelfIntroduction": signUpdata.userSelfIntroduction]
        
        let imageData = image?.jpegData(compressionQuality: 0.2)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key,value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
       
            if let image = imageData {
                
                multipartFormData.append(image, withName: "profileImage",fileName: "UserImage.jpeg",mimeType: "image/jpg")
            }
        }, to: url,method: .post,headers: header)
        .validate(statusCode: 200..<300)
        .responseData { response in
            guard let statusCode = response.response?.statusCode, let data = response.data else { return }
            guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
            switch response.result {
            case .success:
                print("🟢 postSignUP statusCode :\(statusCode)")
                completion(json)
            case .failure:
                print("🔴 postSignUP statusCode :\(statusCode)")
                
                completion(json)
                break
            }
        }
    }
    
    // MARK: - 로그인 ✅
    
    func postLoginAPI(email: String, password: String, completion: @escaping (DefaultResponse?,LoginSuccessResponse?) -> Void) { // httpbody가아니라 파라미터로 넣는데 통신되는 이유 ?
        let url = EndPoint.login.url
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        let parameters : [String : String] = ["email": email,"password":password]
        
        AF.request(url,method: .post,parameters: parameters,encoding: JSONEncoding.default,headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                switch response.result {
                case .success:
                    print("🟢 postLoginAPI statusCode :\(statusCode)")
                    guard let json = try? JSONDecoder().decode(LoginSuccessResponse.self, from: data) else { return }
                    let accessToken = json.result.accessToken
                    let refrechToken = json.result.refreshToken
                    KeyChainManager.shared.create(key: email, token: accessToken)
                    KeyChainManager.shared.create(key: "UserEmail", token: email)
                    KeyChainManager.shared.create(key: "RefreshToken", token: refrechToken)
                    
                    
                    UserDefaultsManager.shared.setLogin()
                    
                    completion(nil,json)
                case .failure:
                    guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                    print("🔴 postLoginAPI statusCode :\(statusCode)")
                    completion(json,nil)
                    break
                }
            }
    }
    // MARK: - 로그 아웃
    func postLogout(completion: @escaping(ResponseWithResult?)->Void) {
        let url = EndPoint.logout.url
        guard let refreshToken = KeyChainManager.shared.read(key:"RefreshToken") else { return }
        guard let fcmToken = KeyChainManager.shared.read(key: "fcmToken") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let requestBody = RefreshTokenModel(refreshToken: refreshToken,fcmToken: fcmToken)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .responseData { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(ResponseWithResult.self, from: data) else { return }
                
                switch response.result {
                case .success:
                    UserDefaultsManager.shared.setLogout()
                    print("🟢 postLogout statusCode :\(statusCode)")
                    completion(json)
                    
                case .failure:
                    
                    print("🔴 postLogout statusCode :\(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    
    // MARK: - 글쓰기 ✅
    func postWriteText(title: String,detail:String,joinMemberID: [UserIDList],completion: @escaping(DefaultResponse)->Void) {
        let url = EndPoint.writeText.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = WriteTextUserData(title: title, detail: detail, inUser: joinMemberID)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postWriteText statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postWriteText statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    // MARK: - 채팅 신청 ✅
    func postRequestChat(userInfos: [UserInfosModel],boardID: Int, completion: @escaping(DefaultResponse?) -> Void){
        
        let uslString = BaseURL.shared.urlString + "board/apply/\(boardID)"
        guard let url = URL(string: uslString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = userInfos
        
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
  
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response{ response in
                
                guard let statusCode = response.response?.statusCode else { return }
                if let data = response.data {
                    guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                    if json.isSuccess {
                        print("🟢 postRequestChat statusCode: \(statusCode)")
                        completion(json)
                    } else {
                        print(json)
                        print("🔴 postRequestChat statusCode: \(statusCode)")
                        completion(json)
                    }
                }
            }
    }
    
    // MARK: - 채팅 신청 : 승인하기
    func chatConfirmed(id: Int, completion: @escaping(DefaultResponse) -> Void) {
        let uslString = BaseURL.shared.urlString + "board/applications/accept/\(id)"
        guard let url = URL(string: uslString) else { return }
        AF.request(url,method: .post,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 chatConfirmed statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 chatConfirmed statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    // MARK: - 글 신고하기 ✅
    func reportBoardPost(boardID: Int,reportCategory: String, reportReason: String, completion: @escaping(DefaultResponse)-> Void) {
        let url = EndPoint.reportPost.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = ReportPostModel(boardId: boardID, reportCategory: reportCategory, reportReason: reportReason)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postReportBoard statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postReportBoard statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    // MARK: - 유저신고하기 ✅
    func reportUser(nickName: String,reportCategory: String, reportReason: String, completion: @escaping(DefaultResponse)-> Void) {
        let url = EndPoint.reportUser.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = ReportUserModel(nickName: nickName, reportCategory: reportCategory, reportReason: reportReason)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        }catch {
            print("Error encoding request data: \(error)")
            return
        }
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 reportUser statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 reportUser statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    // MARK: - 채팅방 나가기
    
    func postLeavetChatRoom(chatRoomID: Int,completion: @escaping(DefaultResponse)->Void) {
        let uslString = BaseURL.shared.urlString + "chatRoom/\(chatRoomID)/leave"
        guard let url = URL(string: uslString) else { return }
        AF.request(url,method: .post,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postLeavetChatRoom statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postLeavetChatRoom statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
    
    
    // MARK: - 메모저장
    
    func postNoteRegister(content: String, completion: @escaping(DefaultResponse?) -> Void) {
        let url = EndPoint.noteRegisterPost.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let requestBody = NotePostModel(content: content)
        do {
            try request.httpBody = JSONEncoder().encode(requestBody)
        } catch {
            print("Error encoding request data: \(error.localizedDescription)")
            return
        }
        
        AF.request(request,interceptor: APIInterceptorManager())
            .validate(statusCode: 200..<300)
            .response { response in
                guard let statusCode = response.response?.statusCode, let data = response.data else { return }
                guard let json = try? JSONDecoder().decode(DefaultResponse.self, from: data) else { return }
                switch response.result {
                case .success:
                    print("🟢 postFCMToken statusCode: \(statusCode)")
                    completion(json)
                case .failure:
                    print("🔴 postFCMToken statusCode: \(statusCode)")
                    completion(json)
                    break
                }
            }
    }
}

