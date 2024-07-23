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
    case getGroupList = "/SendNow/getGroupList?userID="
    case getGroupMemberList = "/SendNow/getGroupMemberList?groupID="
    case getGroupSettlementsInformations = "/SendNow/getGroupSettlementsInformations?groupID="
}

final class GroupService {
    private let networkSessionManager = NetworkSessionManager()
    
    func setGroupList(with groupCreationDomain: GroupCreationDomain, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.setGroupList.rawValue
        let groupInfo = groupCreationDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: groupInfo) { result in
            completion(result)
        }
    }
    
    func setExpensesUpload(with expenseUploadDomain: ExpenseUploadDomain, completion: @escaping(Bool)->Void) {
        let path = GroupAPIPath.setExpensesUpload.rawValue
        let expensesUploadInfo = expenseUploadDomain.toRequestDTO()
        networkSessionManager.urlPostMethod(path: path, encodeValue: expensesUploadInfo) { result in
            completion(result)
        }
    }
    
    func getGroupList(with userID: Int, completion: @escaping([GroupListDomain])->Void) {
        let path = "\(GroupAPIPath.getGroupList.rawValue)\(userID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let groupList = responseDTO.map { $0.toDomain() }
                completion(groupList)
            case .failure(let error):
                print("get Group List Info Error : \(error)")
            }
        }
    }
    
    func getGroupMemberList(with groupID: Int, completion: @escaping([GroupMemberListDomain])->Void) {
        let path = "\(GroupAPIPath.getGroupMemberList.rawValue)\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: [GroupMemberListResponseDTO].self) { result in
            switch result {
            case .success(let responseDTO):
                let groupMemberList = responseDTO.map { $0.toDomain() }
                completion(groupMemberList)
            case .failure(let error):
                print("get Group List Info Error : \(error)")
            }
        }
    }
    
    func getGroupExpenseInformations(with userID: Int, groupID: Int, completion: @escaping(ExpenseInformationDomain)->Void) {
        let path = "/SendNow/getGroupExpenseInformations?userID=\(userID)&groupID=\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: ExpenseInformationResponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
            case .failure(let error):
                print("get Group Expense Information Error : \(error)")
            }
        }
    }
    
    func getGroupSettlementsInformations(with groupID: Int, completion: @escaping(SettlementListDomain)->Void) {
        let path = "\(GroupAPIPath.getGroupSettlementsInformations.rawValue)\(groupID)"
        networkSessionManager.urlGetMethod(path: path, requestDTO: SettlementListReponseDTO.self) { result in
            switch result {
            case .success(let responseDTO):
                completion(responseDTO.toDomain())
            case .failure(let error):
                print("get Group Settlements Informations Error : \(error)")
            }
        }
    }
}
