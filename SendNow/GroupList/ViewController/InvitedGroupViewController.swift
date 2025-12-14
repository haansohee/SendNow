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
    
    init(
        homeViewModel: HomeViewModel = HomeViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
        groupListViewModel: GroupListViewModel = GroupListViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))
    ) {
        self.homeViewModel = homeViewModel
        self.groupListViewModel = groupListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel.loadMyFriend()
        configureInvitedGroupView()
        addSubviews()
        setLayoutConstraintsInvitedGroupView()
        addInvitedFriendSuccess()
        bindAll()
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
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleColor")
        navigationItem.title = "친구 초대하기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: invitedGroupView.nextButton)
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
    
    //MARK: Observer
    private func addInvitedFriendSuccess() {
        NotificationCenter.default.addObserver(self, selector: #selector(invitedFriendSuccessSelector), name: Notification.Name(NotificationName.invitedFriend.rawValue), object: nil)
    }
    
    @objc private func invitedFriendSuccessSelector() {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Bind
    private func bindAll() {
        bindInvitedButton()
        bindIsLoadedMyFriendList()
        bindIsInvitedFriendToGroup()
    }
    
    private func bindInvitedButton() {
        invitedGroupView.nextButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let viewModel = self?.groupListViewModel else { return }
                let invitedFriendList = viewModel.invitedFriendList
                guard !invitedFriendList.isEmpty else {
                    self?.invitedAlert(message: "초대할 친구를 선택해 주세요.")
                    return }
                self?.present(SettleGroupInitViewController(invitedFriendList: invitedFriendList), animated: true)
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
                case .failure(_):
                    self?.serverErrorAlert()
                }
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
        cell.selectedImage.isHidden = myFriendList.isEmpty
    }

}

//MARK: UICollectionViewDataSource
extension InvitedGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let listCount = homeViewModel.myFriendList?.count,
              listCount != 0 else { return 1 }
        return listCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        guard let myFriendList = homeViewModel.myFriendList,
              !myFriendList.isEmpty,
              let myFriend = myFriendList[safe: indexPath.row] else {
            cell.configureCollectionViewCellAttributes(isEmpty: true, nickname: "")
            return cell
        }
        cell.configureCollectionViewCellAttributes(isEmpty: false, nickname: myFriend.nickname)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? InvitedGroupCollectionViewCell,
              let myFriendList = homeViewModel.myFriendList,
              !myFriendList.isEmpty,
              let myFriend = myFriendList[safe: indexPath.row] else { return }
        let isSelectedFriend = cell.selectedImage.tag == 1
        cell.selectedImage.tag = isSelectedFriend ? 0 : 1
        cell.selectedImage.image = isSelectedFriend ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        guard isSelectedFriend else {
            groupListViewModel.deselectInvitedFriend(friendUserID: myFriend)
            return
        }
        groupListViewModel.selectInvitedFriend(friendUserID: myFriend)
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
