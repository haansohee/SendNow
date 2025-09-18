//
//  NotificationViewModel.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import Foundation
import RxSwift
import UserNotifications

final class NotificationViewModel {
    private let notificationService: NotificationService
    let isLoadedNotificationInfo = PublishSubject<Void>()
    let notificationStatusSubject = BehaviorSubject(value: (isSetNoti: false, notificationAuth: false))
    let isUpdatedNotification = PublishSubject<Bool>()
    let isUpdatedNotificationAll = PublishSubject<Bool>()
    let isUpdatedNotificationState = PublishSubject<Bool>()
    let isDeletedNotification = PublishSubject<Bool>()
    var readNotificationList: [NotificationListDomain]?
    var unreadNotificationList: [NotificationListDomain]?
    private let userID: Int
    
    init(with notificatinoService: NotificationService = NotificationService(),
         userID: Int) {
        self.userID = userID
        self.notificationService = notificatinoService
    }
    
    func getNotificationList() {
        notificationService.getNotificationList(with: userID) {[weak self] getNotificationListResult in
            switch getNotificationListResult {
            case .success(let notificationListDomain):
                self?.readNotificationList = notificationListDomain.filter { $0.isRead == true}
                self?.unreadNotificationList = notificationListDomain.filter { $0.isRead == false }
                self?.isLoadedNotificationInfo.onNext(Void())
            case .failure(let error):
                print("에러 수정 필요")
            }
        }
    }
    
    func loadNotificationStatus() {
        let isSetNoti = UserDefaults.standard.bool(forKey: MemberInfoField.isSetNoti.rawValue)
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] settings in
            let notificationAuth = settings.authorizationStatus == .authorized
            self?.notificationStatusSubject.onNext((isSetNoti, notificationAuth))
        }
    }
    
    func updateNotificationIsRead(notificationID: Int) {
        notificationService.updateNotificationIsRead(with: notificationID, userID: 0) {[weak self] isUpdated in
            if isUpdated {
                let currentBadgeCount = UserDefaults.standard.integer(forKey: MemberInfoField.notificationBadge.rawValue) - 1
                UserDefaults.standard.set(currentBadgeCount, forKey: MemberInfoField.notificationBadge.rawValue)
                UNUserNotificationCenter.current().setBadgeCount(currentBadgeCount) { error in
                    self?.isUpdatedNotification.onNext(false)
                }
            }
            self?.isUpdatedNotification.onNext(isUpdated)
        }
    }
    
    func updateNotificationAll() {
        notificationService.updateNotificationIsRead(with: 0, userID: userID) {[weak self] isUpdated in
            if isUpdated {
                UNUserNotificationCenter.current().setBadgeCount(0)
            }
            self?.isUpdatedNotificationAll.onNext(isUpdated)
        }
    }
    
    func updateNotificationState() {
        let state = !(UserDefaults.standard.bool(forKey: MemberInfoField.isSetNoti.rawValue))
        UNUserNotificationCenter.current().getNotificationSettings {[weak self] settings in
            guard let userID = self?.userID else { return }
            let notificationStateDomain = NotificationStateDomain(
                userID: userID,
                state: settings.authorizationStatus == .authorized ? state : false
            )
//            if settings.authorizationStatus == .authorized {
//                let notificationStateDomain = NotificationStateDomain(
//                    userID: userID,
//                    state: state
//                )
//                let notificationStateRequestDTO = UpdateNotificationStateRequestDTO(
//                    userID: notificationStateDomain.userID,
//                    state: notificationStateDomain.state
//                )
//                self?.notificationService.updateNotificationState(with: notificationStateRequestDTO) { isUpdated in
//                    if isUpdated {
//                        UserDefaults.standard.set(state, forKey: MemberInfoField.isSetNoti.rawValue)
//                    }
//                    self?.isUpdatedNotificationState.onNext(isUpdated)
//                }
//            } else {
//                let notificationStateDomain = NotificationStateDomain(
//                    userID: userID,
//                    state: false
//                )
//                let notificationStateRequestDTO = UpdateNotificationStateRequestDTO(
//                    userID: notificationStateDomain.userID,
//                    state: notificationStateDomain.state
//                )
//                self?.notificationService.updateNotificationState(with: notificationStateRequestDTO) { isUpdated in
//                    if isUpdated {
//                        UserDefaults.standard.set(state, forKey: MemberInfoField.isSetNoti.rawValue)
//                    }
//                    self?.isUpdatedNotificationState.onNext(isUpdated)
//                }
//            }
            let notificationStateRequestDTO = UpdateNotificationStateRequestDTO(
                userID: notificationStateDomain.userID,
                state: notificationStateDomain.state
            )
            self?.notificationService.updateNotificationState(with: notificationStateRequestDTO) { isUpdated in
                if isUpdated {
                    UserDefaults.standard.set(state, forKey: MemberInfoField.isSetNoti.rawValue)
                }
                self?.isUpdatedNotificationState.onNext(isUpdated)
            }
        }
    }
    
    func deleteNotificationAll() {
        notificationService.deleteNotification(with: userID) {[weak self] isDeleted in
            self?.isDeletedNotification.onNext(isDeleted)
        }
    }
}
