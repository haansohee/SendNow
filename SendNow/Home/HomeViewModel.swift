//
//  HomeViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import Foundation

final class HomeViewModel {
    private(set) var loginMemberInformation: LoginMemberInformation?
    func loadMemberInformation() {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        guard let nickname = UserDefaults.standard.string(forKey: MemberInfoField.nickname.rawValue),
              let email = UserDefaults.standard.string(forKey: MemberInfoField.email.rawValue),
              let searchID = UserDefaults.standard.string(forKey: MemberInfoField.searchID.rawValue) else { return }
        
        if let password = UserDefaults.standard.string(forKey: MemberInfoField.password.rawValue) {
            let loginMemberInformation = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: password, kakaoToken: nil, appleToken: nil, kakaoID: nil, searchID: searchID)
            self.loginMemberInformation = loginMemberInformation
            return
        } else if let kakaoToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue) {
            let kakaoID = UserDefaults.standard.string(forKey: MemberInfoField.kakaoID.rawValue)
            let loginMemberInformation = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: nil, kakaoToken: kakaoToken, appleToken: nil, kakaoID: kakaoID, searchID: searchID)
            self.loginMemberInformation = loginMemberInformation
            return
        } else if let appleToken = UserDefaults.standard.string(forKey: MemberInfoField.appleToken.rawValue) {
            let loginMemberInformation = LoginMemberInformation(userID: userID, nickname: nickname, email: email, password: nil, kakaoToken: nil, appleToken: appleToken, kakaoID: nil, searchID: searchID)
            self.loginMemberInformation = loginMemberInformation
            return
        } else {
            return
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
        UserDefaults.standard.removeObject(forKey: MemberInfoField.searchID.rawValue)
    }
}
