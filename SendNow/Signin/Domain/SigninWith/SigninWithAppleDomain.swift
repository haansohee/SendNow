//
//  SigninWithAppleDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithAppleDomain {
    let searchID: String
    let nickname: String
    let email: String
    let appleToken: String
}

extension SigninWithAppleDomain {
    func toRequestDTO() -> SigninWithAppleRequestDTO {
        return .init(searchID: searchID, nickname: nickname, email: email, appleToken: appleToken)
    }
}

