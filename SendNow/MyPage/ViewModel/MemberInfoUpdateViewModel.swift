//
//  MemberInfoUpdateViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation
import RxSwift

final class MemberInfoUpdateViewModel {
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    private let memberService = MemberService()
    let isUpdatedNickname = PublishSubject<Bool>()
    let isUpdatedAccountNumber = PublishSubject<Bool>()
    let isUpdatedKakaoPayUrl = PublishSubject<Bool>()
    
    func updateNickname(updateNickname: String) {
        let updateNicknameDomain = UpdateNicknameDomain(userID: userID, nickname: updateNickname)
        memberService.updateNickname(with: updateNicknameDomain) {[weak self] result in
            self?.isUpdatedNickname.onNext(result)
            guard result else { return }
            UserDefaults.standard.set(updateNickname, forKey: MemberInfoField.nickname.rawValue)
        }
    }
    
    func updateAccountNumber(bankName: String, accountNumber: String) {
        let updateAccountNumberDomain = UpdateAccountNumberDomain(userID: userID, bankName: bankName, accountNumber: accountNumber)
        memberService.updateAccountNumber(with: updateAccountNumberDomain) {[weak self] result in
            self?.isUpdatedAccountNumber.onNext(result)
            guard result else { return }
            UserDefaults.standard.set(bankName, forKey: MemberInfoField.bankName.rawValue)
            UserDefaults.standard.set(accountNumber, forKey: MemberInfoField.accountNumber.rawValue)
        }
    }
    
    func updateKakaoPayUrl(kakaoPayUrl: String) {
        let updateKakaoPayUrlDomain = UpdateKakaoPayUrlDomain(userID: userID, kakaoPayUrl: kakaoPayUrl)
        memberService.updateKakaoPayUrl(with: updateKakaoPayUrlDomain) {[weak self] result in
            self?.isUpdatedKakaoPayUrl.onNext(result)
            guard result else { return }
            UserDefaults.standard.set(kakaoPayUrl, forKey: MemberInfoField.kakaoPayUrl.rawValue)
        }
    }
}
