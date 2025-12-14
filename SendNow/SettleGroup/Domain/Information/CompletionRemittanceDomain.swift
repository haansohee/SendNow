//
//  CompletionRemittanceDomain.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import Foundation

struct CompletionRemittanceDomain {
    let settlementID: Int
    let receiverNickname: String
    let amount: Int
    let isCompletedRemittance: Bool
}
