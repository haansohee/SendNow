//
//  UpdateAccountNumberRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateAccountNumberRequestDTO: Codable {
    let userID: Int
    let bankName: String
    let accountNumber: String
}
