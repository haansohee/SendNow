//
//  FirendRequestViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation
import RxSwift

final class FriendRequestViewModel {
    private let friendService: FriendService
    private let notificationService: NotificationService
    private let userID: Int
    private(set) var searchFriendInformation: SearchFriendDomain?
    private(set) var friendRequestSendListInfo: [FriendRequestListDomain]?
    private(set) var friendRequestReceiveListInfo: [FriendRequestListDomain]?
    private(set) var friendRequestReceivedUserID: Int?
    let isEmptySearchFriend = PublishSubject<Bool>()
    let isSendedFriendRequest = PublishSubject<Bool>()
    let isLoadedFriendRequestListInfo = PublishSubject<Bool>()
    let isDeletedFriendRequest = PublishSubject<Bool>()
    let isUpdatedFriendRequestState = PublishSubject<Bool>()
    
    init(with friendService: FriendService = FriendService(),
         notificationService: NotificationService = NotificationService(),
         userID: Int) {
        self.friendService = friendService
        self.notificationService = notificationService
        self.userID = userID
    }
    
    func sendFriendRequest(toUserID: Int) {
        guard let fromUserNickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) else {
            return }
        let friendRequestSendInfo = FriendRequestSendDomain(fromUserID: userID, fromUserNickname: fromUserNickname, toUserID: toUserID)
        friendService.setFriendRequest(with: friendRequestSendInfo) {[weak self] result in
            if result {
                self?.friendRequestReceivedUserID = toUserID
                self?.sendFriendNotification()
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.sendFriendRequest.rawValue), object: result)
            }
            self?.isSendedFriendRequest.onNext(result)
        }
    }
    
    func searchFriendNickname(nickname: String) {
        friendService.getFriendInformation(with: nickname) {[weak self] result in
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
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.sendFriendRequest.rawValue), object: result)
            }
            self?.isUpdatedFriendRequestState.onNext(result)
        }
    }
    
    func sendFriendNotification() {
        guard let receiverUserID = friendRequestReceivedUserID else { return }
        let friendNotificationInfo = FriendNotificationDomain(senderUserID: userID, receiverUserID: receiverUserID)
        notificationService.sendFriendNotification(with: friendNotificationInfo) { _ in }
    }
}
