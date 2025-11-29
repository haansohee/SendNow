//
//  EmailMemberDomain.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation

struct EmailMemberDomain {
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
