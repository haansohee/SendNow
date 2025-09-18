//
//  SignupWithEmailViewModel.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit
import RxSwift

final class SignupWithEmailViewModel {
    private let memberService = MemberService()
    private(set) var isEnabledSignupButton: Bool = false
    private(set) var isCheckedValidNickname: Bool = false
    private(set) var isCheckedAuthCode: Bool = false
    private(set) var emailAuthCodeInfo: EmailAuthCodeDomain?
    let isDuplicatedNickname = PublishSubject<Bool>()
    let isDuplicatedEmail = PublishSubject<Bool>()
    let isCompletedSignup = PublishSubject<Bool>()
    
    func setIsEnabledSignupButton(_ isEnabledSignupButton: Bool) {
        self.isEnabledSignupButton = isEnabledSignupButton
    }
    
    func setIsDuplicatedNickname(_ isCheckedValidNickname: Bool) {
        self.isCheckedValidNickname = isCheckedValidNickname
    }
    
    func setIsCheckedAuthCode(_ isCheckedAuthCode: Bool) {
        self.isCheckedAuthCode = isCheckedAuthCode
    }
    
    func isDuplicatedNickname(nickname: String) {
        let nicknameDuplicateInfo = UpdateNicknameDomain(
            userID: 0,
            nickname: nickname
        )
        let nicknameDuplicateInfoRequestDTO = UpdateNicknameRequestDTO(
            userID: nicknameDuplicateInfo.userID,
            nickname: nicknameDuplicateInfo.nickname
        )
        memberService.isDuplicatedNickname(with: nicknameDuplicateInfoRequestDTO) {[weak self] result in
            self?.isDuplicatedNickname.onNext(result)
        }
    }
    
    func sendEmailAuthCode(email: String) {
        memberService.getEmailAuthCode(with: email) {[weak self] getEmailAuthCodeResult in
            switch getEmailAuthCodeResult {
            case .success(let emailAuthCode):
                let emailAuthCodeDomain = EmailAuthCodeDomain(isDuplicated: emailAuthCode.isDuplicated, authCode: emailAuthCode.authCode)
                self?.emailAuthCodeInfo = emailAuthCodeDomain
                self?.isDuplicatedEmail.onNext(emailAuthCode.isDuplicated)
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func signupWithEmail(_ signinWithEmailInfo: SigninWithEmailDomain) {
        let signinWithEmailInfoRequestDTO = SigninWithEmailRequestDTO(
            nickname: signinWithEmailInfo.nickname,
            email: signinWithEmailInfo.email,
            password: signinWithEmailInfo.password,
            isSetNoti: signinWithEmailInfo.isSetNoti,
            fcmToken: signinWithEmailInfo.fcmToken
        )
        memberService.setEmailMemberInfo(with: signinWithEmailInfoRequestDTO) {[weak self] result in
            self?.isCompletedSignup.onNext(result)
        }
    }
}
