//
//  FriendService.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation

final class FriendService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setFriendRequest(with friendRequestSendDomain: FriendRequestSendDomain, completion: @escaping(Bool)->Void) {
        let path = "/SendNow/setFriendRequestList/"
        let friendRequestSend = friendRequestSendDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: friendRequestSend) { result in
            completion(result)
        }
    }
    
    func updateFriendState(with updateFriendStateDomain: UpdateFriendStateDomain, completion: @escaping(Bool)->Void) {
        let path = "/SendNow/updateFriendState/"
        let updateFriendStateInfo = updateFriendStateDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: updateFriendStateInfo) { result in
            completion(result)
        }
        
    }
    
    func deleteFriendRequestList(with deleteFriendRequestDomain: DeleteFriendRequestDomain, completion: @escaping(Bool)->Void) {
        let path = "/SendNow/deleteFriendRequestList/"
        let deleteFriendRequestInfo = deleteFriendRequestDomain.toRequestDTO()
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: deleteFriendRequestInfo) { result in
            completion(result)
        }
    }
    
    func getFriendInformation(with friendSearchId: String, completion: @escaping(SearchFriendDomain)->Void) {
        let path = "/SendNow/getFriendInfo?searchID=\(friendSearchId)"
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
        let path = "/SendNow/getFriendRequestListInfo?userID=\(userID)"
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
        let path = "/SendNow/getMyFriendList?userID=\(userID)"
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
