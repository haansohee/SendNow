//
//  GroupListViewModel.swift
//  SendNow
//
//  Created by 한소희 on 8/26/24.
//

import Foundation
import RxSwift

final class GroupListViewModel {
    private let groupService: GroupService
    private let notificationService = NotificationService()
    private let userID: Int
    private(set) var myGroupList: [GroupListDomain]?
    private(set) var invitedFriendListTest: [Int]?
    private(set) var invitedFriendList: [Int] = []
    private(set) var remainderUserID: Int?
    private var groupName: String?
    private var invitedFriends: [Int]?
    let isLoadedMyGroupList = PublishSubject<Void>()
    let isInvitedFriendToGroup = PublishSubject<Bool>()
    let isExistedInvitedFriend = PublishSubject<Bool>()
    
    init(groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
    func loadMyGroup() {
        groupService.getGroupList(with: userID) {[weak self] getGroupListResult in
            switch getGroupListResult {
            case .success(let groupListDomain):
                self?.myGroupList = groupListDomain
                self?.isLoadedMyGroupList.onNext(Void())
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func setInvitedFriendList(friendList: [Int]) {
        self.invitedFriendListTest = friendList
    }
    
    func selectInvitedFriend(friendUserID: Int) {
        self.invitedFriendList.append(friendUserID)
        print("invited Friend List : \(self.invitedFriendList)")
    }
    
    func deselectInvitedFriend(friendUserID: Int) {
        guard let deselectIndex = self.invitedFriendList .firstIndex(of: friendUserID) else { return }
        self.invitedFriendList.remove(at: deselectIndex)
    }
    
    func checkSelectedFriend() {
        isExistedInvitedFriend.onNext(!self.invitedFriendList.isEmpty)
    }
    
    func selectRemainderUserID(_ remainderUserID: Int) {
        self.remainderUserID = remainderUserID
    }
    
    func invitedFriendToGroup(groupName: String) {
        self.groupName = groupName
        guard !self.invitedFriendList.isEmpty else { return }
        guard let remainderUserID = self.remainderUserID else { return }
        let groupCreationDomain = GroupCreationDomain(
            groupName: groupName,
            userIDList: self.invitedFriendList,
            creatorID: userID,
            remainderUserID: remainderUserID
        )
        let groupCreationRequestDTO = GroupCreationRequestDTO(
            groupName: groupCreationDomain.groupName,
            userIDList: groupCreationDomain.userIDList,
            creatorID: groupCreationDomain.creatorID,
            remainderUserID: groupCreationDomain.remainderUserID
        )
        groupService.setGroupList(with: groupCreationRequestDTO) {[weak self] result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.invitedFriend.rawValue), object: result)
                self?.sendNotification()
            }
            self?.isInvitedFriendToGroup.onNext(result)
        }
    }
    
    func sendNotification() {
        guard let groupName = groupName else { return }
        let notificationDomain = GroupNotificationDomain(
            senderUserID: userID,
            receiverUserID: self.invitedFriendList,
            groupName: groupName
        )
        let notificationRequestDTO = GroupNotificationRequestDTO(
            senderUserID: notificationDomain.senderUserID,
            receiverUserID: notificationDomain.receiverUserID,
            groupName: notificationDomain.groupName
        )
        notificationService.sendGroupNotification(with: notificationRequestDTO) {[weak self] result in
            if result { self?.invitedFriendList = [] }
        }
    }
}
