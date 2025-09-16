//
//  GroupService.swift
//  SendNow
//
//  Created by 한소희 on 5/20/24.
//

import Foundation

enum GroupAPIPath: String {
    case setGroupList = "/SendNow/setGroupList/"
    case setExpensesUpload = "/SendNow/setExpenseUpload/"
    case setCompletedRemittace = "/SendNow/setCompletedRemittance/"
    case updateSpendingDetailInfo = "/SendNow/updateSpendingDetailInformations/"
    case deleteGroup = "/SendNow/deleteGroup"
    case deleteSpendingDetailInformation = "/SendNow/DeleteSpendingDetailInformation/"
    case getGroupList = "/SendNow/getGroupList"
    case getGroupMemberList = "/SendNow/getGroupMemberList"
    case getGroupExpenseInformations = "/SendNow/getGroupExpenseInformations"
    case getGroupExpenseDetailInformation = "/SendNow/getGroupExpenseDetailInformation"
    case getGroupSettlementsInformations = "/SendNow/getGroupSettlementsInformations"
    case getGroupCreatorUserID = "/SendNow/getGroupCreatorUserID"
    case getSettlementCreatorUserID = "/SendNow/getSettlementCreatorUserID"
    case getCompletedRemittanceInformation = "/SendNow/getCompletedRemittanceInformation"
}

final class GroupService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setGroupList(with groupCreationRequestDTO: GroupCreationRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.setGroupList.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: groupCreationRequestDTO, completion: completion)
    }
    
    func setExpensesUpload(with expenseUploadRequestDTO: ExpenseUploadRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.setExpensesUpload.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: expenseUploadRequestDTO, completion: completion)
    }
    
    func setCompletedRemittance(with remittanceStatusRequestDTO: RemittanceStatusRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.setCompletedRemittace.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: remittanceStatusRequestDTO, completion: completion)
    }
    
    func deleteGroup(with groupID: Int, completion: @escaping(Bool)->Void) {
        let path = "\(GroupAPIPath.deleteGroup.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: groupID, completion: completion)
    }
    
    func deleteSpendingDetailInformation(with deleteSpendingDetailInformationRequestDTO: DeleteSpendingDetailInformationRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.deleteSpendingDetailInformation.rawValue
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: deleteSpendingDetailInformationRequestDTO, completion: completion)
    }
    
    func getGroupList(with userID: Int, completion: @escaping([GroupListResponseDTO])->Void) {
        let path = "\(GroupAPIPath.getGroupList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("get Group List Info Error : \(error)")
            }
        }
    }
    
    func getGroupMemberList(with groupID: Int, completion: @escaping([GroupMemberListResponseDTO])->Void) {
        let path = "\(GroupAPIPath.getGroupMemberList.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupMemberListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("get Group List Info Error : \(error)")
            }
        }
    }
    
    func getGroupExpenseInformations(with userID: Int, groupID: Int, completion: @escaping(ExpenseInformationResponseDTO)->Void) {
        let path = "\(GroupAPIPath.getGroupExpenseInformations.rawValue)?userID=\(userID)&groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: ExpenseInformationResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("get Group Expense Information Error : \(error)")
            }
        }
    }
    
    func getGroupExpenseDetailInformation(with expenseID: Int, completion: @escaping(ExpenseDetailInformationReponseDTO)->Void) {
        let path = "\(GroupAPIPath.getGroupExpenseDetailInformation.rawValue)?expenseID=\(expenseID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: ExpenseDetailInformationReponseDTO.self) { result in
            switch result {
            case .success(let repsonseDTO):
                completion(repsonseDTO)
            case .failure(let error):
                print("get Group Expense Detail Information Error: \(error)")
            }
        }
        
    }
    
    func getGroupSettlementsInformations(with groupID: Int, completion: @escaping(SettlementListReponseDTO)->Void) {
        let path = "\(GroupAPIPath.getGroupSettlementsInformations.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SettlementListReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("get Group Settlements Informations Error : \(error)")
            }
        }
    }
    
    func getGroupCreatorUserID(with groupID: Int, userID: Int, completion: @escaping(Bool)->Void) {
        let path = "\(GroupAPIPath.getGroupCreatorUserID.rawValue)?groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: Bool.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO)
            case .failure(let error):
                print("get Group Settlements Informations Error : \(error)")
                completion(false)
            }
        }
    }
    
    func getSettlementCreatorID(with expenseID: Int, groupID: Int, userID: Int, completion: @escaping(Bool)->Void) {
        let path = "\(GroupAPIPath.getSettlementCreatorUserID.rawValue)?expenseID=\(expenseID)&groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: Bool.self) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(let error):
                print("get settlements creator userID Error: \(error)")
                completion(false)
            }
        }
    }
    
    func getCompletedRemittanceInformation(with groupID: Int, userID: Int, completion: @escaping([CompletionRemittanceResponseDTO])->Void) {
        let path = "\(GroupAPIPath.getCompletedRemittanceInformation.rawValue)?groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [CompletionRemittanceResponseDTO].self) { completionRemittanceInfo in
            switch completionRemittanceInfo {
            case .success(let completionRemittanceInformation):
                completion(completionRemittanceInformation)
            case .failure(let error):
                print("get Completed Remittance Information Error : \(error)")
                completion([])
            }
        }
    }
    
    func updateSpendingDetailInformation(with expenseDetailInformationRequestDTO: UpdateSpendingDetailInformationRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.updateSpendingDetailInfo.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: expenseDetailInformationRequestDTO, completion: completion)
    }
}
