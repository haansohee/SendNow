//
//  SigninWithAppleRequestDTO.swift
//  SendNow
//
//  Created by 한소희 on 4/8/24.
//

import Foundation

struct SigninWithAppleRequestDTO: Codable {
    let searchID: String
    let nickname: String
    let email: String
    let appleToken: String
}
