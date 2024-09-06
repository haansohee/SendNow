//
//  SigninWithKakaoDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation

struct SigninWithKakaoDomain {
    let nickname: String
    let email: String
    let kakaoToken: String
    let kakaoID: Int64
    let isSetNoti: Bool
    let fcmToken: String
}

extension SigninWithKakaoDomain {
    func toRequestDTO() -> SigninWithKakaoRequestDTO {
        return .init(nickname: nickname, email: email, kakaoToken: kakaoToken, kakaoID: kakaoID, isSetNoti: isSetNoti, fcmToken: fcmToken)
    }
}
