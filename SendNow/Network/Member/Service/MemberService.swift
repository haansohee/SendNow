//
//  MemberService.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import KakaoSDKAuth

enum MemberAPIPath: String {
    case setKakaoMemberInfo = "/SendNow/setKakaoMemberInfo/"
    case setAppleMemberInfo = "/SendNow/setAppleMemberInfo/"
    case setEmailMemberInfo = "/SendNow/setEmailMemberInfo/"
    case updateSNSUserSearchID = "/SendNow/updateSNSUserSearchID/"
    case updateEmailUserSearchID = "/SendNow/updateEmailUserSearchID/"
    case updateMemberNickname = "/SendNow/UpdateMemberNickname/"
    case updateKakaoPayUrl = "/SendNow/UpdateMemberKakaoPayUrl/"
    case updateMemberAccountNumber = "/SendNow/UpdateMemberAccountNumber/"
    case getKakaoMemberInfo = "/SendNow/getKakaoMemberInfo?kakaoToken="
    case getAppleMemberInfo = "/SendNow/getAppleMemberInfo?appleToken="
    case getEmailMemberInfo = "/SendNow/getEmailMemberInfo?email="
    case getSearchID = "/SendNow/getSearchID?searchID="
    case getEmailAuthCode = "/SendNow/checkEmailDuplicate?email="
}

final class MemberService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setKakaoMemberInfo(with signinWithKakaoDomain: SigninWithKakaoDomain, completion: @escaping((Bool)) -> Void) {
        let path = MemberAPIPath.setKakaoMemberInfo.rawValue
        let member = signinWithKakaoDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member, completion: completion)
    }
    
    func setAppleMemberInfo(with signinWithAppleDomain: SigninWithAppleDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.setAppleMemberInfo.rawValue
        let member = signinWithAppleDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member, completion: completion)
    }
    
    func setEmailMemberInfo(with signinWithEmailDomain: SigninWithEmailDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.setEmailMemberInfo.rawValue
        let member = signinWithEmailDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: member, completion: completion)
    }
    
    func updateSearchID(with updateSearchIdDomain: UpdateSearchIdDomain, completion: @escaping(Bool)->Void) {
        let path = updateSearchIdDomain.email.isEmpty ? MemberAPIPath.updateSNSUserSearchID.rawValue : MemberAPIPath.updateEmailUserSearchID.rawValue
        let updateSearchID = updateSearchIdDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateSearchID, completion: completion)
    }
    
    func updateNickname(with updateNicknameDomain: UpdateNicknameDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.updateMemberNickname.rawValue
        let updateNickname = updateNicknameDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateNickname, completion: completion)
    }
    
    func updateKakaoPayUrl(with updateKakaoPayUrlDomain: UpdateKakaoPayUrlDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.updateKakaoPayUrl.rawValue
        let updateKakaoPayUrl = updateKakaoPayUrlDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateKakaoPayUrl, completion: completion)
    }
    
    func updateAccountNumber(with updateAccountNumberDomain: UpdateAccountNumberDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.updateMemberAccountNumber.rawValue
        let updateAccountNumber = updateAccountNumberDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateAccountNumber, completion: completion)
    }
    
    func getKakaoMemberInfo(with kakaoToken: String, completion: @escaping(KakaoMemberDomain)->Void) {
        let path = "\(MemberAPIPath.getKakaoMemberInfo.rawValue)\(kakaoToken)"
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
        let path = "\(MemberAPIPath.getAppleMemberInfo.rawValue)\(appleToken)"
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
        let path = "\(MemberAPIPath.getEmailMemberInfo.rawValue)\(email)"
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
        let path = "\(MemberAPIPath.getSearchID.rawValue)\(searchID)"
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
        let path = "\(MemberAPIPath.getEmailAuthCode.rawValue)\(email)"
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
