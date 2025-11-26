//
//  EmailMemberResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation

struct EmailMemberResponseDTO: Codable {
    let userID: Int?
    let nickname: String?
    let email: String?
    let password: String?
    let kakaoPayUrl: String?
    let isDismissed: Bool
    let summaryReceived: String?
    let summarySent: String?
    let summaryUnsettled: Int?
}

extension EmailMemberResponseDTO {
    func toDomain() -> EmailMemberDomain {
        return .init(
            userID: userID,
            nickname: nickname,
            email: email,
            password: password,
            kakaoPayUrl: kakaoPayUrl,
            isDismissed: isDismissed,
            summaryReceived: summaryReceived,
            summarySent: summarySent,
            summaryUnsettled: summaryUnsettled
        )
    }
}
