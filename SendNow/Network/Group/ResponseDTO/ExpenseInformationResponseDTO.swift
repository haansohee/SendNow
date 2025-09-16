//
//  ExpenseInformationResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseInformationResponseDTO: Codable {
    let expenseInformations: [ExpenseInformationsResponseDTO]
    let myExpenses: String?
    let groupExpenses: String?
}

struct ExpenseInformationsResponseDTO: Codable {
    let expenseID: Int
    let groupID: Int
    let userID: Int
    let paidBy: String
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: String
    let expenseDate: String
}
