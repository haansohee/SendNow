//
//  ExpenseInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation

struct ExpenseInformationDomain {
    let expenseInformations: [ExpenseInformationListDomain]?
    let myExpenses: String?
    let groupExpenses: String?
}

struct ExpenseInformationListDomain {
    let expenseID: Int
    let groupID: Int
    let userID: Int
    let paidBy: String
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: String
    let expenseDate: String
}
