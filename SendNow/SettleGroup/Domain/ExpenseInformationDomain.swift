//
//  ExpenseInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseInformationDomain {
    let expenseInformations: [ExpenseInformations]?
    let myExpenses: Int?
    let groupExpenses: Int?
}

struct ExpenseInformations {
    let expenseID: Int
    let groupID: Int
    let userID: Int
    let paidBy: String
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: Int
    let expenseDate: String
}
