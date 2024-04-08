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
    private(set) var isEnabledSignupButton: Bool?
    let isDuplicatedID = PublishSubject<Bool>()
    
    func setIsEnabledSignupButton(_ isEnabledSignupButton: Bool) {
        self.isEnabledSignupButton = isEnabledSignupButton
    }
    
    func checkDuplicateID(nickname: String) {
        memberService.getSearchID(with: nickname) {[weak self] result in
            self?.isDuplicatedID.onNext(!result.isEmpty)
        }
    }
}
