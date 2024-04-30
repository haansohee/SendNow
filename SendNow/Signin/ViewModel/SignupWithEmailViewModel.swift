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
    private(set) var isCheckedDuplicatedID: Bool = false
    private(set) var isCheckedAuthCode: Bool = false
    private(set) var isCheckedValidNickname: Bool = false
    private(set) var emailAuthCodeInfo: EmailAuthCodeDomain?
    let isDuplicatedID = PublishSubject<Bool>()
    let isDuplicatedEmail = PublishSubject<Bool>()
    let isCompletedSignup = PublishSubject<Bool>()
    
    func setIsEnabledSignupButton(_ isEnabledSignupButton: Bool) {
        self.isEnabledSignupButton = isEnabledSignupButton
    }
    
    func setIsCheckedDuplicatedID(_ isCheckedDuplicatedID: Bool) {
        self.isCheckedDuplicatedID = isCheckedDuplicatedID
    }
    
    func setIsCheckedAuthCode(_ isCheckedAuthCode: Bool) {
        self.isCheckedAuthCode = isCheckedAuthCode
    }
    
    func setIsCheckedValidNickname(_ isCheckedValiedNickname: Bool) {
        self.isCheckedValidNickname = isCheckedValiedNickname
    }
    
    func checkDuplicateID(nickname: String) {
        memberService.getSearchID(with: nickname) {[weak self] result in
            print("🚨 get Search ID RESULT : \(result)")
            self?.isDuplicatedID.onNext(result.isEmpty)
        }
    }
    
    func sendEmailAuthCode(email: String) {
        memberService.getEmailAuthCode(with: email) {[weak self] emailAuthCode in
            self?.emailAuthCodeInfo = emailAuthCode
            self?.isDuplicatedEmail.onNext(emailAuthCode.isDuplicated)
        }
    }
    
    func signupWithEmail(_ signinWithEmailInfo: SigninWithEmailDomain) {
        memberService.setEmailMemberInfo(with: signinWithEmailInfo) {[weak self] result in
            self?.isCompletedSignup.onNext(result)
        }
    }
}
