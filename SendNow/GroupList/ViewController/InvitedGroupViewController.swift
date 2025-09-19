//
//  InvitedGroupViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import Foundation
import UIKit
import RxSwift

final class InvitedGroupViewController: BaseUIViewController {
    private let invitedGroupView = InvitedGroupView()
    private let homeViewModel: HomeViewModel
    private let groupListViewModel: GroupListViewModel
    private let disposeBag = DisposeBag()
    
    init(homeViewModel: HomeViewModel = HomeViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         groupListViewModel: GroupListViewModel = GroupListViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))) {
        self.homeViewModel = homeViewModel
        self.groupListViewModel = groupListViewModel
        super.init(nibName: nil, bundle: nil)
        self.homeViewModel.loadMyFriend()
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
//        groupListViewModel.removeSelectedFriend()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        let viewController = GroupListViewController()
        return viewController
    }
}

extension InvitedGroupViewController {
    private func configureInvitedGroupView() {
        invitedGroupView.translatesAutoresizingMaskIntoConstraints = false
        invitedGroupView.invitedGroupCollectionView.delegate = self
        invitedGroupView.invitedGroupCollectionView.dataSource = self
        invitedGroupView.remainderUserCollectionView.delegate = self
        invitedGroupView.remainderUserCollectionView.dataSource = self
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleColor")
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
                self?.groupListViewModel.checkSelectedFriend()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedMyFriendList() {
        homeViewModel.isLoadedMyFriendList
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedMyFriendListResult in
                switch isLoadedMyFriendListResult {
                case .success():
                    self?.invitedGroupView.invitedGroupCollectionView.reloadData()
                    self?.invitedGroupView.remainderUserCollectionView.reloadData()
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsExistedInvitedFriend() {
        groupListViewModel.isExistedInvitedFriend
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isExistedInvitedFriend in
                guard let viewModel = self?.groupListViewModel else { return }
                guard isExistedInvitedFriend else {
                    self?.invitedAlert(message: "초대할 친구를 선택해 주세요.", viewModel: viewModel)
                    return
                }
                self?.invitedAlert(viewModel: viewModel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsInvitedFriendToGroup() {       
        groupListViewModel.isInvitedFriendToGroup
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isInvitedFriendToGroup in
                guard isInvitedFriendToGroup else { return }
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: cellForRowAt Method
    private func configureInvitedGroupCollectionView(_ cell: InvitedGroupCollectionViewCell, _ indexPath: IndexPath) {
        guard let myFriendList = homeViewModel.myFriendList else { return }
        cell.friendNicknameLabel.text = myFriendList.isEmpty  ? "초대할 수 있는 친구가 없어요." : myFriendList[indexPath.row].nickname
        cell.selectedButton.isHidden = myFriendList.isEmpty
    }
    
    private func configureRemainderUserCollectionView(_ cell: InvitedGroupCollectionViewCell, _ indexPath: IndexPath) {
        guard let remainderCandiateList = homeViewModel.remainderCandidateList else { return }
        cell.friendNicknameLabel.text = remainderCandiateList.isEmpty ? "초대할 수 있는 친구가 없어요." : remainderCandiateList[indexPath.row].nickname
        cell.selectedButton.isHidden = remainderCandiateList.isEmpty
    }

}

//MARK: UICollectionViewDataSource
extension InvitedGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case invitedGroupView.invitedGroupCollectionView:
            guard let listCount = homeViewModel.myFriendList?.count,
                  listCount != 0 else { return 1 }
            return listCount
        case invitedGroupView.remainderUserCollectionView:
            guard let listCount = homeViewModel.remainderCandidateList?.count,
                  listCount != 0 else { return 1 }
            return listCount
        default: return 1
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.invitedGroupView.invitedGroupCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
            configureInvitedGroupCollectionView(cell, indexPath)
            return cell
            
        case self.invitedGroupView.remainderUserCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
            configureRemainderUserCollectionView(cell, indexPath)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InvitedGroupCollectionViewCell else { return }
        
        switch collectionView {
        case self.invitedGroupView.invitedGroupCollectionView:
            guard let myFriendList = homeViewModel.myFriendList,
                  !myFriendList.isEmpty else { return }
            if cell.selectedButton.isSelected {
                cell.selectedButton.isSelected = false
                cell.selectedButton.setImage(UIImage(systemName: "circle"), for: .normal)
                groupListViewModel.deselectInvitedFriend(friendUserID: myFriendList[indexPath.row].userID)
            } else {
                cell.selectedButton.isSelected = true
                cell.selectedButton.setImage(UIImage(systemName: "circle.fill"), for: .selected)
                groupListViewModel.selectInvitedFriend(friendUserID: myFriendList[indexPath.row].userID)
            }
            
        case self.invitedGroupView.remainderUserCollectionView:
            guard let remainderCandidateList = homeViewModel.remainderCandidateList,
                  !remainderCandidateList.isEmpty else { return }
            groupListViewModel.selectRemainderUserID(remainderCandidateList[indexPath.row].userID)
            
        default: return
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension InvitedGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.invitedGroupView.invitedGroupCollectionView:
            let width = (UIScreen.main.bounds.width) - 36.0
            let height = 80.0
            return CGSize(width: width, height: height)
        case self.invitedGroupView.remainderUserCollectionView:
            let width = (UIScreen.main.bounds.width) - 36.0
            let height = 80.0
            return CGSize(width: width, height: height)
        default: return CGSize(width: 0, height: 0)
        }
    }
}
