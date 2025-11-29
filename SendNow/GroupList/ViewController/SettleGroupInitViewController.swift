//
//  SettleGroupInitViewController.swift
//  SendNow
//
//  Created by 한소희 on 7/21/25.
//

import Foundation
import UIKit
import RxSwift

final class SettleGroupInitViewController: BaseUIViewController {
    private let settleGroupInitView = SettleGroupInitView()
    private let groupListViewModel: GroupListViewModel
    private let disposeBag = DisposeBag()
    
    init(groupListViewModel: GroupListViewModel = GroupListViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         invitedFriendList: [MyFriendListDomain]) {
        self.groupListViewModel = groupListViewModel
        super.init(nibName: nil, bundle: nil)
        self.groupListViewModel.setInvitedFriendList(friendList: invitedFriendList)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupListViewModel.loadSelectedFriendList()
        addSubview()
        configureSettleGroupInitViewContrller()
        setLayoutConstraintsSettleGroupInitView()
        bindAll()
    }
}

extension SettleGroupInitViewController {
    // MARK: Configure
    private func configureSettleGroupInitViewContrller() {
        self.isModalInPresentation = true
        self.modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .clear
        settleGroupInitView.remainderUserCollectionView.delegate = self
        settleGroupInitView.remainderUserCollectionView.dataSource = self
        settleGroupInitView.translatesAutoresizingMaskIntoConstraints = false
        settleGroupInitView.layer.cornerRadius = 10.0
    }
    
    private func addSubview() {
        view.addSubview(settleGroupInitView)
    }
    
    private func setLayoutConstraintsSettleGroupInitView() {
        NSLayoutConstraint.activate([
            settleGroupInitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100.0),
            settleGroupInitView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            settleGroupInitView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            settleGroupInitView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100.0)
        ])
    }
    
    private func bindAll() {
        bindDoneButton()
        bindCancelButton()
        bindIsInvitedFriendToGroup()
    }
    
    private func bindDoneButton() {
        settleGroupInitView.doneButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                let groupName = self?.settleGroupInitView.groupNameTextField.text ?? ""
                guard let remainderUser = self?.groupListViewModel.remainderUserID else { return }
                self?.groupListViewModel.invitedFriendToGroup(groupName: groupName, remainderUserID: remainderUser)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCancelButton() {
        settleGroupInitView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsInvitedFriendToGroup() {
        groupListViewModel.isInvitedFriendToGroup
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isInvitedFriendToGroup in
                guard isInvitedFriendToGroup else { return }
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension SettleGroupInitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let invitedFriendListCount = groupListViewModel.invitedFriendList.count
        return invitedFriendListCount != 0 ? invitedFriendListCount : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RemainderUserCollectionViewCell.reuseIdentifier, for: indexPath) as? RemainderUserCollectionViewCell else { return UICollectionViewCell() }
        
        let invitedFriendList = groupListViewModel.invitedFriendList
        guard let invitedFriend = invitedFriendList[safe: indexPath.row] else { return cell }
        cell.configureNicknameLabel(invitedFriend.nickname)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RemainderUserCollectionViewCell else { return }
        let invitedFriendList = groupListViewModel.invitedFriendList
        guard let selectedFriendInfo = invitedFriendList[safe: indexPath.row] else { return }
        cell.contentView.backgroundColor = .secondarySystemBackground
        settleGroupInitView.doneButton.backgroundColor = UIColor(named: "TitleColor")
        settleGroupInitView.doneButton.isEnabled = true
        groupListViewModel.selectRemainderUserID(selectedFriendInfo.userID)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RemainderUserCollectionViewCell else { return }
        cell.contentView.backgroundColor = .systemBackground
    }
}

extension SettleGroupInitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (settleGroupInitView.bounds.width) - 50.0
        let height = 60.0
        return CGSize(width: width, height: height)
    }
}
