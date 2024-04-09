//
//  SigninWithEmailDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithEmailDomain {
    let searchID: String
    let nickname: String
    let email: String
    let password: String
}

extension SigninWithEmailDomain {
    func toRequestDTO() -> SigninWithEmailRequestDTO {
        return .init(searchID: searchID, nickname: nickname, email: email, password: password)
    }
}
