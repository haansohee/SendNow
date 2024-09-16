//
//  SigninWithKakaoRequest.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation

struct SigninWithKakaoRequestDTO: Codable {
    let nickname: String
    let email: String
    let kakaoToken: String
    let kakaoID: Int64
    let isSetNoti: Bool
    let fcmToken: String
}
