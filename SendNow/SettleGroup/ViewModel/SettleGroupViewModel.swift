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
    private(set) var isActiveSettlement: Bool?
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
    let isLoadedGroupMemberInfo = PublishSubject<Result<Bool, Error>>()
    let groupExpenseInfoSubject = PublishSubject<Result<(group: String, personal: String), Error>>()
    let isEqualGroupCreatorSubject = PublishSubject<Result<Bool, Error>>()
    let isEqualSettlementCreatorSubject = PublishSubject<Result<Bool, Error>>()
    let isDeletedGroup = PublishSubject<Bool>()
    let isDeletedSpendingDetailInfoSubject = PublishSubject<Bool>()
    let loadedGroupExpenseDetailInfoSubject = PublishSubject<Result<Void, Error>>()
    let isUpdatedSpendingDetailInfoSubject = PublishSubject<Bool>()
    
    init(groupService: GroupService = GroupService(), userID: Int) {
        self.groupService = groupService
        self.userID = userID
    }
    
    func setIsActiveSettlement(_ isActiveSettlement: Bool) {
        self.isActiveSettlement = isActiveSettlement
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
        groupService.getGroupCreatorUserID(with: groupID, userID: userID) {[weak self] getGroupCreatorUserIdResult in
            switch getGroupCreatorUserIdResult {
            case .success(let isEqualGroupCreatorUser):
                self?.isEqualGroupCreatorSubject.onNext(.success(isEqualGroupCreatorUser))
            case .failure(let error):
                self?.isEqualGroupCreatorSubject.onNext(.failure(error))
            }
        }
    }
    
    func loadSettlementCreatorID() {
        guard let groupID = self.groupID,
              let expenseID = self.expenseID else { return }
        groupService.getSettlementCreatorID(with: expenseID, groupID: groupID, userID: userID) {[weak self] getSettlementCreatorUserIdresult in
            switch getSettlementCreatorUserIdresult {
            case .success(let isEqualSettlementCreatorUser):
                self?.isEqualSettlementCreatorSubject.onNext(.success(isEqualSettlementCreatorUser))
            case .failure(let error):
                self?.isEqualSettlementCreatorSubject.onNext(.failure(error))
            }
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
        groupService.setExpensesUpload(with: expenseUploadRequestDTO) {[weak self] result, _ in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(NotificationName.uploadExpense.rawValue), object: result)
            }
            self?.isUploadedExpenseInfo.onNext(result)
        }
    }
    
    func loadGroupMemberInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupMemberList(with: groupID) {[weak self] getGroupMemberListResult in
            switch getGroupMemberListResult {
            case .success(let groupMemberListDomain):
                self?.groupMemberInformations = groupMemberListDomain
                self?.isLoadedGroupMemberInfo.onNext(.success(!groupMemberListDomain.isEmpty))
            case .failure(let error):
                self?.isLoadedGroupMemberInfo.onNext(.failure(error))
            }
        }
    }
    
    func loadGroupExpenseInformation() {
        guard let groupID = groupID else { return }
        groupService.getGroupExpenseInformations(with: userID, groupID: groupID) {[weak self] getGroupExpenseInformationsInfoResult in
            switch getGroupExpenseInformationsInfoResult {
            case .success(let groupExpenseInfosDomain):
                guard let groupExpenses = groupExpenseInfosDomain.groupExpenses,
                      let myExpenses = groupExpenseInfosDomain.myExpenses else {
                    self?.groupExpenseInfoSubject.onNext(.success(("0", "0")))
                    return }
                self?.groupExpenseInformations = groupExpenseInfosDomain
                self?.groupExpenseInfoSubject.onNext(.success((groupExpenses, myExpenses)))
            case .failure(let error):
                self?.groupExpenseInfoSubject.onNext(.failure(error))
            }
        }
    }
    
    func loadExpenseDetailInformation(_ expenseID: Int) {
        groupService.getGroupExpenseDetailInformation(with: expenseID) {[weak self] getGroupExpenseDetailInfoResult in
            switch getGroupExpenseDetailInfoResult {
            case .success(let groupExpenseDetailInfoDomain):
                self?.expenseDetailInformation = groupExpenseDetailInfoDomain
                self?.loadedGroupExpenseDetailInfoSubject.onNext(.success(Void()))
            case .failure(let error):
                self?.loadedGroupExpenseDetailInfoSubject.onNext(.failure(error))
            }
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
        groupService.updateSpendingDetailInformation(with: spedingDetailInfoRequestDTO) {[weak self] isUpdated, _ in
            self?.isUpdatedSpendingDetailInfoSubject.onNext(isUpdated)
        }
    }
}
