//
//  SigninViewModel.swift
//  SendNow
//
//  Created by 한소희 on 3/26/24.
//

import Foundation
import RxSwift
import RxKakaoSDKUser
import KakaoSDKUser
import KakaoSDKAuth
import RxKakaoSDKAuth
import FirebaseMessaging

final class SigninViewModel {
    private let disposeBag = DisposeBag()
    private let memberService = MemberService()
    let isSuccessedUpdatedNickname = PublishSubject<Bool>()
    let isSuccessSignin = PublishSubject<Bool>()
    let isValidEmailPassword = PublishSubject<Bool>()
    let fcmToken = UserDefaults.standard.string(forKey: MemberInfoField.fcmToken.rawValue)
    let isSetNoti = UserDefaults.standard.bool(forKey: MemberInfoField.isSetNoti.rawValue)
    
    func updateFCMToken() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("ERROR/Fail Load FCM Token : \(error.localizedDescription)")
                return
            } else if let fcmToken = token {
                UserDefaults.standard.set(fcmToken, forKey: MemberInfoField.fcmToken.rawValue)
            } else {
                print("FCM Token is nil....")
                return
            }
        }
    }
    
    func signinWithKakao() {
        guard UserApi.isKakaoTalkLoginAvailable() else { return }
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { [weak self] oauthToken in
                guard let kakaoToken = oauthToken.idToken else { return }
                UserDefaults.standard.set(kakaoToken, forKey: MemberInfoField.kakaoToken.rawValue)
                self?.checkRegisteredKakaoMember(kakaoToken)
            })
            .disposed(by: disposeBag)
    }
    
    func checkRegisteredKakaoMember(_ kakaoToken: String) {
        memberService.getKakaoMemberInfo(with: kakaoToken) { [weak self] kakaoMemberInfo in
            guard let kakaoToken = kakaoMemberInfo.kakaoToken,
                  let email = kakaoMemberInfo.email,
                  let userID = kakaoMemberInfo.userID,
                  let kakaoID = kakaoMemberInfo.kakaoID,
                  !kakaoToken.isEmpty,
                  !email.isEmpty else {
                self?.signupWithKakao()  // 회원가입이 필요함
                return
            }
            
            guard let nickname = kakaoMemberInfo.nickname,
                  !(nickname.isEmpty) else {
                let kakaoMemberInformation = KakaoMemberDomain(userID: userID, nickname: "", email: email, kakaoToken: kakaoToken, kakaoID: kakaoID, bankName: kakaoMemberInfo.bankName ?? "", accountNumber: kakaoMemberInfo.accountNumber ?? "", kakaoPayUrl: kakaoMemberInfo.kakaoPayUrl ?? "")
                self?.setUserDefaultsKakaoMember(kakaoMemberInformation)
                self?.isSuccessSignin.onNext(false)
                return // 회원가입만 하고 닉네임 설정 안 한 멤버
            }

            let kakaoMemberInformation = KakaoMemberDomain(userID: userID, nickname: nickname, email: email, kakaoToken: kakaoToken, kakaoID: kakaoID, bankName: kakaoMemberInfo.bankName ?? "", accountNumber: kakaoMemberInfo.accountNumber ?? "", kakaoPayUrl: kakaoMemberInfo.kakaoPayUrl ?? "")
            self?.setUserDefaultsKakaoMember(kakaoMemberInformation)
            self?.isSuccessSignin.onNext(true)  // 로그인
        }
    }
    
    func signupWithKakao() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                guard let accessToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue),
                      let kakaoID = user.id,
                      let email = user.kakaoAccount?.email as? String else { return }
                let signinWithKakaoDomain = SigninWithKakaoDomain(nickname: "", email: email, kakaoToken: accessToken, kakaoID: kakaoID, isSetNoti: self?.isSetNoti ?? false, fcmToken: self?.fcmToken ?? "")
                self?.memberService.setKakaoMemberInfo(with: signinWithKakaoDomain) { result in
                    guard result else { return }
                    self?.checkRegisteredKakaoMember(accessToken)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signinWithApple(_ appleToken: String, _ authorizationCode: String) {
        memberService.getAppleMemberInfo(with: appleToken) {[weak self] appleMemberInfo in
            guard let appleToken = appleMemberInfo.appleToken,
                  let email = appleMemberInfo.email,
                  let userID = appleMemberInfo.userID,
                  !(appleToken.isEmpty),
                  !(email.isEmpty) else {
                let signupWithAppleInfo = SigninWithAppleDomain(nickname: "", appleToken: appleToken, authorizationCode: authorizationCode, isSetNoti: self?.isSetNoti ?? false, fcmToken: self?.fcmToken ?? "")
                self?.signupWithApple(signupWithAppleInfo) // 회원가입 필요
                return }
            
            guard let nickname = appleMemberInfo.nickname,
                  !(nickname.isEmpty) else {  // 회원가입은 되어 있는데 닉네임 설정까지 안 한 회원
                let appleMemberInformation = AppleMemberDomain(userID: userID, nickname: "", email: email, appleToken: appleToken, bankName: appleMemberInfo.bankName ?? "" , accountNumber: appleMemberInfo.accountNumber ?? "", kakaoPayUrl: appleMemberInfo.kakaoPayUrl ?? "")
                self?.setUserDefaultsAppleMember(appleMemberInformation: appleMemberInformation)
                self?.isSuccessSignin.onNext(false)
                return
            }
            
            let appleMemberInformation = AppleMemberDomain(userID: userID, nickname: nickname, email: email, appleToken: appleToken, bankName: appleMemberInfo.bankName ?? "" , accountNumber: appleMemberInfo.accountNumber ?? "", kakaoPayUrl: appleMemberInfo.kakaoPayUrl ?? "")
            self?.setUserDefaultsAppleMember(appleMemberInformation: appleMemberInformation)
            self?.isSuccessSignin.onNext(true)  // 로그인
        }
    }
    
    func signupWithApple(_ signinWithAppleInfo: SigninWithAppleDomain) {
        memberService.setAppleMemberInfo(with: signinWithAppleInfo) {[weak self] result in
            guard result else { return }
            self?.signinWithApple(signinWithAppleInfo.appleToken, signinWithAppleInfo.authorizationCode)
        }
    }
    
    func updateNickname(_ nickname: String) {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        let updateNicknameInfo = UpdateNicknameDomain(userID: userID, nickname: nickname)
        memberService.updateNickname(with: updateNicknameInfo) { [weak self] result in
            if result {
                UserDefaults.standard.set(nickname, forKey: MemberInfoField.nickname.rawValue)
            }
            self?.isSuccessedUpdatedNickname.onNext(result)
        }
    }
    
    func isValidEmailPassword(_ email: String, _ password: String) {
        let validationInformation = ValidationEmailPasswordDomain(email: email, password: password)
        memberService.isValidEmailPassword(with: validationInformation) {[weak self] isValid in
            self?.isValidEmailPassword.onNext(isValid)
            guard isValid else { return }
            self?.signinWithEmail(email)
        }
        
    }
    
    func signinWithEmail(_ email: String) {  // 가입된 이메일 유저고 패스워드 일치 시 로그인 진행
        memberService.getEmailMemberInfo(with: email) {[weak self] emailMemberInfo in
            guard let userID = emailMemberInfo.userID,
                  let nickname = emailMemberInfo.nickname,
                  let password = emailMemberInfo.password,
                  !(nickname.isEmpty),
                  !(password.isEmpty) else { return }
            let emailMemberInformation = EmailMemberDomain(userID: userID, nickname: nickname, email: email, password: password, bankName: emailMemberInfo.bankName ?? "", accountNumber: emailMemberInfo.accountNumber ?? "", kakaoPayUrl: emailMemberInfo.kakaoPayUrl ?? "")
            self?.setUserDefaultsEmailMember(emailMemberInformation)
            self?.isSuccessSignin.onNext(true)
        }
    }
    
    func setUserDefaultsEmailMember(_ emailMemberInformation: EmailMemberDomain) {
        UserDefaults.standard.set(emailMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(emailMemberInformation.password, forKey: MemberInfoField.password.rawValue)
        UserDefaults.standard.set(emailMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(emailMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(SigninType.email.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(emailMemberInformation.bankName ?? nil, forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.set(emailMemberInformation.accountNumber ?? nil, forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.set(emailMemberInformation.kakaoPayUrl ?? nil, forKey: MemberInfoField.kakaoPayUrl.rawValue)
    }
    
    func setUserDefaultsKakaoMember(_ kakaoMemberInformation: KakaoMemberDomain) {
        UserDefaults.standard.set(kakaoMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoToken, forKey: MemberInfoField.kakaoToken.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoID, forKey: MemberInfoField.kakaoID.rawValue)
        UserDefaults.standard.set(SigninType.kakao.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.bankName, forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.accountNumber, forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.set(kakaoMemberInformation.kakaoPayUrl, forKey: MemberInfoField.kakaoPayUrl.rawValue)
    }
    
    func setUserDefaultsAppleMember(appleMemberInformation: AppleMemberDomain) {
        UserDefaults.standard.set(appleMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(appleMemberInformation.appleToken, forKey: MemberInfoField.appleToken.rawValue)
        UserDefaults.standard.set(appleMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(appleMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.set(SigninType.apple.rawValue, forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.set(appleMemberInformation.bankName, forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.set(appleMemberInformation.accountNumber, forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.set(appleMemberInformation.kakaoPayUrl, forKey: MemberInfoField.kakaoPayUrl.rawValue)
    }
}
