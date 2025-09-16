//
//  SettlementListReponseDTO.swift
//  SendNow
//
//  Created by 한소희 on 5/28/24.
//

import Foundation

struct SettlementListReponseDTO: Codable {
    let settlementDetails: [SettlementDetailsResponseDTO]
    let settlementBalance: [SettlementBalanlceResponseDTO]
}

struct SettlementDetailsResponseDTO: Codable {
    let settlementID: Int
    let groupID: Int
    let fromUserID: Int
    let toUserID: Int
    let fromNickname: String
    let toNickname: String
    let amount: String
    let bankName: String?
    let accountNumber: String?
    let kakaoPayURL: String?
}

struct SettlementBalanlceResponseDTO: Codable {
    let userID: Int
    let nickname: String
    let sendAmount: String?
    let receiveAmount: String?
}
