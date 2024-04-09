//
//  SigninWithKakaoDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation

struct SigninWithKakaoDomain {
    let searchID: String
    let nickname: String
    let email: String
    let kakaoToken: String
}

extension SigninWithKakaoDomain {
    func toRequestDTO() -> SigninWithKakaoRequestDTO {
        return .init(searchID: searchID, nickname: nickname, email: email, kakaoToken: kakaoToken)
    }
}
