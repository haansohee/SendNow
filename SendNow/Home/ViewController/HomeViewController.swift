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

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        homeViewModel.loadMemberInformation()
        homeViewModel.loadMyGroup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        configureHomeViewNicknameLabel()
        configureHomeViewMySearchIdLabel()
        addSubviews()
        setLayoutConstraintsHomeView()
        notificationInvitedFriendObsever()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.loadMemberInformation()
        homeViewModel.loadMyGroup()
    }
}

extension HomeViewController {
    private func configureHomeView() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.groupListCollectionView.delegate = self
        homeView.groupListCollectionView.dataSource = self
        view.backgroundColor = UIColor(named: "BackColor")
        navigationItem.title = "홈"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: homeView.notificationButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeView.friendRequestButton)
    }
    
    private func addSubviews() {
        view.addSubview(homeView)
    }
    
    private func setLayoutConstraintsHomeView() {
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
    
    private func configureHomeViewMySearchIdLabel() {
        guard let searchID = homeViewModel.loginMemberInformation?.searchID else { return }
        homeView.mySearchIdLabel.text = "나의 검색 ID : \(searchID)"
    }
    
    private func notificationInvitedFriendObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: NSNotification.Name("invitedFriend"), object: nil)
    }
    
    @objc private func dataReceived() {
        homeViewModel.loadMyGroup()
    }
    
    //MARK: Bind
    private func bindAll() {
        bindInvitedGroupButton()
        bindSignoutButton()
        bindMemberInfoEditButton()
        bindFriendRequestButton()
        bindIsLoadedMemberInformation()
        bindIsLoadedMyGroupList()
    }
    
    private func bindInvitedGroupButton() {
        homeView.invitedGroupButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                let invitedGroupViewController = UINavigationController(rootViewController: InvitedGroupViewController())
                self?.present(invitedGroupViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignoutButton() {
        homeView.signoutButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.homeViewModel.signout()
                let rootViewController = UINavigationController(rootViewController: SigninViewController())
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindMemberInfoEditButton() {
        homeView.memberInfoEditButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(MemberInfoUpdateViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFriendRequestButton() {
        homeView.friendRequestButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(FriendRequestViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMemberInformation() {
        homeViewModel.isLoadedMemberInformation
            .asDriver(onErrorJustReturn: "noValue")
            .drive(onNext: {[weak self] isLoadedMemberInformation in
                self?.configureHomeViewNicknameLabel()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMyGroupList() {
        homeViewModel.isLoadedMyGroupList
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedMyGroupList in
                guard isLoadedMyGroupList else { return }
                self?.homeView.groupListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.myGroupList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier, for: indexPath) as? GroupListCollectionViewCell else { return UICollectionViewCell() }
        guard let myGroupList = homeViewModel.myGroupList else { return cell }
        cell.setGroupListCollectionViewCellLabel(myGroupList[indexPath.row])
        cell.rx.tapGesture()
            .when(.recognized)
            .asDriver{ _ in .never() }
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(SettleTabViewController(groupID: myGroupList[indexPath.row].groupID, groupName: myGroupList[indexPath.row].groupName), animated: true)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 100.0
        return CGSize(width: width, height: height)
    }
}
