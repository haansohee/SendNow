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
    private(set) var invitedFriendList: [MyFriendListDomain] = []
    private(set) var remainderUserID: Int?
    private var groupName: String?
    private var invitedFriends: [Int]?
    let isLoadedMyGroupList = PublishSubject<Result<Void, Error>>()
    let isInvitedFriendToGroup = PublishSubject<Bool>()
    
    init(groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
    func loadMyGroup() {
        groupService.getGroupList(with: userID) {[weak self] getGroupListResult in
            switch getGroupListResult {
            case .success(let groupListDomain):
                self?.myGroupList = groupListDomain
                self?.isLoadedMyGroupList.onNext(.success(Void()))
            case .failure(let error):
                self?.isLoadedMyGroupList.onNext(.failure(error))
            }
        }
    }
    
    func setInvitedFriendList(friendList: [MyFriendListDomain]) {
        self.invitedFriendList = friendList
    }
    
    func loadSelectedFriendList() {
        guard let nickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) else { return }
        let kakaoPayUrl = UserDefaults.standard.string(forKey: MemberInfoField.kakaoPayUrl.rawValue)
        let myInformation = MyFriendListDomain(userID: userID, nickname: nickname, kakaoPayUrl: kakaoPayUrl)
        self.invitedFriendList.append(myInformation)
    }
    
    func selectInvitedFriend(friendUserID: MyFriendListDomain) {
        self.invitedFriendList.append(friendUserID)
    }
    
    func deselectInvitedFriend(friendUserID: MyFriendListDomain) {
        guard let deselectIndex = self.invitedFriendList .firstIndex(of: friendUserID) else { return }
        self.invitedFriendList.remove(at: deselectIndex)
    }
    
    func selectRemainderUserID(_ remainderUserID: Int) {
        self.remainderUserID = remainderUserID
    }
    
    func invitedFriendToGroup(groupName: String, remainderUserID: Int) {
        guard let userNickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) else { return }
        let newGroupName = (groupName.isEmpty || groupName == "") ? "\(userNickname) 님의 그룹" : groupName
        self.groupName = newGroupName
        guard !self.invitedFriendList.isEmpty else { return }
        let groupCreationDomain = GroupCreationDomain(
            groupName: newGroupName,
            userIDList: self.invitedFriendList.map { $0.userID },
            creatorID: userID,
            remainderUserID: remainderUserID
        )
        let groupCreationRequestDTO = GroupCreationRequestDTO(
            groupName: groupCreationDomain.groupName,
            userIDList: groupCreationDomain.userIDList,
            creatorID: groupCreationDomain.creatorID,
            remainderUserID: groupCreationDomain.remainderUserID
        )
        groupService.setGroupList(with: groupCreationRequestDTO) {[weak self] result, _ in
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
            receiverUserID: self.invitedFriendList.map { $0.userID },
            groupName: groupName
        )
        let notificationRequestDTO = GroupNotificationRequestDTO(
            senderUserID: notificationDomain.senderUserID,
            receiverUserID: notificationDomain.receiverUserID,
            groupName: notificationDomain.groupName
        )
        notificationService.sendGroupNotification(with: notificationRequestDTO) {[weak self] result, _ in
            if result { self?.invitedFriendList = [] }
        }
    }
}
