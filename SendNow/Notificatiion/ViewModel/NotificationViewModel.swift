//
//  NotificationViewModel.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import Foundation
import RxSwift

final class NotificationViewModel {
    private let notificationService: NotificationService
    let isLoadedNotificationInfo = PublishSubject<Void>()
    let isUpdatedNotification = PublishSubject<Bool>()
    let isUpdatedNotificationAll = PublishSubject<Bool>()
    var readNotificationList: [NotificationListDomain]?
    var unreadNotificationList: [NotificationListDomain]?
    private let userID: Int
    
    init(with notificatinoService: NotificationService = NotificationService(),
         userID: Int) {
        self.userID = userID
        self.notificationService = notificatinoService
    }
    
    func getNotificationList() {
        notificationService.getNotificationList(with: userID) {[weak self] notificationList in
            self?.readNotificationList = notificationList.filter { $0.isRead == true}
            self?.unreadNotificationList = notificationList.filter { $0.isRead == false }
            self?.isLoadedNotificationInfo.onNext(Void())
        }
    }
    
    func updateNotificationIsRead(notificationID: Int) {
        notificationService.updateNotificationIsRead(with: notificationID, userID: 0) {[weak self] isUpdated in
            self?.isUpdatedNotification.onNext(isUpdated)
        }
    }
    
    func updateNotificationAll() {
        notificationService.updateNotificationIsRead(with: 0, userID: userID) {[weak self] isUpdated in
            self?.isUpdatedNotificationAll.onNext(isUpdated)
        }
    }
}
