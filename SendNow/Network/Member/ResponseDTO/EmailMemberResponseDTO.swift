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
    let bankName: String?
    let accountNumber: String?
    let kakaoPayUrl: String?
}
