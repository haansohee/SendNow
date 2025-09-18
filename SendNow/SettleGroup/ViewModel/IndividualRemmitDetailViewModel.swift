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
        groupService.getGroupSettlementsInformations(with: groupID) {[weak self] getGroupSettlementsInfoResult in
            switch getGroupSettlementsInfoResult {
            case .success(let groupSettlementsInfoDomain):
                self?.groupSettlementInformations = groupSettlementsInfoDomain
                self?.isLoadedGroupSettlementInfo.onNext(Void())
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func loadCompletionRemittanceInformation() {
        guard let groupID = groupID else { return }
        groupService.getCompletedRemittanceInformation(with: groupID, userID: userID) {[weak self] getCompletedRemittanceInfoResult in
            switch getCompletedRemittanceInfoResult {
            case .success(let completedRemittanceInfoDomain):
                self?.remittanceInformations = completedRemittanceInfoDomain
                self?.isLoadedCompletionRemittanceInfo.onNext(Void())
            case .failure(let error):
                print("에러 수정 필요")
            }
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
