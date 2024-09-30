//
//  GroupListViewModel.swift
//  SendNow
//
//  Created by 한소희 on 8/26/24.
//

import Foundation
import RxSwift

final class GroupListViewModel {
    private let groupService = GroupService()
    private let notificationService = NotificationService()
    private(set) var myGroupList: [GroupListDomain]?
    private var groupName: String?
    private var invitedFriends: [Int]?
    private let InvitedFriendList = "InvitedFriendList"
    let isLoadedMyGroupList = PublishSubject<Void>()
    let isInvitedFriendToGroup = PublishSubject<Bool>()
    let isExistedInvitedFriend = PublishSubject<Bool>()
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    
    func loadMyGroup() {
        groupService.getGroupList(with: userID) {[weak self] result in
            self?.myGroupList = result
            self?.isLoadedMyGroupList.onNext(Void())
        }
    }
    
    func selectInvitedFriend(friendUserID: Int) {
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else {
            UserDefaults.standard.set([friendUserID], forKey: InvitedFriendList)
            return
        }
        invitedFriends = invitedFriendList
        invitedFriends?.append(friendUserID)
        UserDefaults.standard.set(invitedFriends, forKey: InvitedFriendList)
    }
    
    func deselectInvitedFriend(friendUserID: Int) {
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else { return }
        invitedFriends = invitedFriendList
        guard let removeInedex = invitedFriends?.firstIndex(of: friendUserID) else { return }
        invitedFriends?.remove(at: removeInedex)
        UserDefaults.standard.set(invitedFriends, forKey: InvitedFriendList)
    }
    
    func checkSelectedFriend() {
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int],
              !invitedFriendList.isEmpty else {
            isExistedInvitedFriend.onNext(false)
            return }
        isExistedInvitedFriend.onNext(true)
    }
    
    func removeSelectedFriend() {
        UserDefaults.standard.removeObject(forKey: InvitedFriendList)
    }
    
    func invitedFriendToGroup(groupName: String) {
        self.groupName = groupName
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else { return }
        let groupCreationDomain = GroupCreationDomain(groupName: groupName, userIDList: invitedFriendList, creatorID: userID)
        groupService.setGroupList(with: groupCreationDomain) {[weak self] result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.invitedFriend.rawValue), object: result)
                self?.sendNotification()
                self?.removeSelectedFriend()
            }
            self?.isInvitedFriendToGroup.onNext(result)
        }
    }
    
    func sendNotification() {
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int],
              let groupName = groupName else { return }
        let notificationDomain = GroupNotificationDomain(senderUserID: userID, receiverUserID: invitedFriendList, groupName: groupName)
        notificationService.sendGroupNotification(with: notificationDomain) { result in
            print("send notification result: \(result)")
        }
    }
}
