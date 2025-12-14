//
//  AppleMemberResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct AppleMemberResponseDTO: Codable {
    let userID: Int?
    let nickname: String?
    let email: String?
    let appleToken: String?
    let kakaoPayUrl: String?
    let isDismissed: Bool
    let summaryReceived: String?
    let summarySent: String?
    let summaryUnsettled: Int?
}

extension AppleMemberResponseDTO {
    func toDomain() -> AppleMember {
        return .init(
            userID: userID,
            nickname: nickname,
            email: email,
            appleToken: appleToken,
            kakaoPayUrl: kakaoPayUrl,
            isDismissed: isDismissed,
            summaryReceived: summaryReceived,
            summarySent: summarySent,
            summaryUnsettled: summaryUnsettled
        )
    }
}
