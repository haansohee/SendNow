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
    case isValidEmailPassword = "/SendNow/isValidEmailPassword/"
    case isDuplicatedNickname = "/SendNow/isDuplicatedNickname"
    case updateNickname = "/SendNow/updateNickname/"
    case updateMemberNickname = "/SendNow/UpdateMemberNickname/"
    case updateKakaoPayUrl = "/SendNow/UpdateMemberKakaoPayUrl/"
    case updateMemberAccountNumber = "/SendNow/UpdateMemberAccountNumber/"
    case revokeAppleToken = "/SendNow/RevokeAppleToken"
    case cancelAccount = "/SendNow/CancelAccount"
    case getKakaoMemberInfo = "/SendNow/getKakaoMemberInfo"
    case getAppleMemberInfo = "/SendNow/getAppleMemberInfo"
    case getEmailMemberInfo = "/SendNow/getEmailMemberInfo"
    case getEmailAuthCode = "/SendNow/checkEmailDuplicate"
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
    
    func revokeAppleToken(with cancelAccount: CancelAccountDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.revokeAppleToken.rawValue
        let cancelAccountRequestDTO = cancelAccount.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: cancelAccountRequestDTO, completion: completion)
    }
    
    func cancelAccount(with cancelAccount: CancelAccountDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.cancelAccount.rawValue
        let cancelAccountRequestDTO = cancelAccount.toRequestDTO()
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: cancelAccountRequestDTO, completion: completion)
    }
    
    func getKakaoMemberInfo(with kakaoToken: String, completion: @escaping(KakaoMemberDomain)->Void) {
        let path = "\(MemberAPIPath.getKakaoMemberInfo.rawValue)?kakaoToken=(\(kakaoToken)"
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
        let path = "\(MemberAPIPath.getAppleMemberInfo.rawValue)?applToken=\(appleToken)"
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
        let path = "\(MemberAPIPath.getEmailMemberInfo.rawValue)?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: EmailMemberResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getEmailMemberInfo ERROR: \(error)")
            }
        }
    }
    
    func isValidEmailPassword(with validationInfo: ValidationEmailPasswordDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.isValidEmailPassword.rawValue
        let validationInfo = validationInfo.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: validationInfo, completion: completion)
    }
    
    func isDuplicatedNickname(with nickname: UpdateNicknameDomain, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.isDuplicatedNickname.rawValue
        let nicknameInfo = nickname.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: nicknameInfo   , completion: completion)
    }
    
    func getEmailAuthCode(with email: String, completion: @escaping(EmailAuthCodeDomain)->Void) {
        let path = "\(MemberAPIPath.getEmailAuthCode.rawValue)?email=\(email)"
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
