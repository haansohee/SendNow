//
//  SigninWithKakaoRequest.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation

struct SigninWithKakaoRequestDTO: Codable {
    let searchID: String
    let nickname: String
    let email: String
    let kakaoToken: String
    let kakaoID: Int64
}
