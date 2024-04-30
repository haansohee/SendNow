//
//  HomeViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/26/24.
//

import Foundation
import RxSwift

final class HomeViewModel {
    private(set) var loginMemberInformation: LoginMemberInformation?
    let isLoadedMemberInformation = BehaviorSubject(value: "noValue")
    
    func loadMemberInformation() {
        print("🚨 loadMemberInformation")
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
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
}
