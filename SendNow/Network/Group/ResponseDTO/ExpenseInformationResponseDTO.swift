//
//  ExpenseInformationResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseInformationResponseDTO: Codable {
    let expenseInformations: [ExpenseInformationListResponseDTO]
    let myExpenses: String?
    let groupExpenses: String?
}

struct ExpenseInformationListResponseDTO: Codable {
    let expenseID: Int
    let groupID: Int
    let userID: Int
    let paidBy: String
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: String
    let expenseDate: String
}

extension ExpenseInformationListResponseDTO {
    func toDomain() -> ExpenseInformationList {
        return .init(
            expenseID: expenseID,
            groupID: groupID,
            userID: userID,
            paidBy: paidBy,
            expenseClassfication: expenseClassfication,
            expenseDetails: expenseDetails,
            expenseAmount: expenseAmount,
            expenseDate: expenseDate
        )
    }
}

extension ExpenseInformationResponseDTO {
    func toDomain() -> ExpenseInformation {
        return .init(
            expenseInformations: expenseInformations.map { $0.toDomain()},
            myExpenses: myExpenses,
            groupExpenses: groupExpenses
        )
    }
}
