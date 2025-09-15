//
//  HomeViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/26/24.
//

import Foundation
import RxSwift
import NotificationCenter
import FirebaseMessaging
import Firebase

final class HomeViewModel {
    private let friendService: FriendService
    private let notificationService: NotificationService
    private let memberService: MemberService
    private let userID: Int
    private var groupName: String?
    private(set) var loginMemberInformation: LoginMemberInformation?
    private(set) var myFriendList: [MyFriendListDomain]?
    private(set) var remainderCandidateList: [MyFriendListDomain]?
    let isLoadedMemberInformation = PublishSubject<Void>()
    let isLoadedMyFriendList = PublishSubject<Void>()
    let testIsUpdated1 = PublishSubject<Bool>()
    let testIsUpdated2 = PublishSubject<Bool>()
    
    init(with friendService: FriendService = FriendService(),
         notificationService: NotificationService = NotificationService(),
         memberService: MemberService = MemberService(),
         userID: Int) {
        self.friendService = friendService
        self.notificationService = notificationService
        self.memberService = memberService
        self.userID = userID
    }
    
    func updateFCMToken() {
        Messaging.messaging().token {[weak self] token, error in
            if let error = error {
                print("ERROR/Fail Load FCM Token : \(error.localizedDescription)")
                return
            } else if let fcmToken = token {
                guard let userID = self?.userID else { return }
                let updateFcmTokenInfoDomain = UpdateFcmTokenInformationDomain(userID: userID, fcmToken: fcmToken)
                self?.memberService.updateMemberFcmToken(with: updateFcmTokenInfoDomain) { _ in }
            } else {
                return
            }
        }
    }
    
    func loadMemberInformation() {
        guard let signinType = UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue),
              let nickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let email = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) else { return }
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
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext(Void())
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
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext(Void())
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
                                                         bankName: bankName,
                                                         accountNumber: accountNumber,
                                                         kakaoPayUrl: kakaoPayUrl)
            self.loginMemberInformation = loginMemberInfo
            isLoadedMemberInformation.onNext(Void())
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
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoPayUrl.rawValue)
    }
    
    
    func loadMyFriend() {
        let user = MyFriendListDomain(userID: userID,
                                      nickname: "\(UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) ?? "") (본인)",
                                      bankName: UserDefaults.standard.string(forKey: MemberInfoField.bankName.rawValue),
                                      accountNumber: UserDefaults.standard.string(forKey: MemberInfoField.accountNumber.rawValue),
                                      kakaoPayUrl: UserDefaults.standard.string(forKey: MemberInfoField.kakaoPayUrl.rawValue))
        friendService.getMyFriendList(with: userID) {[weak self] result in
            self?.myFriendList = result
            self?.remainderCandidateList = result
            self?.remainderCandidateList?.append(contentsOf: [user])
            self?.isLoadedMyFriendList.onNext(Void())
        }
    }
}
