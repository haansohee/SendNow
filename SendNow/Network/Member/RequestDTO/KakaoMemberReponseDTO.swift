//
//  KakaoMemberReponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/2/24.
//

import Foundation

struct KakaoMemberReponseDTO: Codable {
    let searchID: String?
    let nickname: String?
    let email: String?
    let kakaoToken: String?
}

extension KakaoMemberReponseDTO {
    func toDomain() -> KakaoMemberDomain {
        return .init(searchID: searchID, nickname: nickname, email: email, kakaoToken: kakaoToken)
    }
}
