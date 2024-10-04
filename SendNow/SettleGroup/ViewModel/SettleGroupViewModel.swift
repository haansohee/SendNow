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
    private let groupService: GroupService
    private let userID: Int
    private(set) var expenseClassfication: String?
    private(set) var groupID: Int?
    private(set) var remainderUserID: Int?
    private(set) var groupExpenseInformations: ExpenseInformationDomain?
    private(set) var groupMemberInformations: [GroupMemberListDomain]?
    let isUploadedExpenseInfo = PublishSubject<Bool>()
    let isLoadedGroupMemberInfo = PublishSubject<Bool>()
    let isLoadedGroupExpenseInfo = PublishSubject<Bool>()
    let isEqualCreatorUserID = PublishSubject<Bool>()
    let isDeletedGroup = PublishSubject<Bool>()
    
    init(groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
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
            self?.isEqualCreatorUserID.onNext(isEqual)
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
