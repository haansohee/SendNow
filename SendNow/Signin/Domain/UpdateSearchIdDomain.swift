//
//  UpdateSearchIdDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation

struct UpdateSearchIdDomain {
    let searchID: String
    let email: String
    let token: String
}

extension UpdateSearchIdDomain {
    func toRequestDTO() -> UpdateSearchIdRequestDTO {
        return .init(searchID: searchID, email: email, token: token)
    }
}
