//
//  IndividualRemmitDetailViewModel.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import Foundation
import RxSwift
import UIKit

enum TransactionRole {
    case receiver
    case sender
    case zero
    case error
}

final class IndividualRemmitDetailViewModel {
    let userID: Int
    private let groupService: GroupService
    private let notificationService = NotificationService()
    private(set) var groupID: Int?
    private(set) var groupSettlementInformations: SettlementListDomain?
    private(set) var remittanceInformations: [CompletionRemittanceDomain]?
    let isLoadedGroupSettlementInfo = PublishSubject<Void>()
    let isLoadedCompletionRemittanceInfo = PublishSubject<Void>()
    
    init(with groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
    
    func setGroupID(_ groupID: Int) {
        self.groupID = groupID
    }
    
    func loadGroupSettlementInforamtion() {
        guard let groupID = groupID else { return }
        groupService.getGroupSettlementsInformations(with: groupID) {[weak self] result in
            let settlementDetailInfoDomain: [SettlementDetailsDomain] = result.settlementDetails.map {
                SettlementDetailsDomain(
                    settlementID: $0.settlementID,
                    groupID: $0.groupID,
                    fromUserID: $0.fromUserID,
                    toUserID: $0.toUserID,
                    fromNickname: $0.fromNickname,
                    toNickname: $0.toNickname,
                    amount: $0.amount,
                    bankName: $0.bankName,
                    accountNumber: $0.accountNumber,
                    kakaoPayURL: $0.kakaoPayURL
                )
            }
            let settlementBalanceDomain: [SettlementBalanceDomain] = result.settlementBalance.map {
                SettlementBalanceDomain(
                    userID: $0.userID,
                    nickname: $0.nickname,
                    sendAmount: $0.sendAmount,
                    receiveAmount: $0.receiveAmount
                )
            }
            let settlementListDomain = SettlementListDomain(
                settlementDetails: settlementDetailInfoDomain,
                settlementBalance: settlementBalanceDomain)
            self?.groupSettlementInformations = settlementListDomain
            self?.isLoadedGroupSettlementInfo.onNext(Void())
        }
    }
    
    func loadCompletionRemittanceInformation() {
        guard let groupID = groupID else { return }
        groupService.getCompletedRemittanceInformation(with: groupID, userID: userID) {[weak self] remittanceInfo in
            let completionRemittanceDomain: [CompletionRemittanceDomain] = remittanceInfo.map {
                CompletionRemittanceDomain(
                    settlementID: $0.settlementID,
                    receiverNickname: $0.receiverNickname,
                    amount: $0.amount,
                    isCompletedRemittance: $0.isCompletedRemittance
                )
            }
            self?.remittanceInformations = completionRemittanceDomain
            self?.isLoadedCompletionRemittanceInfo.onNext(Void())
        }
    }
    
    func setCompletedRemittance(_ remittanceInfo: RemittanceStatusDomain, completion: @escaping(Bool)->Void) {
        let remittanceInfoRequestDTO = RemittanceStatusRequestDTO(
            settlementID: remittanceInfo.settlementID,
            isCompletedRemittance: remittanceInfo.isCompletedRemittance
        )
        groupService.setCompletedRemittance(with: remittanceInfoRequestDTO) {[weak self] isUpdatedRemittance in
            guard isUpdatedRemittance else { return }
            self?.loadCompletionRemittanceInformation()
            completion(isUpdatedRemittance)
        }
    }
    
    func compareUserID(fromUserID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        return fromUserID == userID
    }
    
    func sendRemittanceNotification(settlementID: Int) {
        notificationService.sendRemittanceNotification(with: settlementID) { _ in }
    }
    
    func parseFormattednumberSimple(_ amount: String) -> Int {
        let cleanNumber = amount.replacingOccurrences(of: ",", with: "")
        guard let cleanNumberToInt = Int(cleanNumber) else { return 0 }
        return Int(cleanNumberToInt)
    }
    
    func comparedAmount(_ balanceInformation: SettlementBalanceDomain) -> TransactionRole {
        guard let receiveAmount = balanceInformation.receiveAmount,
              let sendAmount = balanceInformation.sendAmount else { return TransactionRole.error }
        let receiveAmountInt = parseFormattednumberSimple(receiveAmount)
        let sendAmountInt = parseFormattednumberSimple(sendAmount)
        if receiveAmountInt > 0 {
            return TransactionRole.receiver
        } else if sendAmountInt < 0 {
            return TransactionRole.sender
        } else {
            return TransactionRole.zero
        }
    }
}
