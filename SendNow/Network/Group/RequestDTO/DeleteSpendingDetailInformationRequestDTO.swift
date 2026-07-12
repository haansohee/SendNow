//
//  DeleteSpendingDetailInformationRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 7/3/25.
//

import Foundation

struct DeleteSpendingDetailInformationRequestDTO: Codable {
    let expenseID: Int
    let groupID: Int
}
