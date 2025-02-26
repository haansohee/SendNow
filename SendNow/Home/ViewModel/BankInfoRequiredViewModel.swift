//
//  BankInfoRequiredViewModel.swift
//  SendNow
//
//  Created by 한소희 on 2/26/25.
//

import Foundation
import RxSwift

enum BankInfoResponse: String {
    case networkError
    case noValue
    case success
}

final class BankInfoRequiredViewModel {
    private let memberService: MemberService
    private let userID: Int
    private(set) var bankInfoUpdatedSubject = BehaviorSubject<(BankInfoResponse)>(value: .networkError)
    
    init(with memberService: MemberService = MemberService(),
         userID: Int) {
        self.memberService = memberService
        self.userID = userID
    }
    
    func updateMemberBankInfo(bankName: String? = nil,
                              accountNumber: String? = nil,
                              kakaoPayURL: String? = nil) {
        if let bankName = bankName,
           let accountNumber = accountNumber,
           !bankName.isEmpty,
           !accountNumber.isEmpty {
            if let kakaoPayURL = kakaoPayURL,
                      !kakaoPayURL.isEmpty {
                let updateBankInformationDomain = UpdateBankInformationDomain(userID: userID,
                                                                              kakaoPayURL: kakaoPayURL,
                                                                              bankName: bankName,
                                                                              accountNumber: accountNumber)
                memberService.updateMemberBankInfo(with: updateBankInformationDomain) {[weak self] isUpdated in
                    if isUpdated {
                        UserDefaults.standard.set(bankName, forKey: MemberInfoField.bankName.rawValue)
                        UserDefaults.standard.set(accountNumber, forKey: MemberInfoField.accountNumber.rawValue)
                        UserDefaults.standard.set(kakaoPayURL, forKey: MemberInfoField.kakaoPayUrl.rawValue)
                    }
                    self?.bankInfoUpdatedSubject.onNext(isUpdated ? .success : .networkError)
                    
                }
            }
            let updateAccountNumberDomain = UpdateAccountNumberDomain(userID: userID, bankName: bankName, accountNumber: accountNumber)
            memberService.updateAccountNumber(with: updateAccountNumberDomain) {[weak self] isUpdated in
                if isUpdated {
                    UserDefaults.standard.set(bankName, forKey: MemberInfoField.bankName.rawValue)
                    UserDefaults.standard.set(accountNumber, forKey: MemberInfoField.accountNumber.rawValue)
                }
                self?.bankInfoUpdatedSubject.onNext(isUpdated ? .success : .networkError)
            }
        } else if let kakaoPayURL = kakaoPayURL,
                  !kakaoPayURL.isEmpty {
            let updateKakaoPayUrlDomain = UpdateKakaoPayUrlDomain(userID: userID, kakaoPayUrl: kakaoPayURL)
            memberService.updateKakaoPayUrl(with: updateKakaoPayUrlDomain) {[weak self] isUpdated in
                if isUpdated {
                    UserDefaults.standard.set(kakaoPayURL, forKey: MemberInfoField.kakaoPayUrl.rawValue)
                }
                self?.bankInfoUpdatedSubject.onNext(isUpdated ? .success : .networkError)
            }
        } else {
            bankInfoUpdatedSubject.onNext(.noValue)
        }
    }
}
