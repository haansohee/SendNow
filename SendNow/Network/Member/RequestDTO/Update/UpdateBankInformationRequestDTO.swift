//
//  UpdateBankInformationRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 2/26/25.
//

import Foundation

struct UpdateBankInformationRequestDTO: Codable {
    let userID: Int
    let kakaoPayURL: String
    let bankName: String
    let accountNumber: String
}
