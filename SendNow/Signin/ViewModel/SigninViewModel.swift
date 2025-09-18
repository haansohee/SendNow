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
            }
            guard let fcmToken = token else {
                print("FCM Token is nil...")
                return }
            UserDefaults.standard.set(fcmToken, forKey: MemberInfoField.fcmToken.rawValue)
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
        memberService.getKakaoMemberInfo(with: kakaoToken) { [weak self] getKakaoMemberInfoResult in
            switch getKakaoMemberInfoResult {
            case .success(let kakaoMemberInfo):
                guard let kakaoToken = kakaoMemberInfo.kakaoToken,
                      let email = kakaoMemberInfo.email,
                      let userID = kakaoMemberInfo.userID,
                      let kakaoID = kakaoMemberInfo.kakaoID,
                      !kakaoToken.isEmpty,
                      !email.isEmpty else {
                    self?.signupWithKakao()
                    return
                }
                
                guard let nickname = kakaoMemberInfo.nickname,
                      !(nickname.isEmpty) else {
                    let kakaoMemberInformation = KakaoMemberDomain(
                        userID: userID,
                        nickname: "",
                        email: email,
                        kakaoToken: kakaoToken,
                        kakaoID: kakaoID,
                        bankName: kakaoMemberInfo.bankName ?? "",
                        accountNumber: kakaoMemberInfo.accountNumber ?? "",
                        kakaoPayUrl: kakaoMemberInfo.kakaoPayUrl ?? ""
                    )
                    self?.setUserDefaultsKakaoMember(kakaoMemberInformation)
                    self?.isSuccessSignin.onNext(false)
                    return
                }

                let kakaoMemberInformation = KakaoMemberDomain(
                    userID: userID,
                    nickname: nickname,
                    email: email,
                    kakaoToken: kakaoToken,
                    kakaoID: kakaoID,
                    bankName: kakaoMemberInfo.bankName ?? "",
                    accountNumber: kakaoMemberInfo.accountNumber ?? "",
                    kakaoPayUrl: kakaoMemberInfo.kakaoPayUrl ?? ""
                )
                self?.setUserDefaultsKakaoMember(kakaoMemberInformation)
                self?.isSuccessSignin.onNext(true)
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func signupWithKakao() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                guard let accessToken = UserDefaults.standard.string(forKey: MemberInfoField.kakaoToken.rawValue),
                      let kakaoID = user.id,
                      let email = user.kakaoAccount?.email as? String else { return }
                let signinWithKakaoDomain = SigninWithKakaoDomain(
                    nickname: "",
                    email: email,
                    kakaoToken: accessToken,
                    kakaoID: kakaoID,
                    isSetNoti: self?.isSetNoti ?? false,
                    fcmToken: self?.fcmToken ?? ""
                )
                let signinWithKakaoRequestDTO = SigninWithKakaoRequestDTO(
                    nickname: signinWithKakaoDomain.nickname,
                    email: signinWithKakaoDomain.email,
                    kakaoToken: signinWithKakaoDomain.kakaoToken,
                    kakaoID: signinWithKakaoDomain.kakaoID,
                    isSetNoti: signinWithKakaoDomain.isSetNoti,
                    fcmToken: signinWithKakaoDomain.fcmToken
                )
                self?.memberService.setKakaoMemberInfo(with: signinWithKakaoRequestDTO) { result in
                    guard result else { return }
                    self?.checkRegisteredKakaoMember(accessToken)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signinWithApple(_ appleToken: String, _ authorizationCode: String) {
        memberService.getAppleMemberInfo(with: appleToken) {[weak self] getAppleMemberInfoResult in
            switch getAppleMemberInfoResult {
            case .success(let appleMemberInfo):
                guard let appleToken = appleMemberInfo.appleToken,
                      let email = appleMemberInfo.email,
                      let userID = appleMemberInfo.userID,
                      !(appleToken.isEmpty),
                      !(email.isEmpty) else {
                    let signupWithAppleInfo = SigninWithAppleDomain(
                        nickname: "",
                        appleToken: appleToken,
                        authorizationCode: authorizationCode,
                        isSetNoti: self?.isSetNoti ?? false,
                        fcmToken: self?.fcmToken ?? ""
                    )
                    self?.signupWithApple(signupWithAppleInfo)
                    return }
                
                guard let nickname = appleMemberInfo.nickname,
                      !(nickname.isEmpty) else {
                    let appleMemberInformation = AppleMemberDomain(
                        userID: userID,
                        nickname: "",
                        email: email,
                        appleToken: appleToken,
                        bankName: appleMemberInfo.bankName ?? "",
                        accountNumber: appleMemberInfo.accountNumber ?? "",
                        kakaoPayUrl: appleMemberInfo.kakaoPayUrl ?? ""
                    )
                    self?.setUserDefaultsAppleMember(appleMemberInformation: appleMemberInformation)
                    self?.isSuccessSignin.onNext(false)
                    return
                }
                
                let appleMemberInformation = AppleMemberDomain(
                    userID: userID,
                    nickname: nickname,
                    email: email,
                    appleToken: appleToken,
                    bankName: appleMemberInfo.bankName ?? "",
                    accountNumber: appleMemberInfo.accountNumber ?? "",
                    kakaoPayUrl: appleMemberInfo.kakaoPayUrl ?? ""
                )
                self?.setUserDefaultsAppleMember(appleMemberInformation: appleMemberInformation)
                self?.isSuccessSignin.onNext(true)
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func signupWithApple(_ signinWithAppleInfo: SigninWithAppleDomain) {
        let signinWithAppleInfoReqeustDTO = SigninWithAppleRequestDTO(
            nickname: signinWithAppleInfo.nickname,
            appleToken: signinWithAppleInfo.appleToken,
            authorizationCode: signinWithAppleInfo.authorizationCode,
            isSetNoti: signinWithAppleInfo.isSetNoti,
            fcmToken: signinWithAppleInfo.fcmToken
        )
        memberService.setAppleMemberInfo(with: signinWithAppleInfoReqeustDTO) {[weak self] result in
            guard result else { return }
            self?.signinWithApple(signinWithAppleInfo.appleToken, signinWithAppleInfo.authorizationCode)
        }
    }
    
    func updateNickname(_ nickname: String) {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        let updateNicknameInfo = UpdateNicknameDomain(
            userID: userID,
            nickname: nickname
        )
        let updateNicknameInfoRequestDTO = UpdateNicknameRequestDTO(
            userID: updateNicknameInfo.userID,
            nickname: updateNicknameInfo.nickname
        )
        memberService.updateNickname(with: updateNicknameInfoRequestDTO) { [weak self] result in
            if result {
                UserDefaults.standard.set(nickname, forKey: MemberInfoField.nickname.rawValue)
            }
            self?.isSuccessedUpdatedNickname.onNext(result)
        }
    }
    
    func isValidEmailPassword(_ email: String, _ password: String) {
        let validationInformation = ValidationEmailPasswordDomain(
            email: email,
            password: password
        )
        let validationInfoRequestDTO = ValidationEmailPasswordRequestDTO(
            email: validationInformation.email,
            password: validationInformation.password
        )
        memberService.isValidEmailPassword(with: validationInfoRequestDTO) {[weak self] isValid in
            self?.isValidEmailPassword.onNext(isValid)
            guard isValid else { return }
            self?.signinWithEmail(email)
        }
        
    }
    
    func signinWithEmail(_ email: String) {
        memberService.getEmailMemberInfo(with: email) {[weak self] getEmailMemberInfoResult in
            switch getEmailMemberInfoResult {
            case .success(let emailMemberInfo):
                guard let userID = emailMemberInfo.userID,
                      let nickname = emailMemberInfo.nickname,
                      let password = emailMemberInfo.password,
                      !(nickname.isEmpty),
                      !(password.isEmpty) else { return }
                let emailMemberInformation = EmailMemberDomain(userID: userID, nickname: nickname, email: email, password: password, bankName: emailMemberInfo.bankName ?? "", accountNumber: emailMemberInfo.accountNumber ?? "", kakaoPayUrl: emailMemberInfo.kakaoPayUrl ?? "")
                self?.setUserDefaultsEmailMember(emailMemberInformation)
                self?.isSuccessSignin.onNext(true)
            case .failure(let error):
                print("에러 수정 필요")
            }
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
