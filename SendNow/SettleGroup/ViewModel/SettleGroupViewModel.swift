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
            expenseDate: date
        )
        let expenseUploadRequestDTO = ExpenseUploadRequestDTO(
            groupID: expenseUploadDomain.groupID,
            userID: expenseUploadDomain.userID,
            expenseClassfication: expenseUploadDomain.expenseClassfication,
            expenseDetail: expenseUploadDomain.expenseDetail,
            expenseAmount: expenseUploadDomain.expenseAmount,
            expenseDate: expenseUploadDomain.expenseDate
        )
        groupService.setExpensesUpload(with: expenseUploadRequestDTO) {[weak self] result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.uploadExpense.rawValue), object: result)
            }
            self?.isUploadedExpenseInfo.onNext(result)
        }
    }
    
    func loadGroupMemberInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupMemberList(with: groupID) {[weak self] result in
            let groupMemberInfoDomain: [GroupMemberListDomain] = result.map {
                GroupMemberListDomain(
                    groupID: $0.groupID,
                    userID: $0.userID,
                    nickname: $0.nickname
                )
            }
            self?.groupMemberInformations = groupMemberInfoDomain
            self?.isLoadedGroupMemberInfo.onNext(!result.isEmpty)
        }
    }
    
    func loadGroupExpenseInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupExpenseInformations(with: userID, groupID: groupID) {[weak self] result in
            let expenseInformationsDomain: [ExpenseInformations] = result.expenseInformations.map {
                ExpenseInformations(
                    expenseID: $0.expenseID,
                    groupID: $0.groupID,
                    userID: $0.userID,
                    paidBy: $0.paidBy,
                    expenseClassfication: $0.expenseClassfication,
                    expenseDetails: $0.expenseDetails,
                    expenseAmount: $0.expenseAmount,
                    expenseDate: $0.expenseDate
                )
            }
            let groupExpensesDomain = ExpenseInformationDomain(
                expenseInformations: expenseInformationsDomain,
                myExpenses: result.myExpenses,
                groupExpenses: result.groupExpenses
            )
            self?.groupExpenseInformations = groupExpensesDomain
            guard let groupExpenses = result.groupExpenses,
                  let myExpenses = result.myExpenses else {
                self?.groupExpenseInfoSubject.onNext(("0", "0"))
                return }
            self?.groupExpenseInfoSubject.onNext((groupExpenses, myExpenses))
        }
    }
    
    func loadExpenseDetailInformation(_ expenseID: Int) {
        groupService.getGroupExpenseDetailInformation(with: expenseID) {[weak self] detailInformation in
            let expenseDetailInfoDomain = ExpenseDetailInformationDomain(
                expenseID: detailInformation.expenseID,
                groupID: detailInformation.groupID,
                paidBy: detailInformation.paidBy,
                expenseClassfication: detailInformation.expenseClassfication,
                expenseDetails: detailInformation.expenseDetails,
                expenseAmount: detailInformation.expenseAmount,
                expenseDate: detailInformation.expenseDate
            )
            self?.expenseDetailInformation = expenseDetailInfoDomain
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
        let spendingDetailInfo = DeleteSpendingDetailInformationDomain(
            expenseID: expenseID,
            groupID: groupID
        )
        let spedingDetailInfoRequestDTO = DeleteSpendingDetailInformationRequestDTO(
            expenseID: spendingDetailInfo.expenseID,
            groupID: spendingDetailInfo.groupID
        )
        groupService.deleteSpendingDetailInformation(with: spedingDetailInfoRequestDTO) {[weak self] isDeleted in
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
        let spendingDetailInformation = UpdateSpendingDetailInformationDomain(
            groupID: groupID,
            expenseID: expenseID,
            expenseClassfication: expensClassfication,
            expenseDetails: expenseDetails,
            expenseAmount: expenseAmontText,
            expenseDate: expenseDateText
        )
        let spedingDetailInfoRequestDTO = UpdateSpendingDetailInformationRequestDTO(
            groupID: spendingDetailInformation.groupID,
            expenseID: spendingDetailInformation.expenseID,
            expenseClassfication: spendingDetailInformation.expenseClassfication,
            expenseDetails: spendingDetailInformation.expenseDetails,
            expenseAmount: spendingDetailInformation.expenseAmount,
            expenseDate: spendingDetailInformation.expenseDate
        )
        groupService.updateSpendingDetailInformation(with: spedingDetailInfoRequestDTO) {[weak self] isUpdated in
            self?.isUpdatedSpendingDetailInfoSubject.onNext(isUpdated)
        }
    }
}
