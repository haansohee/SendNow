//
//  UpdateAccountNumberDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateAccountNumberDomain {
    let userID: Int
    let bankName: String
    let accountNumber: String
}

extension UpdateAccountNumberDomain {
    func toRequestDTO() -> UpdateAccountNumberRequestDTO {
        return .init(userID: userID, bankName: bankName, accountNumber: accountNumber)
    }
}
