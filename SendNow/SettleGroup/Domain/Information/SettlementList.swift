//
//  SettlementList.swift
//  SendNow
//
//  Created by 한소희 on 5/28/24.
//

import Foundation

struct SettlementList {
    let settlementDetails: [SettlementDetails]
    let settlementBalance: [SettlementBalance]
}

struct SettlementDetails {
    let settlementID: Int
    let groupID: Int
    let fromUserID: Int
    let toUserID: Int
    let fromNickname: String
    let toNickname: String
    let amount: String
    let kakaoPayURL: String?
}

struct SettlementBalance {
    let userID: Int
    let nickname: String
    let sendAmount: String?
    let receiveAmount: String?
}
