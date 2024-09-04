//
//  NotificationViewController.swift
//  SendNow
//
//  Created by 한소희 on 8/31/24.
//

import Foundation
import UIKit
import RxSwift

final class NotificationViewController: UIViewController {
    private let notificationListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0  
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.reuseIdentifier)
        collectionView.register(CollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private let refreshControl = UIRefreshControl()
    private let notificationViewModel: NotificationViewModel
    private let disposeBag: DisposeBag
    
    init(viewModel: NotificationViewModel = NotificationViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         disposeBag: DisposeBag = DisposeBag()) {
        notificationViewModel = viewModel
        self.disposeBag = disposeBag
        super.init(nibName: nil, bundle: nil)
        notificationViewModel.getNotificationList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationView()
        configureRefreshControl()
        addSubviews()
        setLayoutConstraintsNotificationView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationViewModel.getNotificationList()
    }
}

extension NotificationViewController {
    private func configureNotificationView() {
        notificationListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        notificationListCollectionView.delegate = self
        notificationListCollectionView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.title = "알림"
    }
    
    private func configureRefreshControl() {
        notificationListCollectionView.refreshControl = refreshControl
        notificationListCollectionView.refreshControl?.tintColor = UIColor(named: "TitleColor")
    }
    
    private func addSubviews() {
        view.addSubview(notificationListCollectionView)
    }
    
    private func setLayoutConstraintsNotificationView() {
        NSLayoutConstraint.activate([
            notificationListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            notificationListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notificationListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Bind
    private func bindAll() {
        bindRefreshControl()
        bindIsLoadedNotificationList()
        bindIsUpdatedNotification()
        bindIsUpdatedNotificationAll()
    }
    
    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {[weak self] _ in
                self?.notificationViewModel.updateNotificationAll()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedNotificationList() {
        notificationViewModel.isLoadedNotificationInfo
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {[weak self] in
                self?.notificationListCollectionView.reloadData()
                guard let tabItems = self?.tabBarController?.tabBar.items else {return }
                guard self?.notificationViewModel.unreadNotificationList?.count != 0 else {
                    tabItems[2].badgeValue = nil
                    return }
                tabItems[2].badgeColor = .clear
                tabItems[2].setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: .normal)
                tabItems[2].badgeValue = "●"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedNotification() {
        notificationViewModel.isUpdatedNotification
            .subscribe(onNext: {[weak self] isUpdatedNotification in
                guard isUpdatedNotification else { return }
                self?.notificationViewModel.getNotificationList()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedNotificationAll() {
        notificationViewModel.isUpdatedNotificationAll
            .subscribe(onNext: {[weak self] isUpdatedNotificationAll in
                guard isUpdatedNotificationAll else { return }
                self?.notificationViewModel.getNotificationList()
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UICollectionViewDataSource, Delegate
extension NotificationViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return notificationViewModel.unreadNotificationList?.count ?? 0
        case 1:
            return notificationViewModel.readNotificationList?.count ?? 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.reuseIdentifier, for: indexPath) as? NotificationCollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let unreadNotificationList = notificationViewModel.unreadNotificationList,
                  !unreadNotificationList.isEmpty else {
                cell.setUnreadNotificationCollectionViewCell()
                return cell }
            cell.setReadNotificationCollectionViewCell(
                notificationBody: unreadNotificationList[indexPath.row].notificationBody,
                isRead: unreadNotificationList[indexPath.row].isRead,
                subject: unreadNotificationList[indexPath.row].subject)
            return cell
        case 1:
            guard let readNotificationList = notificationViewModel.readNotificationList,
                  !readNotificationList.isEmpty else { return cell }
            cell.setReadNotificationCollectionViewCell(
                notificationBody: readNotificationList[indexPath.row].notificationBody,
                isRead: readNotificationList[indexPath.row].isRead,
                subject: readNotificationList[indexPath.row].subject)
            return cell
        default: return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            guard let unreadNotificationList = notificationViewModel.unreadNotificationList,
                  !unreadNotificationList.isEmpty else { return }
            notificationViewModel.updateNotificationIsRead(notificationID: unreadNotificationList[indexPath.row].notificationID)
            switch unreadNotificationList[indexPath.row].subject {
            case .friendRequest:
                navigationController?.pushViewController(FriendRequestListViewController(), animated: true)
            case .groupInvited:
                navigationController?.pushViewController(GroupListViewController(), animated: true)
            default: return
            }
            
        case 1:
            guard let readNotificationList = notificationViewModel.readNotificationList,
                  !readNotificationList.isEmpty else { return }
            switch readNotificationList[indexPath.row].subject {
            case .friendRequest:
                navigationController?.pushViewController(FriendRequestListViewController(), animated: true)
            case .groupInvited:
                navigationController?.pushViewController(GroupListViewController(), animated: true)
            default: return
            }
        default: return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeaderView.reuseIdentifier, for: indexPath) as? CollectionViewHeaderView else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            header.label.text = "읽지 않은 알림"
        case 1:
            header.label.text = "읽은 알림"
        default: return header
        }
        return header
    }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 70.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 20.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 24.0, right: 0.0)
    }
}
