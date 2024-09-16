//
//  SigninWithAppleDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithAppleDomain {
    let nickname: String
    let appleToken: String
    let authorizationCode: String
    let isSetNoti: Bool
    let fcmToken: String
}

extension SigninWithAppleDomain {
    func toRequestDTO() -> SigninWithAppleRequestDTO {
        return .init(nickname: nickname, appleToken: appleToken, authorizationCode: authorizationCode, isSetNoti: isSetNoti, fcmToken: fcmToken)
    }
}

