//
//  UpdateNotificationStateRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 11/18/24.
//

import Foundation

struct UpdateNotificationStateRequestDTO: Codable {
    let userID: Int
    let state: Bool
}
