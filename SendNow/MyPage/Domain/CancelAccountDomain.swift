//
//  CancelAccountDomain.swift
//  SendNow
//
//  Created by 한소희 on 9/9/24.
//

import Foundation

struct CancelAccountDomain {
    let userID: Int
}

extension CancelAccountDomain {
    func toRequestDTO() -> CancelAccountRequestDTO {
        return .init(userID: userID)
    }
}
