//
//  KakaoMemberReponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/2/24.
//

import Foundation

struct KakaoMemberReponseDTO: Codable {
    let userID: Int?
    let nickname: String?
    let email: String?
    let kakaoToken: String?
    let kakaoID: Int64?
    let kakaoPayUrl: String?
    let isDismissed: Bool
}

extension KakaoMemberReponseDTO {
    func toDomain() -> KakaoMemberDomain {
        return .init(
            userID: userID,
            nickname: nickname,
            email: email,
            kakaoToken: kakaoToken,
            kakaoID: kakaoID,
            kakaoPayUrl: kakaoPayUrl,
            isDismissed: isDismissed
        )
    }
}
