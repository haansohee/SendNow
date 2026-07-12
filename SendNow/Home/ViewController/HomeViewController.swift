//
//  HomeViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/15/24.
//

import Foundation
import UIKit
import RxSwift
import RxGesture
import FirebaseMessaging

final class HomeViewController: BaseUIViewController {
    private let homeView = HomeView()
    private let homeViewModel: HomeViewModel
    private let notificationViewModel: NotificationViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel = HomeViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         notificationViewModel: NotificationViewModel = NotificationViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))) {
                self.homeViewModel = viewModel
                self.notificationViewModel = notificationViewModel
                super.init(nibName: nil, bundle: nil)
            }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.loadMemberInformation()
        homeViewModel.loadMyFriend()
        notificationViewModel.getNotificationList()
        configure()
        addSubviews()
        setLayoutConstraints()
        registerForFCMTokenNotification()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.loadMemberInformation()
        homeViewModel.loadMyFriend()
    }
}

extension HomeViewController {
    private func configure() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.friendListCollectionView.delegate = self
        homeView.friendListCollectionView.dataSource = self
        homeView.summaryCardCollectionView.delegate = self
        homeView.summaryCardCollectionView.dataSource = self
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "홈"
    }
    
    private func addSubviews() {
        view.addSubview(homeView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureHomeViewNicknameLabel() {
        guard let nickname = homeViewModel.loginMemberInformation?.nickname else { return }
        homeView.memberNicknameLabel.text = nickname
    }
    
    // MARK: NotificationCenter
    private func registerForFCMTokenNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFcmToken), name: NSNotification.Name(NotificationName.fetchApnsToken.rawValue), object: nil)
    }
    
    @objc func updateFcmToken() {
        homeViewModel.updateFCMToken()
    }
    
    //MARK: Bind
    private func bindAll() {
        bindFriendRequestButton()
        bindIsLoadedMemberInformation()
        bindIsLoadedMyFriendList()
        bindIsLoadedNotificationInfo()
    }
    
    private func bindFriendRequestButton() {
        homeView.friendRequestButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                let viewController = FriendRequestViewController()
                viewController.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMemberInformation() {
        homeViewModel.isLoadedMemberInformation
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {[weak self] in
                self?.configureHomeViewNicknameLabel()
                self?.homeView.summaryCardCollectionView.reloadData()
                guard let kakaoPayURL = self?.homeViewModel.loginMemberInformation?.kakaoPayUrl,
                      let isDismissed = self?.homeViewModel.loginMemberInformation?.isDismissed else {
                    return
                }
                if kakaoPayURL.isEmpty && kakaoPayURL == "" && !isDismissed {
                    self?.present(BankInfoRequiredViewController(), animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMyFriendList() {
        homeViewModel.isLoadedMyFriendList
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedMyFriendListResult in
                switch isLoadedMyFriendListResult {
                case .success():
                    self?.homeView.friendListCollectionView.reloadData()
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedNotificationInfo() {
        notificationViewModel.isLoadedNotificationInfo
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedNotificationInfoResult in
                switch isLoadedNotificationInfoResult {
                case .success():
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
}

//MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case homeView.friendListCollectionView:
            guard let listCount = homeViewModel.myFriendList?.count else { return 1 }
            return listCount == 0 ? 1 : listCount
        case homeView.summaryCardCollectionView:
            return 3
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case homeView.friendListCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendListCollectionViewCell.reuseIdentifier, for: indexPath) as? FriendListCollectionViewCell else { return UICollectionViewCell() }
            guard let myGroupList = homeViewModel.myFriendList,
                  myGroupList.count != 0,
                  let myGroup = myGroupList[safe: indexPath.row] else { return cell }
            cell.setFriendListCollectionViewCell(myGroup.nickname)
            return cell
            
        case homeView.summaryCardCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryCardCollectionViewCell.reuseIdentifier, for: indexPath) as? SummaryCardCollectionViewCell else { return UICollectionViewCell() }
            guard let summaryInformationList = homeViewModel.summaryInformation,
                  let summaryInformation = summaryInformationList[safe: indexPath.row] else { return cell }
            cell.configureSummaryCardCollectionViewCell(summaryInformation)
            return cell
        default: return UICollectionViewCell()
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case homeView.friendListCollectionView:
            let width = (UIScreen.main.bounds.width) - 50.0
            let height = 70.0
            return CGSize(width: width, height: height)
        case homeView.summaryCardCollectionView:
            let width = (UIScreen.main.bounds.width) - 50.0
            let height = 80.0
            return CGSize(width: width, height: height)
        default: return CGSize(width: 0, height: 0)
        }
    }
}
