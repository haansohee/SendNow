//
//  DeleteSpendingDetailInformationDomain.swift
//  SendNow
//
//  Created by 한소희 on 7/3/25.
//

import Foundation

struct DeleteSpendingDetailInformationDomain {
    let expenseID: Int
    let groupID: Int
}

extension DeleteSpendingDetailInformationDomain {
    func toRequestDTO() -> DeleteSpendingDetailInformationRequestDTO {
        return .init(expenseID: expenseID, groupID: groupID)
    }
}
