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

enum SigninType {
    case kakao
    case apple
}

final class SigninViewModel {
    private let disposeBag = DisposeBag()
    private let memberService = MemberService()
    private(set) var kakaoAccessToken: String?
    private(set) var kakaoMemberInformation: KakaoMemberDomain?
    private(set) var appleMemberInformation: AppleMemberDomain?
    private(set) var emailMemberInformation: EmailMemberDomain?
    private(set) var signupWithAppleInfo: SigninWithAppleDomain?
    var signinType: SigninType?
    let isSuccessedSigninWithKakao = PublishSubject<Bool>()
    let isSuccessedSignupWithKakao = PublishSubject<Bool>()
    let isSuccessedSignupWithApple = PublishSubject<Bool>()
    let isSuccessedUpdatedSearchID = PublishSubject<Bool>()
    let isRegisteredKakaoMember = PublishSubject<Bool>()
    let isExistedSearchID = PublishSubject<Bool>()
    let isExistedEmail = PublishSubject<Bool>()
    let isPasswordMatching = PublishSubject<Bool>()
    
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
                  let searchID = kakaoMemberInfo.searchID,
                  let email = kakaoMemberInfo.email,
                  let nickname = kakaoMemberInfo.nickname,
                  let userID = kakaoMemberInfo.userID,
                  let kakaoID = kakaoMemberInfo.kakaoID else {
                self?.isRegisteredKakaoMember.onNext(true)
                return
            }
            guard !kakaoToken.isEmpty,
                  !searchID.isEmpty,
                  !email.isEmpty,
                  !nickname.isEmpty else {
                self?.isRegisteredKakaoMember.onNext(true)
                return }
            UserDefaults.standard.set(userID, forKey: MemberInfoField.userID.rawValue)
            UserDefaults.standard.set(kakaoToken, forKey: MemberInfoField.kakaoToken.rawValue)
            UserDefaults.standard.set(searchID, forKey: MemberInfoField.searchID.rawValue)
            UserDefaults.standard.set(email, forKey: MemberInfoField.email.rawValue)
            UserDefaults.standard.set(nickname, forKey: MemberInfoField.nickname.rawValue)
            UserDefaults.standard.set(kakaoID, forKey: MemberInfoField.kakaoID.rawValue)
            self?.isRegisteredKakaoMember.onNext(false)
        }
    }
    
    func signupWithKakao(id: String) {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                guard let accessToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue),
                      let nickname = user.kakaoAccount?.profile?.nickname as? String,
                      let kakaoID = user.id,
                      let email = user.kakaoAccount?.email as? String else { return }
                let signinWithKakaoDomain = SigninWithKakaoDomain(searchID: id, nickname: nickname, email: email, kakaoToken: accessToken, kakaoID: kakaoID)
                self?.memberService.setKakaoMemberInfo(with: signinWithKakaoDomain) { result in
                    self?.isSuccessedSignupWithKakao.onNext(result)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setSignupWithAppleInfo(_ signupWithAppleInfo: SigninWithAppleDomain) {
        self.signupWithAppleInfo = signupWithAppleInfo
    }
    
    func signinWithApple(_ appleToken: String) {
        memberService.getAppleMemberInfo(with: appleToken) {[weak self] appleMemberInfo in
            self?.appleMemberInformation = appleMemberInfo
            guard let appleToken = appleMemberInfo.appleToken,
                  let email = appleMemberInfo.email,
                  let nickname = appleMemberInfo.nickname,
                  let userID = appleMemberInfo.userID,
                  !(appleToken.isEmpty),
                  !(email.isEmpty),
                  !(nickname.isEmpty) else { return }
            
            guard let searchID = appleMemberInfo.searchID,
                  !(searchID.isEmpty) else {
                let signupWithAppleInfo = SigninWithAppleDomain(searchID: "", nickname: nickname, email: email, appleToken: appleToken)
                self?.signupWithAppleInfo = signupWithAppleInfo
                self?.isExistedSearchID.onNext(false)
                return
            }
            UserDefaults.standard.set(userID, forKey: MemberInfoField.userID.rawValue)
            UserDefaults.standard.set(appleToken, forKey: MemberInfoField.appleToken.rawValue)
            UserDefaults.standard.set(searchID, forKey: MemberInfoField.searchID.rawValue)
            UserDefaults.standard.set(email, forKey: MemberInfoField.email.rawValue)
            UserDefaults.standard.set(nickname, forKey: MemberInfoField.nickname.rawValue)
            self?.isExistedSearchID.onNext(true)
        }
    }
    
    func signupWithApple(_ signinWithAppleInfo: SigninWithAppleDomain) {
        setSignupWithAppleInfo(signinWithAppleInfo)
        memberService.setAppleMemberInfo(with: signinWithAppleInfo) {[weak self] result in
            self?.isSuccessedSignupWithApple.onNext(result)
        }
    }
    
    func updateSearchID(_ updateSearchIdInfo: UpdateSearchIdDomain) {
        memberService.updateSearchID(with: updateSearchIdInfo) { [weak self] result in
            self?.isSuccessedUpdatedSearchID.onNext(result)
        }
    }
    
    func signinWithEmail(_ email: String) {
        memberService.getEmailMemberInfo(with: email) {[weak self] emailMemberInfo in
            guard let email = emailMemberInfo.email,
                  !(email.isEmpty) else {
                self?.isExistedEmail.onNext(false)
                return }
            guard let _ = emailMemberInfo.userID,
                  let searchID = emailMemberInfo.searchID,
                  let nickname = emailMemberInfo.nickname,
                  let password = emailMemberInfo.password,
                  !(searchID.isEmpty),
                  !(nickname.isEmpty),
                  !(password.isEmpty) else { return }
            self?.emailMemberInformation = emailMemberInfo
            self?.isExistedEmail.onNext(true)
        }
    }
    
    func setUserDefaultsEmailMember() {
        guard let emailMemberInformation = emailMemberInformation else { return }
        UserDefaults.standard.set(emailMemberInformation.userID, forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.set(emailMemberInformation.password, forKey: MemberInfoField.password.rawValue)
        UserDefaults.standard.set(emailMemberInformation.searchID, forKey: MemberInfoField.searchID.rawValue)
        UserDefaults.standard.set(emailMemberInformation.email, forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.set(emailMemberInformation.nickname, forKey: MemberInfoField.nickname.rawValue)
    }
    
    func isPasswordMatching(_ inputPassword: String) {
        guard let password = emailMemberInformation?.password,
              !(password.isEmpty) else { return }
        isPasswordMatching.onNext(password == inputPassword)
    }
}
