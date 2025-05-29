//
//  ExpenseDetailInformationReponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 3/5/25.
//

import Foundation

struct ExpenseDetailInformationReponseDTO: Codable {
    let expenseID: Int
    let groupID: Int
    let paidBy: Int
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: Int
    let expenseDate: String
    let remainderAmount: Int
    let remainderUserID: Int
}

extension ExpenseDetailInformationReponseDTO {
    func toDomain() -> ExpenseDetailInformationDomain {
        return .init(expenseID: expenseID,
                     groupID: groupID,
                     paidBy: paidBy,
                     expenseClassfication: expenseClassfication,
                     expenseDetails: expenseDetails,
                     expenseAmount: expenseAmount,
                     expenseDate: expenseDate,
                     remainderAmount: remainderAmount,
                     remainderUserID: remainderUserID)
    }
}
