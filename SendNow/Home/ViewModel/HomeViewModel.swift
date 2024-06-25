//
//  HomeViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/26/24.
//

import Foundation
import RxSwift

final class HomeViewModel {
    private let friendService = FriendService()
    private let groupService = GroupService()
    private let InvitedFriendList = "InvitedFriendList"
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    private(set) var loginMemberInformation: LoginMemberInformation?
    private(set) var myFriendList: [MyFriendListDomain]?
    private(set) var myGroupList: [GroupListDomain]?
    private var invitedFriends: [Int]?
    let isLoadedMemberInformation = BehaviorSubject(value: "noValue")
    let isLoadedMyFriendList = PublishSubject<Bool>()
    let isLoadedMyGroupList = PublishSubject<Bool>()
    let isExistedInvitedFriend = PublishSubject<Bool>()
    let isInvitedFriendToGroup = PublishSubject<Bool>()
    
    func loadMemberInformation() {
        guard let signinType = UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue),
              let nickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let email = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let searchID = UserDefaults.standard.string(forKey: MemberInfoField.searchID.rawValue) else { return }
        let bankName = UserDefaults.standard.string(forKey: MemberInfoField.bankName.rawValue) ?? nil
        let accountNumber = UserDefaults.standard.string(forKey: MemberInfoField.accountNumber.rawValue) ?? nil
        let kakaoPayUrl = UserDefaults.standard.string(forKey: MemberInfoField.kakaoPayUrl.rawValue) ?? nil
        switch signinType {
        case SigninType.kakao.rawValue:
            guard let kakaoToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue),
                  let kakaoID = UserDefaults.standard.string(forKey: MemberInfoField.kakaoID.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID,
                                                         nickname: nickname,
                                                         email: email,
                                                         password: nil,
                                                         kakaoToken: kakaoToken,
                                                         appleToken: nil,
                                                         kakaoID: kakaoID,
                                                         searchID: searchID,
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext("setValue")
            return
        case SigninType.apple.rawValue:
            guard let appleToken = UserDefaults.standard.string(forKey: MemberInfoField.appleToken.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID,
                                                         nickname: nickname,
                                                         email: email,
                                                         password: nil,
                                                         kakaoToken: nil,
                                                         appleToken: appleToken,
                                                         kakaoID: nil,
                                                         searchID:searchID,
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext("setValue")
            return
        case SigninType.email.rawValue:
            guard let password = UserDefaults.standard.string(forKey: MemberInfoField.password.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID,
                                                         nickname: nickname,
                                                         email: email,
                                                         password: password,
                                                         kakaoToken: nil,
                                                         appleToken: nil,
                                                         kakaoID: nil,
                                                         searchID: searchID,
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext("setValue")
            return
        default: return
        }
    }
    
    func signout() {
        UserDefaults.standard.removeObject(forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.password.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoToken.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.appleToken.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.searchID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoPayUrl.rawValue)
    }
    
    
    func loadMyFriend() {
        friendService.getMyFriendList(with: userID) {[weak self] result in
            guard !result.isEmpty else {
                self?.isLoadedMyFriendList.onNext(false)
                return }
            self?.myFriendList = result
            self?.isLoadedMyFriendList.onNext(true)
        }
    }
    
    func loadMyGroup() {
        groupService.getGroupList(with: userID) {[weak self] result in
            self?.myGroupList = result
            self?.isLoadedMyGroupList.onNext(!result.isEmpty)
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
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else {
            isExistedInvitedFriend.onNext(false)
            return }
        isExistedInvitedFriend.onNext(true)
    }
    
    func invitedFriendToGroup(groupName: String) {
        guard let invitedFriendList = UserDefaults.standard.array(forKey: InvitedFriendList) as? [Int] else { return }
        let groupCreationDomain = GroupCreationDomain(groupName: groupName, userIDList: invitedFriendList, creatorID: userID)
        groupService.setGroupList(with: groupCreationDomain) {[weak self] result in
            self?.isInvitedFriendToGroup.onNext(result)
        }
    }
    
    func removeSelectedFriend() {
        UserDefaults.standard.removeObject(forKey: InvitedFriendList)
    }
}
