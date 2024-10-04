//
//  CompletionRemittanceResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import Foundation

struct CompletionRemittanceResponseDTO: Codable {
    let settlementID: Int
    let receiverNickname: String
    let amount: Int
    let isCompletedRemittance: Bool
}

extension CompletionRemittanceResponseDTO {
    func toDomain() -> CompletionRemittanceDomain {
        return .init(settlementID: settlementID, receiverNickname: receiverNickname, amount: amount, isCompletedRemittance: isCompletedRemittance)
    }
}
