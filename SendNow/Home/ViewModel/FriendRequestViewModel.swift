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
        let friendAddInfo = FriendAddDomain(
            fromUserID: userID,
            fromUserNickname: fromUserNickname,
            toUserID: toUserID
        )
        let friendAddRequestDTO = FriendAddRequestDTO(
            fromUserID: friendAddInfo.fromUserID,
            fromUserNickname: friendAddInfo.fromUserNickname,
            toUserID: friendAddInfo.toUserID
        )
        friendService.setFriendRequest(with: friendAddRequestDTO) {[weak self] result in
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
            let searchFriendInfoDomain = SearchFriendDomain(
                userID: result.userID,
                nickname: result.nickname,
                bankName: result.bankName,
                accountNumber: result.accountNumber,
                kakaoPayUrl: result.kakaoPayUrl
            )
            self?.searchFriendInformation = searchFriendInfoDomain
            self?.isEmptySearchFriend.onNext(!result.nickname.isEmpty)
        }
    }
    
    func getFriendRequestList() {
        friendService.getFriendRequestListInformation(with: userID) {[weak self] result in
            guard !result.isEmpty else {
                self?.isLoadedFriendRequestListInfo.onNext(false)
                return }
            self?.isLoadedFriendRequestListInfo.onNext(true)
            let friendAddListInfoDomain: [FriendRequestListDomain] = result.map {
                FriendRequestListDomain(
                    fromUserID: $0.fromUserID,
                    fromUserNickname: $0.fromUserNickname,
                    toUserID: $0.toUserID,
                    toUserNickname: $0.toUserNickname,
                    isFriended: $0.isFriended
                )
            }
            self?.friendRequestSendListInfo = friendAddListInfoDomain.filter { $0.fromUserID == self?.userID }
            self?.friendRequestReceiveListInfo = friendAddListInfoDomain.filter { $0.toUserID == self?.userID }
        }
    }
    
    func deleteFriendRequest(toUserID: Int, fromUserID: Int) {
        let deleteFriendDomain = DeleteFriendDomain(
            fromUserID: fromUserID,
            toUserID: toUserID
        )
        let deleteFriendRequestDTO = DeleteFriendRequestDTO(
            fromUserID: deleteFriendDomain.fromUserID,
            toUserID: deleteFriendDomain.toUserID
        )
        friendService.deleteFriendRequestList(with: deleteFriendRequestDTO) {[weak self] result in
            self?.isDeletedFriendRequest.onNext(result)
        }
    }
    
    func updateFriendRequestState(toUserID: Int, fromUserID: Int) {
        let updateFriendStateDomain = UpdateFriendStateDomain(
            fromUserID: fromUserID,
            toUserID: toUserID,
            isFriended: true
        )
        let updateFriendStateRequestDTO = UpdateFriendStateRequestDTO(
            fromUserID: updateFriendStateDomain.fromUserID,
            toUserID: updateFriendStateDomain.toUserID,
            isFriended: updateFriendStateDomain.isFriended
        )
        friendService.updateFriendState(with: updateFriendStateRequestDTO) {[weak self] result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.sendFriendRequest.rawValue), object: result)
            }
            self?.isUpdatedFriendRequestState.onNext(result)
        }
    }
    
    func sendFriendNotification() {
        guard let receiverUserID = friendRequestReceivedUserID else { return }
        let friendNotificationInfo = FriendNotificationDomain(
            senderUserID: userID,
            receiverUserID: receiverUserID
        )
        let friendNotificationRequestDTO = FriendNotificationRequestDTO(
            senderUserID: friendNotificationInfo.senderUserID,
            receiverUserID: friendNotificationInfo.receiverUserID
        )
        notificationService.sendFriendNotification(with: friendNotificationRequestDTO) { _ in }
    }
}
