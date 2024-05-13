//
//  InvitedGroupViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import Foundation
import UIKit
import RxSwift

final class InvitedGroupViewController: UIViewController {
    private let invitedGroupView = InvitedGroupView()
    private let homeViewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        homeViewModel.loadMyFriend()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInvitedGroupView()
        addSubviews()
        setLayoutConstraintsInvitedGroupView()
        bindAll()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        let viewController = HomeViewController()
        return viewController
    }
}

extension InvitedGroupViewController {
    private func configureInvitedGroupView() {
        invitedGroupView.translatesAutoresizingMaskIntoConstraints = false
        invitedGroupView.invitedGroupCollectionView.delegate = self
        invitedGroupView.invitedGroupCollectionView.dataSource = self
        view.backgroundColor = .systemBackground
        navigationItem.title = "친구 초대하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: invitedGroupView.invitedButton)
    }
    
    private func addSubviews() {
        view.addSubview(invitedGroupView)
    }
    
    private func setLayoutConstraintsInvitedGroupView() {
        NSLayoutConstraint.activate([
            invitedGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            invitedGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitedGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invitedGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindIsLoadedMyFriendList()
    }
    
    private func bindIsLoadedMyFriendList() {
        homeViewModel.isLoadedMyFriendList
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedMyFriendList in
                guard isLoadedMyFriendList else { return }
                self?.invitedGroupView.invitedGroupCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}

//MARK: UICollectionViewDataSource
extension InvitedGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.myFriendList?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        guard let myFriendList = homeViewModel.myFriendList else {
            cell.selectedButton.isHidden = true
            cell.friendNicknameLabel.text = "초대할 수 있는 친구가 없어요. 🥲"
            return cell }
        cell.friendNicknameLabel.text = myFriendList[indexPath.row].nickname
        cell.selectedButton.isHidden = false
        cell.rx.didTapSelectedButton
            .asDriver()
            .drive(onNext: { _ in
                guard cell.selectedButton.isSelected else {
                    cell.selectedButton.isSelected = true
                    cell.selectedButton.setImage(UIImage(systemName: "circle.fill"), for: .selected)
                    return
                }
                cell.selectedButton.isSelected = false
                cell.selectedButton.setImage(UIImage(systemName: "circle"), for: .normal)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension InvitedGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 80.0
        return CGSize(width: width, height: height)
    }
}
