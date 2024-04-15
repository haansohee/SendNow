//
//  EmailMemberResponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation

struct EmailMemberResponseDTO: Codable {
    let userID: Int?
    let searchID: String?
    let nickname: String?
    let email: String?
    let password: String?
}

extension EmailMemberResponseDTO {
    func toDomain() -> EmailMemberDomain {
        return .init(userID: userID, searchID: searchID, nickname: nickname, email: email, password: password)
    }
}
