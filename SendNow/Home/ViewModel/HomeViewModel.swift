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

struct SummaryInformation {
    let image: UIImage
    let subTitle: String
    let amount: String
}

final class HomeViewModel {
    private let friendService: FriendService
    private let notificationService: NotificationService
    private let memberService: MemberService
    private let userID: Int
    private var groupName: String?
    private(set) var loginMemberInformation: LoginMemberInformation?
    private(set) var myFriendList: [MyFriendListDomain]?
    private(set) var remainderCandidateList: [MyFriendListDomain]?
    private(set) var summaryInformation: [SummaryInformation]?
    let isLoadedMemberInformation = PublishSubject<Void>()
    let isLoadedMyFriendList = PublishSubject<Result<Void, Error>>()
    
    init(with friendService: FriendService = FriendService(),
         notificationService: NotificationService = NotificationService(),
         memberService: MemberService = MemberService(),
         userID: Int) {
        self.friendService = friendService
        self.notificationService = notificationService
        self.memberService = memberService
        self.userID = userID
    }
    
    private func setSummaryInformation(receivedAmount: String, sentAmount: String, unsettledCount: Int) {
        guard let receivedImage = UIImage(systemName: "wonsign.arrow.trianglehead.counterclockwise.rotate.90"),
              let sentImage = UIImage(systemName: "arrow.up.message.fill"),
              let unsettledImage = UIImage(systemName: "person.2.circle") else { return }
        self.summaryInformation = [
            SummaryInformation(
                image: receivedImage,
                subTitle: "받을 금액",
                amount: "\(receivedAmount) 원"),
            SummaryInformation(
                image: sentImage,
                subTitle: "보낼 금액",
                amount: "\(sentAmount) 원"),
            SummaryInformation(
                image: unsettledImage,
                subTitle: "미정산 그룹",
                amount: "\(unsettledCount) 개"),
        ]
    }
    
    func updateFCMToken() {
        Messaging.messaging().token {[weak self] token, error in
            if let error = error {
                print("ERROR/Fail Load FCM Token : \(error.localizedDescription)")
                return
            }
            guard let fcmToken = token,
                  let userID = self?.userID else { return }
            let updateFcmTokenInfoDomain = UpdateFcmTokenInformationDomain(
                userID: userID,
                fcmToken: fcmToken
            )
            let updateFcmTokenInfoRequestDTO = UpdateFcmTokenInformationRequestDTO(
                userID: updateFcmTokenInfoDomain.userID,
                fcmToken: updateFcmTokenInfoDomain.fcmToken
            )
            self?.memberService.updateMemberFcmToken(with: updateFcmTokenInfoRequestDTO) { _ in }
        }
    }
    
    func loadKakaoMemberInformation() {
        guard let kakaoToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue) else { return }
        memberService.getKakaoMemberInfo(with: kakaoToken) {[weak self] getKakaoMemberInfoResult in
            switch getKakaoMemberInfoResult {
            case .success(let kakaoMemberInfo):
                guard let userID = kakaoMemberInfo.userID,
                      let nickname = kakaoMemberInfo.nickname,
                      let email = kakaoMemberInfo.email,
                      let kakaoToken = kakaoMemberInfo.kakaoToken,
                      let kakaoID = kakaoMemberInfo.kakaoID,
                      let summaryReceived = kakaoMemberInfo.summaryReceived,
                      let summarySent = kakaoMemberInfo.summarySent,
                      let summaryUnsettled = kakaoMemberInfo.summaryUnsettled else {
                    return }
                let loginMemberInfo = LoginMemberInformation(
                    userID: userID,
                    nickname: nickname,
                    email: email,
                    password: nil,
                    kakaoToken: kakaoToken,
                    appleToken: nil,
                    kakaoID: String(kakaoID),
                    kakaoPayUrl: kakaoMemberInfo.kakaoPayUrl,
                    isDismissed: kakaoMemberInfo.isDismissed,
                    summaryReceived: summaryReceived,
                    summarySent: summarySent,
                    summaryUnsettled: summaryUnsettled)
                self?.setSummaryInformation(
                    receivedAmount: summaryReceived,
                    sentAmount: summarySent,
                    unsettledCount: summaryUnsettled)
                self?.loginMemberInformation = loginMemberInfo
                self?.setUserDefaultsKakaoMember(kakaoMemberInfo)
                self?.isLoadedMemberInformation.onNext(Void())
            case .failure(let error):
                self?.isLoadedMemberInformation.onError(error)
            }
        }
    }
    
    func loadAppleMemberInformation() {
        guard let appleToken = UserDefaults.standard.string(forKey: MemberInfoField.appleToken.rawValue) else { return }
        memberService.getAppleMemberInfo(with: appleToken) {[weak self] getAppleMemberInfoResult in
            switch getAppleMemberInfoResult {
            case .success(let appleMemberInfo):
                guard let userID = appleMemberInfo.userID,
                      let nickname = appleMemberInfo.nickname,
                      let email = appleMemberInfo.email,
                      let appleToken = appleMemberInfo.appleToken,
                      let summaryReceived = appleMemberInfo.summaryReceived,
                      let summarySent = appleMemberInfo.summarySent,
                      let summaryUnsettled = appleMemberInfo.summaryUnsettled else { return }
                let loginMemberInfo = LoginMemberInformation(
                    userID: userID,
                    nickname: nickname,
                    email: email,
                    password: nil,
                    kakaoToken: nil,
                    appleToken: appleToken,
                    kakaoID: nil,
                    kakaoPayUrl: appleMemberInfo.kakaoPayUrl,
                    isDismissed: appleMemberInfo.isDismissed,
                    summaryReceived: summaryReceived,
                    summarySent: summarySent,
                    summaryUnsettled: summaryUnsettled)
                self?.setSummaryInformation(
                    receivedAmount: summaryReceived,
                    sentAmount: summarySent,
                    unsettledCount: summaryUnsettled)
                self?.loginMemberInformation = loginMemberInfo
                self?.setUserDefaultsAppleMember(appleMemberInfo)
                self?.isLoadedMemberInformation.onNext(Void())
            case .failure(let error):
                self?.isLoadedMemberInformation.onError(error)
            }
        }
    }
    
    func loadEmailMemberInformation() {
        guard let email = UserDefaults.standard.string(forKey: MemberInfoField.email.rawValue) else { return }
        memberService.getEmailMemberInfo(with: email) {[weak self] getEmailMemberInfoResult in
            switch getEmailMemberInfoResult {
            case .success(let emailMemberInfo):
                guard let userID = emailMemberInfo.userID,
                      let nickname = emailMemberInfo.nickname,
                      let email = emailMemberInfo.email,
                      let password = emailMemberInfo.password,
                      let summaryReceived = emailMemberInfo.summaryReceived,
                      let summarySent = emailMemberInfo.summarySent,
                      let summaryUnsettled = emailMemberInfo.summaryUnsettled else { return }
                let loginMemberInfo = LoginMemberInformation(
                    userID: userID,
                    nickname: nickname,
                    email: email,
                    password: password,
                    kakaoToken: nil,
                    appleToken: nil,
                    kakaoID: nil,
                    kakaoPayUrl: emailMemberInfo.kakaoPayUrl,
                    isDismissed: emailMemberInfo.isDismissed,
                    summaryReceived: summaryReceived,
                    summarySent: summarySent,
                    summaryUnsettled: summaryUnsettled)
                self?.setSummaryInformation(
                    receivedAmount: summaryReceived,
                    sentAmount: summarySent,
                    unsettledCount: summaryUnsettled)
                self?.loginMemberInformation = loginMemberInfo
                self?.setUserDefaultsEmailMember(emailMemberInfo)
                self?.isLoadedMemberInformation.onNext(Void())
            case .failure(let error):
                self?.isLoadedMemberInformation.onError(error)
            }
        }
    }
    
    func loadMemberInformation() {
        guard let signinType = UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue) else { return }
        switch signinType {
        case SigninType.kakao.rawValue:
            loadKakaoMemberInformation()
            return
            
        case SigninType.apple.rawValue:
            loadAppleMemberInformation()
            return
            
        case SigninType.email.rawValue:
            loadEmailMemberInformation()
            return
            
        default: return
        }
    }
    
    func loadMyFriend() {
        let user = MyFriendListDomain(
            userID: userID,
            nickname: "\(UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue) ?? "") (본인)",
            kakaoPayUrl: UserDefaults.standard.string(forKey: MemberInfoField.kakaoPayUrl.rawValue)
        )
        friendService.getMyFriendList(with: userID) {[weak self] getMyFriendListResult in
            switch getMyFriendListResult {
            case .success(let myFriendListInfo):
                self?.myFriendList = myFriendListInfo
                self?.remainderCandidateList = myFriendListInfo
                self?.remainderCandidateList?.append(contentsOf: [user])
                self?.isLoadedMyFriendList.onNext(.success(Void()))
            case .failure(let error):
                self?.isLoadedMyFriendList.onNext(.failure(error))
            }
        }
    }
    
    func setUserDefaultsEmailMember(_ emailMemberInformation: EmailMemberDomain) {
        UserDefaults.standard.set(emailMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(emailMemberInformation.password, forKey: MemberInfoField.password.rawValue)
        UserDefaults.standard.set(emailMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(emailMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(SigninType.email.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(emailMemberInformation.kakaoPayUrl ?? nil, forKey: MemberInfoField.kakaoPayUrl.rawValue)
        UserDefaults.standard.set(emailMemberInformation.isDismissed, forKey: MemberInfoField.isDismissed.rawValue)
        UserDefaults.standard.set(emailMemberInformation.summaryReceived, forKey: MemberInfoField.summaryReceived.rawValue)
        UserDefaults.standard.set(emailMemberInformation.summarySent, forKey: MemberInfoField.summarySent.rawValue)
        UserDefaults.standard.set(emailMemberInformation.summaryUnsettled, forKey: MemberInfoField.summaryUnsettled.rawValue)
    }
    
    func setUserDefaultsKakaoMember(_ kakaoMemberInformation: KakaoMemberDomain) {
        UserDefaults.standard.set(kakaoMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoToken, forKey: MemberInfoField.kakaoToken.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoID, forKey: MemberInfoField.kakaoID.rawValue)
        UserDefaults.standard.set(SigninType.kakao.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoPayUrl, forKey: MemberInfoField.kakaoPayUrl.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.isDismissed, forKey: MemberInfoField.isDismissed.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.summaryReceived, forKey: MemberInfoField.summaryReceived.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.summarySent, forKey: MemberInfoField.summarySent.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.summaryUnsettled, forKey: MemberInfoField.summaryUnsettled.rawValue)
    }
    
    func setUserDefaultsAppleMember(_ appleMemberInformation: AppleMemberDomain) {
        UserDefaults.standard.set(appleMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(appleMemberInformation.appleToken, forKey: MemberInfoField.appleToken.rawValue)
        UserDefaults.standard.set(appleMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(appleMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(SigninType.apple.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(appleMemberInformation.kakaoPayUrl, forKey: MemberInfoField.kakaoPayUrl.rawValue)
        UserDefaults.standard.set(appleMemberInformation.isDismissed, forKey: MemberInfoField.isDismissed.rawValue)
        UserDefaults.standard.set(appleMemberInformation.summaryReceived, forKey: MemberInfoField.summaryReceived.rawValue)
        UserDefaults.standard.set(appleMemberInformation.summarySent, forKey: MemberInfoField.summarySent.rawValue)
        UserDefaults.standard.set(appleMemberInformation.summaryUnsettled, forKey: MemberInfoField.summaryUnsettled.rawValue)
    }

}
