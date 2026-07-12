//
//  NotificationViewController.swift
//  SendNow
//
//  Created by 한소희 on 8/31/24.
//

import Foundation
import UIKit
import RxSwift

final class NotificationViewController: BaseUIViewController {
    private let notificationStateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.titleColor, for: .normal)
        button.setTitle("알림 끄기", for: .normal)
        button.titleLabel?.font = .customFont(.pretendardSemiBold, size: 15.0)
        button.tag = 0
        return button
    }()
    
    private let notificationDeleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.systemRed, for: .normal)
        button.setTitle("알림 삭제", for: .normal)
        button.titleLabel?.font = .customFont(.pretendardSemiBold, size: 15.0)
        return button
    }()
    
    private let notificationListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0  
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.backgroundColor = .secondarySystemBackground
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationViewModel.getNotificationList()
        notificationViewModel.loadNotificationStatus()
        configure()
        configureRefreshControl()
        addSubviews()
        setLayoutConstraints()
        addNotificationStatusUpdate()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationViewModel.getNotificationList()
    }
}

extension NotificationViewController {
    private func configure() {
        notificationListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        notificationListCollectionView.delegate = self
        notificationListCollectionView.dataSource = self
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "알림"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: notificationStateButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationDeleteButton)
    }
    
    private func configureRefreshControl() {
        notificationListCollectionView.refreshControl = refreshControl
        notificationListCollectionView.refreshControl?.tintColor = .titleColor
    }
    
    private func addSubviews() {
        view.addSubview(notificationListCollectionView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            notificationListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            notificationListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            notificationListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            notificationListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addNotificationStatusUpdate() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationStatus), name: NSNotification.Name("NotificationAuth"), object: nil)
    }
    @objc private func updateNotificationStatus() {
        DispatchQueue.main.async {
            if let appSettingURL = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(appSettingURL) {
                UIApplication.shared.open(appSettingURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: Bind
    private func bindAll() {
        bindRefreshControl()
        bindNotificationStateButton()
        bindNotificationDeleteButton()
        bindNotificationStatusSubject()
        bindIsLoadedNotificationList()
        bindIsUpdatedNotification()
        bindIsUpdatedNotificationAll()
        bindIsUpdatedNotificationState()
        bindIsDeletedNotification()
        bindNotificationWillEnterForegroundNotification()
    }
    
    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {[weak self] _ in
                self?.notificationViewModel.updateNotificationAll()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationStateButton() {
        notificationStateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                switch self?.notificationStateButton.tag {
                case 0:
                    self?.notificationViewModel.updateNotificationState()
                case 1:
                    DispatchQueue.main.async {
                        if let appSettingURL = URL(string: UIApplication.openSettingsURLString),
                           UIApplication.shared.canOpenURL(appSettingURL) {
                            UIApplication.shared.open(appSettingURL, options: [:], completionHandler: nil)
                        }
                    }
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationDeleteButton() {
        notificationDeleteButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.notificationViewModel.deleteNotificationAll()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationWillEnterForegroundNotification() {
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .subscribe(onNext: {[weak self] _ in
                self?.notificationViewModel.updateNotificationState()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNotificationStatusSubject() {
        notificationViewModel.notificationStatusSubject
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(onNext: {[weak self] isSetNoti, notificationAuth in
                if notificationAuth {
                    self?.notificationStateButton.tag = 0
                    let title = isSetNoti ? "알림 끄기" : "알림 켜기"
                    self?.notificationStateButton.setTitle(title, for: .normal)
                } else {
                    self?.notificationStateButton.tag = 1
                    self?.notificationStateButton.setTitle("설정에서 알림 켜기", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedNotificationList() {
        notificationViewModel.isLoadedNotificationInfo
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedNotificationInfoResult in
                switch isLoadedNotificationInfoResult {
                case .success():
                    self?.notificationListCollectionView.reloadData()
                    guard let tabItems = self?.tabBarController?.tabBar.items else {return }
                    guard self?.notificationViewModel.unreadNotificationList?.count != 0 else {
                        tabItems[2].badgeValue = nil
                        return }
                    tabItems[2].badgeColor = .clear
                    tabItems[2].setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemRed], for: .normal)
                    tabItems[2].badgeValue = "●"
                case .failure(_):
                    self?.serverErrorAlert()
                }
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
    
    private func bindIsUpdatedNotificationState() {
        notificationViewModel.isUpdatedNotificationState
            .subscribe(onNext: {[weak self] isUpdatedNotificationState in
                guard isUpdatedNotificationState else {
                    DispatchQueue.main.async {
                        self?.confirmAlert(title: "바로 보내", message: "네트워크에 예상치 못한 오류가 발생하였어요. 다시 시도해 주세요.")
                    }
                    return }
                self?.notificationViewModel.loadNotificationStatus()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedNotification() {
        notificationViewModel.isDeletedNotification
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDeletedNotification in
                guard isDeletedNotification else { return }
                self?.confirmAlert(title: "바로보내", message: "알림이 모두 삭제되었어요.", collectionView: self?.notificationListCollectionView)
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
                  !unreadNotificationList.isEmpty,
                  let unreadNotification = unreadNotificationList[safe: indexPath.row] else {
                cell.setUnreadNotificationCollectionViewCell()
                return cell }
            cell.setReadNotificationCollectionViewCell(
                notificationBody: unreadNotification.notificationBody,
                isRead: unreadNotification.isRead,
                subject: unreadNotification.subject)
            return cell
        case 1:
            guard let readNotificationList = notificationViewModel.readNotificationList,
                  !readNotificationList.isEmpty,
                  let readNotification = readNotificationList[safe: indexPath.row] else { return cell }
            cell.setReadNotificationCollectionViewCell(
                notificationBody: readNotification.notificationBody,
                isRead: readNotification.isRead,
                subject: readNotification.subject)
            return cell
        default: return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            guard let unreadNotificationList = notificationViewModel.unreadNotificationList,
                  !unreadNotificationList.isEmpty,
                  let unreadNotification = unreadNotificationList[safe: indexPath.row] else { return }
            notificationViewModel.updateNotificationIsRead(notificationID: unreadNotification.notificationID)
            switch unreadNotification.subject {
            case .friendRequest:
                navigationController?.pushViewController(FriendRequestListViewController(), animated: true)
            case .groupInvited:
                navigationController?.pushViewController(GroupListViewController(), animated: true)
            default: return
            }
            
        case 1:
            guard let readNotificationList = notificationViewModel.readNotificationList,
                  !readNotificationList.isEmpty,
                  let readNotification = readNotificationList[safe: indexPath.row] else { return }
            switch readNotification.subject {
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
