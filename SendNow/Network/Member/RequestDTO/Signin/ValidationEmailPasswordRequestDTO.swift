//
//  ValidationEmailPasswordRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 9/11/24.
//

import Foundation

struct ValidationEmailPasswordRequestDTO: Codable {
    let email: String
    let password: String
}
