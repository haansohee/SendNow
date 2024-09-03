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
    private let homeViewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.homeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        homeViewModel.loadMemberInformation()
        homeViewModel.loadMyFriend()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        addSubviews()
        setLayoutConstraintsHomeView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.loadMemberInformation()
    }
}

extension HomeViewController {
    private func configureHomeView() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.friendListCollectionView.delegate = self
        homeView.friendListCollectionView.dataSource = self
        view.backgroundColor = UIColor(named: "BackColor")
        navigationItem.title = "홈"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: homeView.settingButton)
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
    
    //MARK: Bind
    private func bindAll() {
        bindSignoutButton()
        bindFriendRequestButton()
        bindIsLoadedMemberInformation()
        bindIsLoadedMyFriendList()
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
                self?.configureHomeViewMySearchIdLabel()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMyFriendList() {
        homeViewModel.isLoadedMyFriendList
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {[weak self] _ in
                self?.homeView.friendListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.myFriendList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendListCollectionViewCell.reuseIdentifier, for: indexPath) as? FriendListCollectionViewCell else { return UICollectionViewCell() }
        guard let myGroupList = homeViewModel.myFriendList else { return cell }
        cell.setFriendListCollectionViewCell(myGroupList[indexPath.row].nickname)
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 70.0
        return CGSize(width: width, height: height)
    }
}
