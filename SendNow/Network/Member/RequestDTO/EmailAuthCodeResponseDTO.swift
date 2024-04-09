//
//  EmailAuthCodeResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct EmailAuthCodeResponseDTO: Codable {
    let isDuplicated: Bool
    let authCode: Int?
}

extension EmailAuthCodeResponseDTO {
    func toDomain() -> EmailAuthCodeDomain {
        return .init(isDuplicated: isDuplicated, authCode: authCode)
    }
}
