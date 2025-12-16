//
//  MyFriendList.swift
//  SendNow
//
//  Created by 한소희 on 5/7/24.
//

import Foundation

struct MyFriendList: Equatable, Error {
    let userID: Int
    let nickname: String
    let kakaoPayUrl: String?
}
