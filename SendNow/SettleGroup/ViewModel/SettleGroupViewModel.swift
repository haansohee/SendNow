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
    private(set) var expenseClassfication: String?
    private(set) var groupID: Int?
    private(set) var expenseID: Int?
    private(set) var remainderUserID: Int?
    private(set) var expenseDate: Date?
    private(set) var expenseDetails: String?
    private(set) var groupExpenseInformations: ExpenseInformationDomain?
    private(set) var groupMemberInformations: [GroupMemberListDomain]?
    private(set) var expenseDetailInformation: ExpenseDetailInformationDomain?
    private(set) var canSelectItems: Bool?
    let isUploadedExpenseInfo = PublishSubject<Bool>()
    let isLoadedGroupMemberInfo = PublishSubject<Bool>()
    let groupExpenseInfoSubject = PublishSubject<(String, String)>()
    let isEqualGroupCreatorSubject = PublishSubject<Bool>()
    let isEqualSettlementCreatorSubject = PublishSubject<Bool>()
    let isDeletedGroup = PublishSubject<Bool>()
    let isDeletedSpendingDetailInfoSubject = PublishSubject<Bool>()
    let loadedGroupExpenseDetailInfoSubject = PublishSubject<Void>()
    let isUpdatedSpendingDetailInfoSubject = PublishSubject<Bool>()
    
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
    
    func setExpenseDate(_ stringDate: String) {
        let date = stringDate.stringToDate()
        self.expenseDate = date
    }
    
    func setExpenseDetails(_ expenseDetails: String) {
        self.expenseDetails = expenseDetails
    }
    
    func selectExpenseClassfication(_ classfication: String) {
        expenseClassfication = classfication
    }
    
    func deselectexpenseClassfication() {
        expenseClassfication = nil
    }
    
    func selectRemainderAmountUser(_ userID: Int) {
        remainderUserID = userID
    }
    
    func setCanSelectItems(_ canSelectItems: Bool) {
        self.canSelectItems = canSelectItems
    }
    
    func loadGroupCreatorID() {
        guard let groupID = self.groupID else { return }
        groupService.getGroupCreatorUserID(with: groupID, userID: userID) {[weak self] isEqual in
            self?.isEqualGroupCreatorSubject.onNext(isEqual)
        }
    }
    
    func loadSettlementCreatorID() {
        guard let groupID = self.groupID,
              let expenseID = self.expenseID else { return }
        groupService.getSettlementCreatorID(with: expenseID, groupID: groupID, userID: userID) {[weak self] isEqual in
            self?.isEqualSettlementCreatorSubject.onNext(isEqual)
        }
    }
    
    func uploadExpenseInformation(expenseClassfication: String, expenseDetail: String, expenseAmount: String, expenseDate: Date) {
        guard let groupID = groupID,
              let amount = Int(expenseAmount) else { return }
        let date = expenseDate.dateToString()
        let expenseUploadDomain = ExpenseUploadDomain(
            groupID: groupID,
            userID: userID,
            expenseClassfication: expenseClassfication,
            expenseDetail: expenseDetail,
            expenseAmount: amount,
            expenseDate: date)
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
        print("load group expense information")
        guard let groupID = groupID else { return }
        print("groupID: \(groupID)")
        print("!! userID: \(userID)")
        groupService.getGroupExpenseInformations(with: userID, groupID: groupID) {[weak self] result in
            self?.groupExpenseInformations = result
            guard let groupExpenses = result.groupExpenses,
                  let myExpenses = result.myExpenses else {
                self?.groupExpenseInfoSubject.onNext(("0", "0"))
                return }
            print("group expense: \(groupExpenses)")
            print("my total expense: \(myExpenses)")
            self?.groupExpenseInfoSubject.onNext((groupExpenses, myExpenses))
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
    
    func deleteSpendingDetailInformation(expenseID: Int, groupID: Int) {
        let spendingDetailInfo = DeleteSpendingDetailInformationDomain(expenseID: expenseID, groupID: groupID)
        groupService.deleteSpendingDetailInformation(with: spendingDetailInfo) {[weak self] isDeleted in
            self?.isDeletedSpendingDetailInfoSubject.onNext(isDeleted)
        }
    }
    
    func updateSpendingDetailInformation(
        expensClassfication: String,
        expenseDetails: String,
        expenseAmount: String,
        expenseDate: Date
    ) {
        let expenseDateText = expenseDate.dateToString()
        let expenseAmontText = Int(expenseAmount) ?? 0
        guard let groupID = self.groupID,
              let expenseID = self.expenseID else {
            return }
        let spendingDetailInformation = UpdateSpendingDetailInformationDomain(groupID: groupID, expenseID: expenseID, expenseClassfication: expensClassfication, expenseDetails: expenseDetails, expenseAmount: expenseAmontText, expenseDate: expenseDateText)
        groupService.updateSpendingDetailInformation(with: spendingDetailInformation) {[weak self] isUpdated in
            self?.isUpdatedSpendingDetailInfoSubject.onNext(isUpdated)
        }
    }
}
