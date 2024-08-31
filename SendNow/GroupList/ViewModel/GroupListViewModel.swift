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
    private(set) var myGroupList: [GroupListDomain]?
    private var groupName: String?
    private let InvitedFriendList = "InvitedFriendList"
    let isLoadedMyGroupList = PublishSubject<Void>()
    let isInvitedFriendToGroup = PublishSubject<Bool>()
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    
    func loadMyGroup() {
        groupService.getGroupList(with: userID) {[weak self] result in
            guard !result.isEmpty else { return }
            self?.myGroupList = result
            self?.isLoadedMyGroupList.onNext(Void())
        }
    }
    
    func invitedFriendToGroup(groupName: String) {
        self.groupName = groupName
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else { return }
        let groupCreationDomain = GroupCreationDomain(groupName: groupName, userIDList: invitedFriendList, creatorID: userID)
        groupService.setGroupList(with: groupCreationDomain) {[weak self] result in
            self?.isInvitedFriendToGroup.onNext(result)
        }
    }
}
