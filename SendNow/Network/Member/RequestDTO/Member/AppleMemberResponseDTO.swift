//
//  AppleMemberResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct AppleMemberResponseDTO: Codable {
    let userID: Int?
    let searchID: String?
    let nickname: String?
    let email: String?
    let appleToken: String?
    let bankName: String?
    let accountNumber: String?
    let kakaoPayUrl: String?
}

extension AppleMemberResponseDTO {
    func toDomain() -> AppleMemberDomain {
        return .init(userID: userID, searchID: searchID, nickname: nickname, email: email, appleToken: appleToken, bankName: bankName, accountNumber: accountNumber, kakaoPayUrl: kakaoPayUrl)
    }
}
