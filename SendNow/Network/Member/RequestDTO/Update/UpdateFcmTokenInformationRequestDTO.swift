//
//  UpdateFcmTokenInformationRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 7/14/25.
//

import Foundation

struct UpdateFcmTokenInformationRequestDTO: Codable {
    let userID: Int
    let fcmToken: String
}
