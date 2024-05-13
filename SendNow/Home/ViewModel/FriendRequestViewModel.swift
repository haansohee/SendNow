//
//  FirendRequestViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation
import RxSwift

final class FriendRequestViewModel {
    private let friendService = FriendService()
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    private(set) var searchFriendInformation: SearchFriendDomain?
    private(set) var friendRequestSendListInfo: [FriendRequestListDomain]?
    private(set) var friendRequestReceiveListInfo: [FriendRequestListDomain]?
    let isEmptySearchFriend = PublishSubject<Bool>()
    let isSendedFriendRequest = PublishSubject<Bool>()
    let isLoadedFriendRequestListInfo = PublishSubject<Bool>()
    let isDeletedFriendRequest = PublishSubject<Bool>()
    let isUpdatedFriendRequestState = PublishSubject<Bool>()
    
    func sendFriendRequest(toUserID: Int) {
        guard let fromUserNickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) else {
            return }
        let friendRequestSendInfo = FriendRequestSendDomain(fromUserID: userID, fromUserNickname: fromUserNickname, toUserID: toUserID)
        friendService.setFriendRequest(with: friendRequestSendInfo) {[weak self] result in
            self?.isSendedFriendRequest.onNext(result)
        }
    }
    
    func searchFriendId(friendSearchId: String) {
        friendService.getFriendInformation(with: friendSearchId) {[weak self] result in
            self?.searchFriendInformation = result
            self?.isEmptySearchFriend.onNext(!result.nickname.isEmpty)
        }
    }
    
    func getFriendRequestList() {
        friendService.getFriendRequestListInformation(with: userID) {[weak self] result in
            guard !result.isEmpty else {
                self?.isLoadedFriendRequestListInfo.onNext(false)
                return }
            self?.isLoadedFriendRequestListInfo.onNext(true)
            self?.friendRequestSendListInfo = result.filter { $0.fromUserID == self?.userID }
            self?.friendRequestReceiveListInfo = result.filter { $0.toUserID == self?.userID }
        }
    }
    
    func deleteFriendRequest(toUserID: Int, fromUserID: Int) {
        let friendReuqestDeleteInfo = DeleteFriendRequestDomain(fromUserID: fromUserID, toUserID: toUserID)
        friendService.deleteFriendRequestList(with: friendReuqestDeleteInfo) {[weak self] result in
            self?.isDeletedFriendRequest.onNext(result)
        }
    }
    
    func updateFriendRequestState(toUserID: Int, fromUserID: Int) {
        let friendRequestStateInfo = UpdateFriendStateDomain(fromUserID: fromUserID, toUserID: toUserID, isFriended: true)
        friendService.updateFriendState(with: friendRequestStateInfo) {[weak self] result in
            self?.isUpdatedFriendRequestState.onNext(result)
        }
    }
}
