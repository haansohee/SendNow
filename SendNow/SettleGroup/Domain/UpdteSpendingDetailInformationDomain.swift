//
//  UpdteSpendingDetailInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 6/11/25.
//

import Foundation

struct UpdateSpendingDetailInformationDomain {
    let groupID: Int
    let expenseID: Int
    let expenseClassfication: String
    let expenseDetails: String
    let expenseAmount: Int
    let expenseDate: String
}

extension UpdateSpendingDetailInformationDomain {
    func toReqeustDTO() -> UpdateSpendingDetailInformationRequestDTO {
        return .init(groupID: groupID, expenseID: expenseID, expenseClassfication: expenseClassfication, expenseDetails: expenseDetails, expenseAmount: expenseAmount, expenseDate: expenseDate)
    }
}
