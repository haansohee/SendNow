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
    let kakaoPayURL: String?
}

struct SettlementBalanlceResponseDTO: Codable {
    let userID: Int
    let nickname: String
    let sendAmount: String?
    let receiveAmount: String?
}

extension SettlementDetailsResponseDTO {
    func toDomain() -> SettlementDetails {
        return .init(
            settlementID: settlementID,
            groupID: groupID,
            fromUserID: fromUserID,
            toUserID: toUserID,
            fromNickname: fromNickname,
            toNickname: toNickname,
            amount: amount,
            kakaoPayURL: kakaoPayURL
        )
    }
}

extension SettlementBalanlceResponseDTO {
    func toDomain() -> SettlementBalance {
        return .init(
            userID: userID,
            nickname: nickname,
            sendAmount: sendAmount,
            receiveAmount: receiveAmount
        )
    }
}

extension SettlementListReponseDTO {
    func toDomain() -> SettlementList {
        return .init(
            settlementDetails: settlementDetails.map { $0.toDomain() },
            settlementBalance: settlementBalance.map { $0.toDomain() }
        )
    }
}
