//
//  FriendService.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation
import UIKit

enum FriendAPIPath: String {
    case setFriendRequestList = "/SendNow/setFriendRequestList/"
    case updateFriendState = "/SendNow/updateFriendState/"
    case deleteFriendRequestList = "/SendNow/deleteFriendRequestList/"
    case getFriendInformation = "/SendNow/getFriendInfo"
    case getFriendRequestListInformation = "/SendNow/getFriendRequestListInfo"
    case getMyFriendList = "/SendNow/getMyFriendList"
}

final class FriendService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setFriendRequest(with friendRequestSendDomain: FriendRequestSendDomain, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.setFriendRequestList.rawValue
        let friendRequestSend = friendRequestSendDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: friendRequestSend, completion: completion)
    }
    
    func updateFriendState(with updateFriendStateDomain: UpdateFriendStateDomain, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.updateFriendState.rawValue
        let updateFriendStateInfo = updateFriendStateDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateFriendStateInfo, completion: completion)
        
    }
    
    func deleteFriendRequestList(with deleteFriendRequestDomain: DeleteFriendRequestDomain, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.deleteFriendRequestList.rawValue
        let deleteFriendRequestInfo = deleteFriendRequestDomain.toRequestDTO()
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: deleteFriendRequestInfo, completion: completion)
    }
    
    func getFriendInformation(with nickname: String, completion: @escaping(SearchFriendDomain)->Void) {
        let path = "\(FriendAPIPath.getFriendInformation.rawValue)?nickname=\(nickname)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SearchFriendResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
                
            case .failure(let error):
                print("getFriendInformation ERROR: \(error)")
            }
        }
    }
    
    func getFriendRequestListInformation(with userID: Int, completion: @escaping([FriendRequestListDomain])->Void) {
        let path = "\(FriendAPIPath.getFriendRequestListInformation.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [FriendRequestListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let friendRequestListInfo = responseDTO.map { $0.toDomain() }
                completion(friendRequestListInfo)
            case .failure(let error):
                print("get Friend Request List Info ERROR : \(error)")
            }
        }
    }
    
    func getMyFriendList(with userID: Int, completion: @escaping([MyFriendListDomain])->Void) {
        let path = "\(FriendAPIPath.getMyFriendList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [MyFriendListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let myFriendList = responseDTO.map { $0.toDomain() }
                completion(myFriendList)
            case .failure(let error):
                print("get My Friend List Info Error : \(error)")
            }
        }
    }
}
