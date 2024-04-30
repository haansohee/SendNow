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
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInvitedGroupView()
        addSubviews()
        setLayoutConstraintsInvitedGroupView()
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

}

//MARK: UICollectionViewDataSource
extension InvitedGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        
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
