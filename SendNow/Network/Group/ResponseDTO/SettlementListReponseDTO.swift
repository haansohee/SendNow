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
    let amount: Int
    let bankName: String?
    let accountNumber: String?
    let kakaoPayURL: String?
}

struct SettlementBalanlceResponseDTO: Codable {
    let userID: Int
    let nickname: String
    let sendAmount: Int?
    let receiveAmount: Int?
}

extension SettlementBalanlceResponseDTO {
    func toDomain() -> SettlementBalanceDomain {
        return .init(userID: userID, nickname: nickname, sendAmount: sendAmount, receiveAmount: receiveAmount)
    }
}

extension SettlementDetailsResponseDTO {
    func toDomain() -> SettlementDetailsDomain {
        return .init(settlementID: settlementID, groupID: groupID
                     , fromUserID: fromUserID, toUserID: toUserID, fromNickname: fromNickname, toNickname: toNickname, amount: amount, bankName: bankName, accountNumber: accountNumber, kakaoPayURL: kakaoPayURL)
    }
}

extension SettlementListReponseDTO {
    func toDomain() -> SettlementListDomain {
        return .init(settlementDetails: settlementDetails.map{$0.toDomain()}, settlementBalance: settlementBalance.map{$0.toDomain()})
    }
}
