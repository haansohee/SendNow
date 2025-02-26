//
//  UpdateBankInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 2/26/25.
//

import Foundation

struct UpdateBankInformationDomain {
    let userID: Int
    let kakaoPayURL: String
    let bankName: String
    let accountNumber: String
}

extension UpdateBankInformationDomain {
    func toRequestDTO() -> UpdateBankInformationRequestDTO {
        return .init(userID: userID, kakaoPayURL: kakaoPayURL, bankName: bankName, accountNumber: accountNumber)
    }
}
