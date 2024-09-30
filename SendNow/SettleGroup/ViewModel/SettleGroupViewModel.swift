//
//  SettleGroupViewModel.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation
import RxSwift
import NotificationCenter

enum FailedError: Error {
    case faile
}

final class SettleGroupViewModel {
    private let groupService = GroupService()
    private let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
    private(set) var expenseClassfication: String?
    private(set) var groupID: Int?
    private(set) var remainderUserID: Int?
    private(set) var groupExpenseInformations: ExpenseInformationDomain?
    private(set) var groupMemberInformations: [GroupMemberListDomain]?
    private(set) var groupSettlementInformations: SettlementListDomain?
    let isUploadedExpenseInfo = PublishSubject<Bool>()
    let isLoadedGroupMemberInfo = PublishSubject<Bool>()
    let isLoadedGroupExpenseInfo = PublishSubject<Bool>()
    let isLoadedGroupSettlementInfo = PublishSubject<Bool>()
    let isEqualCreatorUserID = PublishSubject<Bool>()
    let isDeletedGroup = PublishSubject<Bool>()
    
    func setGroupID(_ groupID: Int) {
        self.groupID = groupID
    }
    
    func selectExpenseClassfication(_ classfication: String) {
        expenseClassfication = classfication
    }
    
    func deselectExpenseClassfication() {
        expenseClassfication = nil
    }
    
    func selectRemainderAmountUser(userID: Int) {
        remainderUserID = userID
    }
    
    func loadGroupCreatorID() {
        guard let groupID = groupID else { return }
        groupService.getGroupCreatorUserID(with: groupID, userID: userID) {[weak self] isEqual in
            if isEqual {
                self?.isEqualCreatorUserID.onNext(isEqual)
            } else {
                self?.isEqualCreatorUserID.onError(FailedError.faile)
            }
        }
    }
    
    func uploadExpenseInformation(expenseClassfication: String, expenseDetail: String, expenseAmount: String, expenseDate: Date, remainderUserID: Int) {
        guard let groupID = groupID,
              let amount = Int(expenseAmount) else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        let date = dateFormatter.string(from: expenseDate)
        let expenseUploadDomain = ExpenseUploadDomain(
            groupID: groupID,
            userID: userID,
            expenseClassfication: expenseClassfication,
            expenseDetail: expenseDetail,
            expenseAmount: amount,
            expenseDate: date,
            remainderUserID: remainderUserID)
        groupService.setExpensesUpload(with: expenseUploadDomain) {[weak self] result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.uploadExpense.rawValue), object: result)
            }
            self?.isUploadedExpenseInfo.onNext(result)
        }
    }
    
    func loadGroupMemberInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupMemberList(with: groupID) {[weak self] result in
            self?.groupMemberInformations = result
            self?.isLoadedGroupMemberInfo.onNext(!result.isEmpty)
        }
    }
    
    func loadGroupExpenseInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupExpenseInformations(with: userID, groupID: groupID) {[weak self] result in
            self?.groupExpenseInformations = result
            guard let information = result.expenseInformations else {
                self?.isLoadedGroupExpenseInfo.onNext(false)
                return 
            }
            self?.isLoadedGroupExpenseInfo.onNext(true)
        }
    }
    
    func loadGroupSettlementInforamtion() {
        guard let groupID = groupID else { return }
        groupService.getGroupSettlementsInformations(with: groupID) {[weak self] result in
            self?.groupSettlementInformations = result
            guard !result.settlementDetails.isEmpty,
                  !result.settlementBalance.isEmpty else {
                self?.isLoadedGroupSettlementInfo.onNext(false)
                return
            }
            self?.isLoadedGroupSettlementInfo.onNext(true)
        }
    }
    
    func compareUserID(fromUserID: Int) -> Bool {
        let userID = UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)
        return fromUserID == userID
    }
    
    func deleteGroup() {
        guard let groupID = self.groupID else {
            isDeletedGroup.onError(FailedError.faile)
            return }
        groupService.deleteGroup(with: groupID) {[weak self] isDeleted in
            if isDeleted {
                self?.isDeletedGroup.onNext(isDeleted)
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.deleteGroup.rawValue), object: isDeleted)
            } else {
                self?.isDeletedGroup.onError(FailedError.faile)
            }
        }
    }
}
