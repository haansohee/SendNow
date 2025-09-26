//
//  UpdateKakaoPayDismissedRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 9/23/25.
//

import Foundation

struct UpdateKakaoPayDismissedRequestDTO: Codable {
    let userID: Int
    let isDismissed: Bool
}
