//
//  RemittanceStatusDomain.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import Foundation

struct RemittanceStatusDomain {
    let settlementID: Int
    let isCompletedRemittance: Bool
}

extension RemittanceStatusDomain {
    func toRequestDTO() -> RemittanceStatusRequestDTO {
        .init(settlementID: settlementID, isCompletedRemittance: isCompletedRemittance)
    }
}
