//
//  ExpenseInformationResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseInformationResponseDTO: Codable {
    let expenseInformations: [ExpenseInformationsResponseDTO]
    let myExpenses: Int?
    let groupExpenses: Int?
}

struct ExpenseInformationsResponseDTO: Codable {
    let expenseID: Int
    let groupID: Int
    let userID: Int
    let paidBy: String
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: Int
    let expenseDate: String
}

extension ExpenseInformationResponseDTO {
    func toDomain() -> ExpenseInformationDomain {
        return .init(expenseInformations: expenseInformations.map {$0.toDomain()}, myExpenses: myExpenses, groupExpenses: groupExpenses)
    }
}

extension ExpenseInformationsResponseDTO {
    func toDomain() -> ExpenseInformations {
        return .init(expenseID: expenseID, groupID: groupID, userID: userID, paidBy: paidBy, expenseClassfication: expenseClassfication, expenseDetails: expenseDetails, expenseAmount: expenseAmount, expenseDate: expenseDate)
    }
}
