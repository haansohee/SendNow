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
    let expenseAmount: String
    let expenseDate: String
}

extension ExpenseDetailInformationReponseDTO {
    func toDomain() -> ExpenseDetailInformation {
        return .init(
            expenseID: expenseID,
            groupID: groupID,
            paidBy: paidBy,
            expenseClassfication: expenseClassfication,
            expenseDetails: expenseDetails,
            expenseAmount: expenseAmount,
            expenseDate: expenseDate
        )
    }
}
