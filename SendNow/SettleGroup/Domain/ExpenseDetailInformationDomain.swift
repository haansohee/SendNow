//
//  ExpenseDetailInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 3/5/25.
//

import Foundation

struct ExpenseDetailInformationDomain {
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
