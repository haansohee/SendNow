//
//  MemberService.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import KakaoSDKAuth

final class MemberService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setKakaoMemberInfo(with signinWithKakaoDomain: SigninWithKakaoDomain, completion: @escaping((Bool)) -> Void) {
        let path = "/SendNow/setKakaoMemberInfo/"
        let member = signinWithKakaoDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func setAppleMemberInfo(with signinWithAppleDomain: SigninWithAppleDomain, completion: @escaping(Bool)->Void) {
        let path = "/SendNow/setAppleMemberInfo/"
        let member = signinWithAppleDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func setEmailMemberInfo(with signinWithEmailDomain: SigninWithEmailDomain, completion: @escaping(Bool)->Void) {
        let path = "/SendNow/setEmailMemberInfo/"
        let member = signinWithEmailDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member) { result in
            completion(result)
        }
    }
    
    func updateSearchID(with updateSearchIdDomain: UpdateSearchIdDomain, completion: @escaping(Bool)->Void) {
        let path = updateSearchIdDomain.email.isEmpty ? "/SendNow/updateSNSUserSearchID/" : "/SendNow/updateEmailUserSearchID/"
        let updateSearchID = updateSearchIdDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateSearchID) { result in
            completion(result)
        }
    }
    
    func getKakaoMemberInfo(with kakaoToken: String, completion: @escaping(KakaoMemberDomain)->Void) {
        let path = "/SendNow/getKakaoMemberInfo?kakaoToken=\(kakaoToken)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: KakaoMemberReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getKakaoMemberInfo ERROR: \(error)")
            }
        }
    }
    
    func getAppleMemberInfo(with appleToken: String, completion: @escaping(AppleMemberDomain)->Void) {
        let path = "/SendNow/getAppleMemberInfo?appleToken=\(appleToken)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: AppleMemberResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getAppleMemberInfo ERROR: \(error)")
            }
        }
    }
    
    func getEmailMemberInfo(with email: String, completion: @escaping(EmailMemberDomain)->Void) {
        let path = "/SendNow/getEmailMemberInfo?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: EmailMemberResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getEmailMemberInfo ERROR: \(error)")
            }
        }
    }
    
    func getSearchID(with searchID: String, completion: @escaping(String)->Void) {
        let path = "/SendNow/getSearchID?searchID=\(searchID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: KakaoMemberReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.searchID ?? "")
                
            case .failure(let error):
                print("getSearchID ERROR: \(error)")
            }
        }
    }
    
    func getEmailAuthCode(with email: String, completion: @escaping(EmailAuthCodeDomain)->Void) {
        let path = "/SendNow/checkEmailDuplicate?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: EmailAuthCodeResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getEmailAuthCode ERROR: \(error)")
            }
        }
    }
}
