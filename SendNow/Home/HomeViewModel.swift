//
//  HomeViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/26/24.
//

import Foundation

final class HomeViewModel {
    private(set) var loginMemberInformation: LoginMemberInformation?
    
    func loadMemberInformation() {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        guard let signinType = UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue),
              let nickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let email = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let searchID = UserDefaults.standard.string(forKey: MemberInfoField.searchID.rawValue) else { return }
        switch signinType {
        case SigninType.kakao.rawValue:
            guard let kakaoToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue),
                  let kakaoID = UserDefaults.standard.string(forKey: MemberInfoField.kakaoID.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: "", kakaoToken: kakaoToken, appleToken: "", kakaoID: kakaoID, searchID: searchID)
            self.loginMemberInformation = loginMemberInfo
            return
        case SigninType.apple.rawValue:
            guard let appleToken = UserDefaults.standard.string(forKey: MemberInfoField.appleToken.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: "", kakaoToken: "", appleToken: appleToken, kakaoID: "", searchID: searchID)
            self.loginMemberInformation = loginMemberInfo
            return
        case SigninType.email.rawValue:
            guard let password = UserDefaults.standard.string(forKey: MemberInfoField.password.rawValue) else { return }
            let loginMemberInfo = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: password, kakaoToken: "", appleToken: "", kakaoID: "", searchID: searchID)
            self.loginMemberInformation = loginMemberInfo
            return
        default: return
        }
    }
    
    func signout() {
        
    }
}
