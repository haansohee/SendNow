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
}
