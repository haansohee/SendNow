//
//  SettlementListDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/28/24.
//

import Foundation

struct SettlementListDomain {
    let settlementDetails: [SettlementDetailsDomain]
    let settlementBalance: [SettlementBalanceDomain]
}

struct SettlementDetailsDomain {
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

struct SettlementBalanceDomain {
    let userID: Int
    let nickname: String
    let sendAmount: Int?
    let receiveAmount: Int?
}
