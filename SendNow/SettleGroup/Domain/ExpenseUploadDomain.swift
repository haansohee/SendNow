//
//  ExpenseUploadDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseUploadDomain {
    let groupID: Int
    let userID: Int
    let expenseClassfication: String
    let expenseDetail: String
    let expenseAmount: Int
    let expenseDate: String
    let remainderUserID: Int
}

extension ExpenseUploadDomain {
    func toRequestDTO() -> ExpenseUploadRequestDTO {
        return .init(groupID: groupID, userID: userID, expenseClassfication: expenseClassfication, expenseDetail: expenseDetail, expenseAmount: expenseAmount, expenseDate: expenseDate, remainderUserID: remainderUserID)
    }
}
