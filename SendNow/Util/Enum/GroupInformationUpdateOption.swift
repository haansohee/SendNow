//
//  GroupInformationUpdateOption.swift
//  SendNow
//
//  Created by 한소희 on 12/3/25.
//

import Foundation

enum GroupInformationUpdateOption {
    case management(nickname: String, userID: Int)
    case remainder(nickname: String, userID: Int)
    case groupName(newName: String)
    
    var message: String {
        switch self {
        case .management(let nickname, _):
            return "\(nickname) 님을 관리자로 설정할까요?"
            
        case .remainder(let nickname, _):
            return "나머지 정산 금액을 지불할 사용자를 \(nickname) 님으로 설정할까요?"
            
        case .groupName(let newName):
            return "그룹 이름을 '\(newName)'(으)로 설정할까요?"
        }
    }
}
