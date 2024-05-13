//
//  FriendRequestListViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/6/24.
//

import Foundation
import UIKit
import RxSwift

final class FriendRequestListViewController: UIViewController {
    private let friendReuqestListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        collectionView.register(FriendRequestListCollectionViewCell.self, forCellWithReuseIdentifier: FriendRequestListCollectionViewCell.reuseIdentifier)
        collectionView.register(FriendReuqestListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FriendReuqestListHeaderView.reuseIdentifier)
        return collectionView
    }()
    
    private let friendRequestViewModel = FriendRequestViewModel()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        friendRequestViewModel.getFriendRequestList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFriendRequestView()
        addSubivews()
        setLayoutConstraintsFriendRequestListView()
        bindAll()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        let viewController = FriendRequestViewController()
        return viewController
    }
}

extension FriendRequestListViewController {
    private func configureFriendRequestView() {
        friendReuqestListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        friendReuqestListCollectionView.dataSource = self
        friendReuqestListCollectionView.delegate = self
        view.backgroundColor = .systemBackground
        self.modalPresentationCapturesStatusBarAppearance = true
        self.sheetPresentationController?.prefersGrabberVisible = true
    }
    
    private func addSubivews() {
        view.addSubview(friendReuqestListCollectionView)
    }
    
    private func setLayoutConstraintsFriendRequestListView() {
        NSLayoutConstraint.activate([
            friendReuqestListCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44.0),
            friendReuqestListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendReuqestListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendReuqestListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func confirmAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel) { _ in }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
    
    //MARK: Bind
    private func bindAll() {
        bindIsLoadedFriendRequestListInfo()
        bindIsDeletedFriendRequest()
        bindIsUpdatedFriendRequestState()
    }
    
    private func bindIsLoadedFriendRequestListInfo() {
        friendRequestViewModel.isLoadedFriendRequestListInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedFriendRequestListInfo in
                guard isLoadedFriendRequestListInfo else { return }
                self?.friendReuqestListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedFriendRequest() {
        friendRequestViewModel.isDeletedFriendRequest
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDeletedFrendRequest in
                guard isDeletedFrendRequest else {
                    self?.confirmAlert(title: "바로보내", message: "잠시후 다시 시도해 주세요.")
                    return }
                self?.confirmAlert(title: "바로보내", message: "요청이 삭제되었습니다.")
                self?.friendRequestViewModel.getFriendRequestList()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedFriendRequestState() {
        friendRequestViewModel.isUpdatedFriendRequestState
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedFriendRequestState in
                guard isUpdatedFriendRequestState else {
                    self?.confirmAlert(title: "바로보낸", message: "잠시후 다시 시도해 주세요.")
                    return }
                self?.confirmAlert(title: "바로보내", message: "요청을 수락하였어요.")
                self?.friendReuqestListCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UICollectionViewDataSource
extension FriendRequestListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return friendRequestViewModel.friendRequestSendListInfo?.count ?? 1
        case 1:
            return friendRequestViewModel.friendRequestReceiveListInfo?.count ?? 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendRequestListCollectionViewCell.reuseIdentifier, for: indexPath) as? FriendRequestListCollectionViewCell else { return UICollectionViewCell() }
        switch indexPath.section {
        case 0:
            guard let friendRequestListSendInfo = friendRequestViewModel.friendRequestSendListInfo else { return cell }
            cell.requestCancelButton.isHidden = false
            cell.requestCancelButton.setTitle("요청 취소", for: .normal)
            cell.requestCancelButton.backgroundColor = .lightGray
            cell.friendNicknameLabel.text = friendRequestListSendInfo[indexPath.row].toUserNickname
            cell.rx.didTapRequestCancelButton
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    self?.friendRequestViewModel.deleteFriendRequest(
                        toUserID: friendRequestListSendInfo[indexPath.row].toUserID,
                        fromUserID: friendRequestListSendInfo[indexPath.row].fromUserID
                    )
                })
                .disposed(by: cell.disposeBag)
        case 1:
            guard let friendRequestListReceiveInfo = friendRequestViewModel.friendRequestReceiveListInfo else { return cell }
            cell.requestCancelButton.isHidden = false
            cell.requesetAcceptButton.isHidden = false
            cell.requestCancelButton.setTitle("요청 삭제", for: .normal)
            cell.requestCancelButton.backgroundColor = .systemRed
            cell.friendNicknameLabel.text = friendRequestListReceiveInfo[indexPath.row].fromUserNickname
            cell.rx.didTapRequestCancelButton
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    self?.friendRequestViewModel.deleteFriendRequest(
                        toUserID: friendRequestListReceiveInfo[indexPath.row].toUserID,
                        fromUserID: friendRequestListReceiveInfo[indexPath.row].fromUserID
                    )
                })
                .disposed(by: cell.disposeBag)
            cell.rx.didTapRequestAcceptButton
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    self?.friendRequestViewModel.updateFriendRequestState(
                        toUserID: friendRequestListReceiveInfo[indexPath.row].toUserID,
                        fromUserID: friendRequestListReceiveInfo[indexPath.row].fromUserID)
                })
                .disposed(by: cell.disposeBag)
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FriendReuqestListHeaderView.reuseIdentifier,
                for: indexPath
              ) as? FriendReuqestListHeaderView else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            header.label.text = "내가 보낸 친구 요청"
        case 1:
            header.label.text = "내가 받은 친구 요청"
        default:
            return header
        }
        return header
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout
extension FriendRequestListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 60.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 20.0
        return CGSize(width: width, height: height)
    }
}
