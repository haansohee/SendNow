//
//  HomeViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/15/24.
//

import Foundation
import UIKit
import RxSwift

final class HomeViewController: UIViewController {
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        addSubviews()
        setLayoutConstraintsHomeView()
        bindAll()
    }
}

extension HomeViewController {
    private func configureHomeView() {
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.groupListCollectionView.delegate = self
        homeView.groupListCollectionView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.title = "홈"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: homeView.notificationButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: homeView.friendAddButton)
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
    
    private func bindAll() {
        bindInvitedGroupButton()
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
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier, for: indexPath) as? GroupListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 100.0
        return CGSize(width: width, height: height)
    }
}
