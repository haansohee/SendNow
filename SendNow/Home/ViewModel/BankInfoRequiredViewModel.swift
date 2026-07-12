//
//  BankInfoRequiredViewModel.swift
//  SendNow
//
//  Created by 한소희 on 2/26/25.
//

import Foundation
import RxSwift

final class BankInfoRequiredViewModel {
    private let memberService: MemberService
    private let userID: Int
    let isUpdatedKakaoPayUrlSubject = PublishSubject<Bool>()
    let isUpdatedKakaoPayUrlDismissedSubject = PublishSubject<Bool>()
    
    init(with memberService: MemberService = MemberService(),
         userID: Int) {
        self.memberService = memberService
        self.userID = userID
    }
    
    func updateKakaoPayURL(_ kakaoPayURL: String) {
        let updateKakaoPayUrlDomain = UpdateKakaoPayUrlInformation(
            userID: userID,
            kakaoPayUrl: kakaoPayURL
        )
        let updateKakaoPayUrlRequestDTO = UpdateKakaoPayUrlRequestDTO(
            userID: updateKakaoPayUrlDomain.userID,
            kakaoPayUrl: updateKakaoPayUrlDomain.kakaoPayUrl
        )
        memberService.updateKakaoPayUrl(with: updateKakaoPayUrlRequestDTO) {[weak self] updateKakaoPayUrlResult, statuscode in
            self?.isUpdatedKakaoPayUrlSubject.onNext(updateKakaoPayUrlResult)
        }
    }
    
    func updateKakaoPayUrlDismissed() {
        let updateKakaoPayUrlRequestDTO = UpdateKakaoPayDismissedRequestDTO(userID: userID, isDismissed: true)
        memberService.updateKakaoPayUrlDismissed(with: updateKakaoPayUrlRequestDTO) {[weak self] updateKakaoPayDismissedResult, _ in
            UserDefaults.standard.set(updateKakaoPayDismissedResult, forKey: MemberInfoField.isDismissed.rawValue)
            self?.isUpdatedKakaoPayUrlDismissedSubject.onNext(updateKakaoPayDismissedResult)
        }
    }
}
