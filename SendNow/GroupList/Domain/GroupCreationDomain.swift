//
//  GroupCreationDomain.swift
//  SendNow
//
//  Created by 한소희 on 5/20/24.
//

import Foundation

struct GroupCreationDomain {
    let groupName: String
    let userIDList: [Int]
    let creatorID: Int
    let remainderUserID: Int
}

