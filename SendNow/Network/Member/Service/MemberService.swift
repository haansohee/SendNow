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
    case updateFcmToken = "/SendNow/UpdateMemerFcmToken/"
    case updateNickname = "/SendNow/updateNickname/"
    case updateMemberNickname = "/SendNow/UpdateMemberNickname/"
    case updateKakaoPayUrl = "/SendNow/UpdateMemberKakaoPayUrl/"
    case updateKakaoPayUrlDismissed = "/SendNow/UpdateKakaoPayUrlDismissed/"
    case revokeAppleToken = "/SendNow/RevokeAppleToken"
    case cancelAccount = "/SendNow/CancelAccount"
    case getKakaoMemberInfo = "/SendNow/getKakaoMemberInfo"
    case getAppleMemberInfo = "/SendNow/getAppleMemberInfo"
    case getEmailMemberInfo = "/SendNow/getEmailMemberInfo"
    case getEmailAuthCode = "/SendNow/checkEmailDuplicate"
}

final class MemberService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setKakaoMemberInfo(with signinWithKakaoRequestDTO: SigninWithKakaoRequestDTO, completion: @escaping((Bool, Int)) -> Void) {
        let path = MemberAPIPath.setKakaoMemberInfo.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: signinWithKakaoRequestDTO, completion: completion)
    }
    
    func setAppleMemberInfo(with signinWithAppleRequestDTO: SigninWithAppleRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.setAppleMemberInfo.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: signinWithAppleRequestDTO, completion: completion)
    }
    
    func setEmailMemberInfo(with signinWithEmailRequestDTO: SigninWithEmailRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.setEmailMemberInfo.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: signinWithEmailRequestDTO, completion: completion)
    }
    
    func updateMemberFcmToken(with udpateFcmTokenInformationRequestDTO: UpdateFcmTokenInformationRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.updateFcmToken.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: udpateFcmTokenInformationRequestDTO, completion: completion)
    }
    
    func updateNickname(with updateNicknameRequestDTO: UpdateNicknameRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.updateMemberNickname.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateNicknameRequestDTO, completion: completion)
    }
    
    func updateKakaoPayUrl(with updateKakaoPayUrlRequestDTO: UpdateKakaoPayUrlRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.updateKakaoPayUrl.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateKakaoPayUrlRequestDTO, completion: completion)
    }
    
    func updateKakaoPayUrlDismissed(with updateKakaoPayUrlDismissedRequestDTO: UpdateKakaoPayDismissedRequestDTO, completion: @escaping(Bool, Int) -> Void) {
        let path = MemberAPIPath.updateKakaoPayUrlDismissed.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateKakaoPayUrlDismissedRequestDTO, completion: completion)
    }
    
    func revokeAppleToken(with cancelAccount: CancelAccountRequestDTO, completion: @escaping((Bool, Int))->Void) {
        let path = MemberAPIPath.revokeAppleToken.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: cancelAccount, completion: completion)
    }
    
    func cancelAccount(with cancelAccount: CancelAccountRequestDTO, completion: @escaping(Bool)->Void) {
        let path = MemberAPIPath.cancelAccount.rawValue
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: cancelAccount, completion: completion)
    }
    
    func getKakaoMemberInfo(with kakaoToken: String, completion: @escaping(Result<KakaoMemberDomain, Error>)->Void) {
        let path = "\(MemberAPIPath.getKakaoMemberInfo.rawValue)?kakaoToken=(\(kakaoToken)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: KakaoMemberReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let kakaoMemberInfoDomain = responseDTO.toDomain()
                completion(.success(kakaoMemberInfoDomain))
            case .failure(let error):
                print("getKakaoMemberInfo ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getAppleMemberInfo(with appleToken: String, completion: @escaping(Result<AppleMemberDomain, Error>)->Void) {
        let path = "\(MemberAPIPath.getAppleMemberInfo.rawValue)?appleToken=\(appleToken)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: AppleMemberResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let appleMemberInfoDomain = responseDTO.toDomain()
                completion(.success(appleMemberInfoDomain))
                
            case .failure(let error):
                print("getAppleMemberInfo ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getEmailMemberInfo(with email: String, completion: @escaping(Result<EmailMemberDomain, Error>)->Void) {
        let path = "\(MemberAPIPath.getEmailMemberInfo.rawValue)?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: EmailMemberResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let emailMemberInfoDomain = responseDTO.toDomain()
                completion(.success(emailMemberInfoDomain))
                
            case .failure(let error):
                print("getEmailMemberInfo ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func isValidEmailPassword(with validationInfo: ValidationEmailPasswordRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = MemberAPIPath.isValidEmailPassword.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: validationInfo, completion: completion)
    }
    
    func isDuplicatedNickname(with nickname: UpdateNicknameRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = MemberAPIPath.isDuplicatedNickname.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: nickname, completion: completion)
    }
    
    func getEmailAuthCode(with email: String, completion: @escaping(Result<EmailAuthCodeResponseDTO, Error>)->Void) {
        let path = "\(MemberAPIPath.getEmailAuthCode.rawValue)?email=\(email)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: EmailAuthCodeResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let emailAuthCodeDomain = responseDTO.toDomain()
                completion(.success(emailAuthCodeDomain))
                
            case .failure(let error):
                print("getEmailAuthCode ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
}
