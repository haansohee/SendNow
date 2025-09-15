//
//  SettleGroupInitViewController.swift
//  SendNow
//
//  Created by 한소희 on 7/21/25.
//

import Foundation
import UIKit

final class SettleGroupInitViewController: BaseUIViewController {
    private let settleGroupInitView = SettleGroupInitView()
    private let groupListViewModel: GroupListViewModel
    
    init(groupListViewModel: GroupListViewModel = GroupListViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         invitedFriendList: [Int]) {
        self.groupListViewModel = groupListViewModel
        super.init(nibName: nil, bundle: nil)
        self.groupListViewModel.setInvitedFriendList(friendList: invitedFriendList)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SettleGroupInitViewController {
    // MARK: Configure
    private func configureSettleGroupInitViewContrller() {
        self.isModalInPresentation = true
        self.modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .clear
        settleGroupInitView.translatesAutoresizingMaskIntoConstraints = false
        settleGroupInitView.layer.cornerRadius = 10.0
    }
    
    private func addSubview() {
        view.addSubview(settleGroupInitView)
    }
}
