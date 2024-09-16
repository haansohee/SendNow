//
//  SigninWithAppleRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithAppleRequestDTO: Codable {
    let nickname: String
    let appleToken: String
    let authorizationCode: String
    let isSetNoti: Bool
    let fcmToken: String
}
