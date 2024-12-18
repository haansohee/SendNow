//
//  FriendRequestViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import Foundation
import UIKit
import RxSwift

final class FriendRequestViewController: UIViewController {
    private let friendRequestView = FriendRequestView()
    private let friendRequestViewModel: FriendRequestViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: FriendRequestViewModel = FriendRequestViewModel(userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))) {
        self.friendRequestViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFriendRequestView()
        addSubivews()
        setLayoutConstraintsFriendRequestView()
        bindAll()
    }
}

extension FriendRequestViewController {
    private func configureFriendRequestView() {
        friendRequestView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        navigationItem.title = "친구 추가하기"
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleColor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: friendRequestView.requestListButton)
    }
    
    private func addSubivews() {
        view.addSubview(friendRequestView)
    }
    
    private func setLayoutConstraintsFriendRequestView() {
        NSLayoutConstraint.activate([
            friendRequestView.topAnchor.constraint(equalTo: view.topAnchor),
            friendRequestView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendRequestView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            friendRequestView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindSearchButton()
        bindRequestListButton()
        bindFriendRequestButton()
        bindIsEmptySearchFriend()
        bindIsSendedFriendRequest()
    }
    
    private func bindSearchButton() {
        friendRequestView.searchButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let friendNickname = self?.friendRequestView.friendNicknameTextField.text,
                      !friendNickname.isEmpty else { return }
//                self?.friendRequestView.searchResultLabel.text = "검색 중..."
                self?.friendRequestViewModel.searchFriendNickname(nickname: friendNickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRequestListButton() {
        friendRequestView.requestListButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.present(FriendRequestListViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindFriendRequestButton() {
        friendRequestView.friendRequestButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let friendUserID = self?.friendRequestViewModel.searchFriendInformation?.userID else { return }
                self?.friendRequestViewModel.sendFriendRequest(toUserID: friendUserID)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsEmptySearchFriend() {
        friendRequestViewModel.isEmptySearchFriend
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isEmptySearchFriend in
                self?.friendRequestView.searchResultLabel.text = "검색 결과 🔍"
                guard isEmptySearchFriend else {
                    self?.friendRequestView.searchResultFriendLabel.text = "해당 아이디의 회원이 존재하지 않아요. 🥲"
                    self?.friendRequestView.friendRequestButton.isHidden = true
                    return
                }
                guard let searchFriendInfo = self?.friendRequestViewModel.searchFriendInformation else { return }
                self?.friendRequestView.searchResultFriendLabel.text = searchFriendInfo.nickname
                self?.friendRequestView.friendRequestButton.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSendedFriendRequest() {
        friendRequestViewModel.isSendedFriendRequest
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSendedFriendRequest in
                guard isSendedFriendRequest else {
                    self?.confirmAlert(title: "바로보내", message: "이미 친구인 회원이에요.")
                    return }
                self?.confirmAlert(title: "바로보내", message: "친구 요청이 완료되었어요.")
            })
            .disposed(by: disposeBag)
    }
}
