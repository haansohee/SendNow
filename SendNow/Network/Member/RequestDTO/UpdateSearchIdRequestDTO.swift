//
//  UpdateSearchIdRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import Foundation

struct UpdateSearchIdRequestDTO: Codable {
    let searchID: String
    let email: String
    let token: String
}
