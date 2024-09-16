//
//  SigninWithEmailDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithEmailDomain {
    let nickname: String
    let email: String
    let password: String
    let isSetNoti: Bool
    let fcmToken: String
}

extension SigninWithEmailDomain {
    func toRequestDTO() -> SigninWithEmailRequestDTO {
        return .init(nickname: nickname, email: email, password: password, isSetNoti: isSetNoti, fcmToken: fcmToken)
    }
}
