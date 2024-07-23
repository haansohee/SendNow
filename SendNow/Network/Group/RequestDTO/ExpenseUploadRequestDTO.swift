//
//  ExpenseUploadRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseUploadRequestDTO: Codable {
    let groupID: Int
    let userID: Int
    let expenseClassfication: String
    let expenseDetail: String
    let expenseAmount: Int
    let expenseDate: String
    let remainderUserID: Int
}
