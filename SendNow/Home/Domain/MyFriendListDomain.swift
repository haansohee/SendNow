//
//  MyFriendListDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct MyFriendListDomain: Equatable {
    let userID: Int
    let searchID: String
    let nickname: String
    let bankName: String?
    let accountNumber: String?
    let kakaoPayUrl: String?
}
