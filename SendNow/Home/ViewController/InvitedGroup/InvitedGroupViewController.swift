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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        homeViewModel.removeSelectedFriend()
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
        view.backgroundColor = UIColor(named: "BackColor")
        navigationItem.title = "친구 초대하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: invitedGroupView.invitedButton)
        self.modalPresentationCapturesStatusBarAppearance = true
        self.sheetPresentationController?.prefersGrabberVisible = true
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
    
    private func invitedAlert(message: String? = nil) {
        guard let alertMessage = message else {
            let alertController = UIAlertController(title: "바로보내", message: "모임 이름을 입력해 주세요.", preferredStyle: .alert)
            alertController.addTextField()
            let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
                guard let groupNameText = alertController.textFields?[0].text,
                      !groupNameText.isEmpty else { return }
                self?.homeViewModel.invitedFriendToGroup(groupName: groupNameText)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in }
            alertController.addAction(doneAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true)
            return
        }
        let alertController = UIAlertController(title: "바로보내", message: alertMessage, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) { _ in }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
    
    
    //MARK: Bind
    private func bindAll() {
        bindInvitedButton()
        bindIsLoadedMyFriendList()
        bindIsExistedInvitedFriend()
        bindIsInvitedFriendToGroup()
    }
    
    private func bindInvitedButton() {
        invitedGroupView.invitedButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.homeViewModel.checkSelectedFriend()
            })
            .disposed(by: disposeBag)
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
    
    private func bindIsExistedInvitedFriend() {
        homeViewModel.isExistedInvitedFriend
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isExistedInvitedFriend in
                guard isExistedInvitedFriend else {
                    self?.invitedAlert(message: "초대할 친구를 선택해 주세요.")
                    return
                }
                self?.invitedAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsInvitedFriendToGroup() {
        homeViewModel.isInvitedFriendToGroup
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isInvitedFriendToGroup in
                self?.homeViewModel.removeSelectedFriend()
                guard isInvitedFriendToGroup else { return }
                NotificationCenter.default.post(name: NSNotification.Name("invitedFriend"), object: isInvitedFriendToGroup)
                self?.dismiss(animated: true)
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
            .drive(onNext: {[weak self] _ in
                guard cell.selectedButton.isSelected else {
                    cell.selectedButton.isSelected = true
                    cell.selectedButton.setImage(UIImage(systemName: "circle.fill"), for: .selected)
                    self?.homeViewModel.selectInvitedFriend(friendUserID: myFriendList[indexPath.row].userID)
                    return
                }
                cell.selectedButton.isSelected = false
                cell.selectedButton.setImage(UIImage(systemName: "circle"), for: .normal)
                self?.homeViewModel.deselectInvitedFriend(friendUserID: myFriendList[indexPath.row].userID)
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
