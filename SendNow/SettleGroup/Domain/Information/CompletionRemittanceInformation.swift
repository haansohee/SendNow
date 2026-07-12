//
//  CompletionRemittanceInformation.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import Foundation

struct CompletionRemittanceInformation {
    let settlementID: Int
    let receiverNickname: String
    let amount: Int
    let isCompletedRemittance: Bool
}
