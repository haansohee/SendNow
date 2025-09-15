//
//  MemberInfoUpdateViewModel.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation
import RxSwift
import UserNotifications
import RxKakaoSDKUser
import KakaoSDKUser


final class MemberInfoUpdateViewModel {
    private let userID: Int
    private let signinType: SigninType
    private let memberService: MemberService
    private let disposeBag = DisposeBag()
    private var newAppleToken: String?
    let isDuplicatedNickname = PublishSubject<Bool>()
    let isUpdatedNickname = PublishSubject<Bool>()
    let isUpdatedAccountNumber = PublishSubject<Bool>()
    let isUpdatedKakaoPayUrl = PublishSubject<Bool>()
    let isCanceledAccount = PublishSubject<Bool>()
    let myPageItems = ["정보 수정하기 >", "개인정보처리방침 >"]
    
    init(with memberService: MemberService = MemberService(),
         userID: Int,
         signinType: SigninType) {
        self.memberService = memberService
        self.userID = userID
        self.signinType = signinType
    }
    
    func isDuplicatedNickname(_ inputNickname: String) {
        let updateNicknameInfo = UpdateNicknameDomain(userID: userID, nickname: inputNickname)
        memberService.isDuplicatedNickname(with: updateNicknameInfo) {[weak self] isDuplicated in
            self?.isDuplicatedNickname.onNext(isDuplicated)
        }
    }
    
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
    
    func cancelAccount() {
        switch signinType {
        case .email:
            cancelAccountService()
        case .kakao:
            UserApi.shared.rx.unlink()
                .subscribe(onCompleted: {[weak self] in
                    self?.cancelAccountService()
                }, onError: {[weak self] error in
                    self?.isCanceledAccount.onNext(false)
                    print("kakao unlink error : \(error.localizedDescription)")
                    return
                })
                .disposed(by: disposeBag)
        case .apple:
            memberService.revokeAppleToken(with: CancelAccountDomain(userID: userID)) {[weak self] isRevoked in
                guard isRevoked else {
                    self?.isCanceledAccount.onNext(false)
                    return }
                self?.cancelAccountService()
            }
        case .default:
            isCanceledAccount.onNext(false)
            return
        }
    }
    
    private func cancelAccountService() {
        memberService.cancelAccount(with: CancelAccountDomain(userID: userID)) {[weak self] isCanceledAccount in
            self?.isCanceledAccount.onNext(isCanceledAccount)
            guard isCanceledAccount else { return }
            self?.removeUserDefatulsData()
        }
    }
    
    func removeUserDefatulsData() {
        UserDefaults.standard.removeObject(forKey: MemberInfoField.userID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.nickname.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.email.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.password.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoToken.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.appleToken.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoID.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.signinType.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.bankName.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.accountNumber.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.kakaoPayUrl.rawValue)
        UserDefaults.standard.removeObject(forKey: MemberInfoField.notificationBadge.rawValue)
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}
