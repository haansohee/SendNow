//
//  ValidationEmailPasswordDomain.swift
//  SendNow
//
//  Created by 한소희 on 9/11/24.
//

import Foundation

struct ValidationEmailPasswordDomain {
    let email: String
    let password: String
}

extension ValidationEmailPasswordDomain {
    func toRequestDTO() -> ValidationEmailPasswordRequestDTO {
        return .init(email: email, password: password)
    }
}
