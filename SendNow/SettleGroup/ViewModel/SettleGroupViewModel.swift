//
//  SettleGroupViewModel.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation
import RxSwift
import NotificationCenter

enum ExpenseDetailDefaultsKey: String {
    case groupID
    case expenseID
    case expenseClass
}

enum FailedError: Error {
    case faile
}

final class SettleGroupViewModel {
    private let groupService: GroupService
    private let userID: Int
    private(set) var expenseclassification: String?
    private(set) var groupID: Int?
    private(set) var expenseID: Int?
    private(set) var remainderUserID: Int?
    private(set) var groupExpenseInformations: ExpenseInformationDomain?
    private(set) var groupMemberInformations: [GroupMemberListDomain]?
    private(set) var expenseDetailInformation: ExpenseDetailInformationDomain?
    let isUploadedExpenseInfo = PublishSubject<Bool>()
    let isLoadedGroupMemberInfo = PublishSubject<Bool>()
    let isLoadedGroupExpenseInfo = PublishSubject<Bool>()
    let isEqualCreatorUserID = PublishSubject<Bool>()
    let isDeletedGroup = PublishSubject<Bool>()
    let loadedGroupExpenseDetailInfoSubject = PublishSubject<Void>()
    
    init(groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
    func setGroupID(_ groupID: Int) {
        self.groupID = groupID
    }
    
    func setExpenseID(_ expenseID: Int) {
        self.expenseID = expenseID
    }
    
    func selectExpenseClassification(_ classification: String) {
        expenseclassification = classification
    }
    
    func deselectExpenseClassification() {
        expenseclassification = nil
    }
    
    func selectRemainderAmountUser(userID: Int) {
        remainderUserID = userID
    }
    
    func loadGroupCreatorID() {
        guard let groupID = groupID else { return }
        groupService.getGroupCreatorUserID(with: groupID, userID: userID) {[weak self] isEqual in
            self?.isEqualCreatorUserID.onNext(isEqual)
        }
    }
    
    func uploadExpenseInformation(expenseclassification: String, expenseDetail: String, expenseAmount: String, expenseDate: Date, remainderUserID: Int) {
        guard let groupID = groupID,
              let amount = Int(expenseAmount) else { return }
        let date = expenseDate.dateToString()
        let expenseUploadDomain = ExpenseUploadDomain(
            groupID: groupID,
            userID: userID,
            expenseclassification: expenseclassification,
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
        print("loadGroupMemberInformation")
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
            guard let _ = result.expenseInformations else {
                self?.isLoadedGroupExpenseInfo.onNext(false)
                return 
            }
            self?.isLoadedGroupExpenseInfo.onNext(true)
        }
    }
    
    func loadExpenseDetailInformation(_ expenseID: Int) {
        groupService.getGroupExpenseDetailInformation(with: expenseID) {[weak self] detailInformation in
            self?.expenseDetailInformation = detailInformation
            self?.loadedGroupExpenseDetailInfoSubject.onNext(Void())
        }
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
