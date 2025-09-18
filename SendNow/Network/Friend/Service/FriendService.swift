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
    
    func setFriendRequest(with friendAddRequestDTO: FriendAddRequestDTO, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.setFriendRequestList.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: friendAddRequestDTO, completion: completion)
    }
    
    func updateFriendState(with updateFriendStateRequestDTO: UpdateFriendStateRequestDTO, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.updateFriendState.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateFriendStateRequestDTO, completion: completion)
        
    }
    
    func deleteFriendRequestList(with deleteFriendRequestDTO: DeleteFriendRequestDTO, completion: @escaping(Bool)->Void) {
        let path = FriendAPIPath.deleteFriendRequestList.rawValue
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: deleteFriendRequestDTO, completion: completion)
    }
    
    func getFriendInformation(with nickname: String, completion: @escaping(Result<SearchFriendDomain, Error>)->Void) {
        let path = "\(FriendAPIPath.getFriendInformation.rawValue)?nickname=\(nickname)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SearchFriendResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let searchFriendInfoDomain = responseDTO.toDomain()
                completion(.success(searchFriendInfoDomain))
                
            case .failure(let error):
                print("getFriendInformation ERROR: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getFriendRequestListInformation(with userID: Int, completion: @escaping(Result<[FriendRequestListDomain], Error>)->Void) {
        let path = "\(FriendAPIPath.getFriendRequestListInformation.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [FriendRequestListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let friendRequestListDomain = responseDTO.map { $0.toDomain() }
                completion(.success(friendRequestListDomain))
            case .failure(let error):
                print("get Friend Request List Info ERROR : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getMyFriendList(with userID: Int, completion: @escaping(Result<[MyFriendListDomain], Error>)->Void) {
        let path = "\(FriendAPIPath.getMyFriendList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [MyFriendListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let myFriendListDomain = responseDTO.map { $0.toDomain() }
                completion(.success(myFriendListDomain))
            case .failure(let error):
                print("get My Friend List Info Error : \(error)")
                completion(.failure(error))
            }
        }
    }
}
