//
//  UpdateKakaoPayUrlRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation

struct UpdateKakaoPayUrlRequestDTO: Codable {
    let userID: Int
    let kakaoPayUrl: String
}
