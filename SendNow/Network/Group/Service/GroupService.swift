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
    case updateGroupManagementUser = "/SendNow/UpdateGroupManagementUser/"
    case updateGroupRemainderUser = "/SendNow/UpdateGroupRemainderUser/"
    case updateGroupName = "/SendNow/UpdateGroupName/"
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
    
    func setGroupList(with requestDTO: GroupCreationRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.setGroupList.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func setExpensesUpload(with requestDTO: ExpenseUploadRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.setExpensesUpload.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func setCompletedRemittance(with requestDTO: RemittanceStatusRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.setCompletedRemittace.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func deleteGroup(with groupID: Int, completion: @escaping(Bool)->Void) {
        let path = "\(GroupAPIPath.deleteGroup.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: groupID, completion: completion)
    }
    
    func deleteSpendingDetailInformation(with requestDTO: DeleteSpendingDetailInformationRequestDTO, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.deleteSpendingDetailInformation.rawValue
        networkSessionManager.urlDeleteMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func getGroupList(with userID: Int, completion: @escaping(Result<[GroupListDomain], Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupList.rawValue)?userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let groupListDomain = responseDTO.map { $0.toDomain() }
                completion(.success(groupListDomain))
            case .failure(let error):
                print("get Group List Info Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getGroupMemberList(with groupID: Int, completion: @escaping(Result<[GroupMemberListDomain], Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupMemberList.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupMemberListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let groupMemberListDomain = responseDTO.map { $0.toDomain() }
                completion(.success(groupMemberListDomain))
            case .failure(let error):
                print("get Group List Info Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getGroupExpenseInformations(with userID: Int, groupID: Int, completion: @escaping(Result<ExpenseInformationDomain, Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupExpenseInformations.rawValue)?userID=\(userID)&groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: ExpenseInformationResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let expenseInfoDomain = responseDTO.toDomain()
                completion(.success(expenseInfoDomain))
            case .failure(let error):
                print("get Group Expense Information Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getGroupExpenseDetailInformation(with expenseID: Int, completion: @escaping(Result<ExpenseDetailInformationDomain, Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupExpenseDetailInformation.rawValue)?expenseID=\(expenseID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: ExpenseDetailInformationReponseDTO.self) { result in
            switch result {
            case .success(let reponseDTO):
                let expenseDetailInfoDomain = reponseDTO.toDomain()
                completion(.success(expenseDetailInfoDomain))
            case .failure(let error):
                print("get Group Expense Detail Information Error: \(error)")
                completion(.failure(error))
            }
        }
        
    }
    
    func getGroupSettlementsInformations(with groupID: Int, completion: @escaping(Result<SettlementListDomain, Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupSettlementsInformations.rawValue)?groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SettlementListReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                let settlementListDomain = responseDTO.toDomain()
                completion(.success(settlementListDomain))
            case .failure(let error):
                print("get Group Settlements Informations Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getGroupCreatorUserID(with groupID: Int, userID: Int, completion: @escaping(Result<Bool, Error>)->Void) {
        let path = "\(GroupAPIPath.getGroupCreatorUserID.rawValue)?groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: Bool.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO))
            case .failure(let error):
                print("get Group Settlements Informations Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getSettlementCreatorID(with expenseID: Int, groupID: Int, userID: Int, completion: @escaping(Result<Bool, Error>)->Void) {
        let path = "\(GroupAPIPath.getSettlementCreatorUserID.rawValue)?expenseID=\(expenseID)&groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: Bool.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO))
            case .failure(let error):
                print("get settlements creator userID Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getCompletedRemittanceInformation(with groupID: Int, userID: Int, completion: @escaping(Result<[CompletionRemittanceDomain], Error>)->Void) {
        let path = "\(GroupAPIPath.getCompletedRemittanceInformation.rawValue)?groupID=\(groupID)&userID=\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [CompletionRemittanceResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let completionRemittanceDomain = responseDTO.map { $0.toDomain() }
                completion(.success(completionRemittanceDomain))
            case .failure(let error):
                print("get Completed Remittance Information Error : \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func updateSpendingDetailInformation(with requestDTO: UpdateSpendingDetailInformationRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.updateSpendingDetailInfo.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func updateGroupManagementUser(with requestDTO: UpdateGroupManagementUserRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.updateGroupManagementUser.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func updateGroupRemainderUser(with requestDTO: UpdateGroupManagementUserRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.updateGroupRemainderUser.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
    
    func updateGroupName(with requestDTO: UpdateGroupNameRequestDTO, completion: @escaping(Bool, Int)->Void) {
        let path = GroupAPIPath.updateGroupName.rawValue
        networkSessionManager.urlPostMethod(path: path, encodeValue: requestDTO, completion: completion)
    }
}
