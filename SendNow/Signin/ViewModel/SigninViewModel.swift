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


final class SigninViewModel {
    private let disposeBag = DisposeBag()
    private let memberService = MemberService()
    private(set) var kakaoAccessToken: String?
    private(set) var kakaoMemberInformation: KakaoMemberDomain?
    let isSuccessedSigninWithKakao = PublishSubject<Bool>()
    let isSuccessedSignupWithKakao = PublishSubject<Bool>()
    let isRegisteredKakaoMember = PublishSubject<Bool>()
    
    func signinWithKakao() {
        guard UserApi.isKakaoTalkLoginAvailable() else { return }
        UserApi.shared.rx.loginWithKakaoTalk()
            .subscribe(onNext: { [weak self] oauthToken in
                guard let kakaoToken = oauthToken.idToken else { return }
                UserDefaults.standard.set(kakaoToken, forKey: "kakaoToken")
                self?.checkRegisteredKakaoMember(kakaoToken)
            })
            .disposed(by: disposeBag)
    }
    
    func checkRegisteredKakaoMember(_ kakaoToken: String) {
        memberService.getKakaoMemberInfo(with: kakaoToken) { [weak self] kakaoMemberInfo in
            guard let kakaoToken = kakaoMemberInfo.kakaoToken,
                  let searchID = kakaoMemberInfo.searchID,
                  let email = kakaoMemberInfo.email,
                  let nickname = kakaoMemberInfo.nickname else {
                self?.isRegisteredKakaoMember.onNext(true)
                return
            }
            guard !kakaoToken.isEmpty,
                  !searchID.isEmpty,
                  !email.isEmpty,
                  !nickname.isEmpty else {
                self?.isRegisteredKakaoMember.onNext(true)
                return }
            UserDefaults.standard.set(kakaoToken, forKey: "kakaoToken")
            UserDefaults.standard.set(searchID, forKey: "searchID")
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(nickname, forKey: "nickname")
            self?.isRegisteredKakaoMember.onNext(false)
        }
    }
    
    func signupWithKakao(id: String) {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { [weak self] user in
                guard let accessToken = UserDefaults.standard.string(forKey: "kakaoToken"),
                      let nickname = user.kakaoAccount?.profile?.nickname as? String,
                      let email = user.kakaoAccount?.email as? String else { return }
                let signinWithKakaoDomain = SigninWithKakaoDomain(searchID: id, nickname: nickname, email: email, kakaoToken: accessToken)
                self?.memberService.setKakaoMemberInfo(with: signinWithKakaoDomain) { result in
                    self?.isSuccessedSignupWithKakao.onNext(result)
                }
            })
            .disposed(by: disposeBag)
    }
}
