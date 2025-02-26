//
//  MyPageViewController.swift
//  SendNow
//
//  Created by 한소희 on 2/27/25.
//

import Foundation
import UIKit
import RxSwift

final class MyPageViewController: UIViewController {
    private let myPageCollectionView = MyPageCollectionView()
    let memberInfoUpdateViewModel: MemberInfoUpdateViewModel
    
    init(
        memberInfoUpdateViewModel: MemberInfoUpdateViewModel = MemberInfoUpdateViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue),
        signinType: SigninType(
            rawValue: UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue) ?? "") ?? .default)
    ) {
        self.memberInfoUpdateViewModel = memberInfoUpdateViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMyPageView()
        addSubviews()
        setLayoutConstraintsMyPageCollectionView()
    }
}

extension MyPageViewController {
    private func configureMyPageView() {
        myPageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myPageCollectionView.delegate = self
        myPageCollectionView.dataSource = self
        view.backgroundColor = .secondarySystemBackground
        navigationItem.title = "내 정보"
    }
    
    private func addSubviews() {
        view.addSubview(myPageCollectionView)
    }
    
    private func setLayoutConstraintsMyPageCollectionView() {
        NSLayoutConstraint.activate([
            myPageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            myPageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myPageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            myPageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: UICollectionViewDataSource
extension MyPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier, for: indexPath) as? MyPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureTitleLabel(memberInfoUpdateViewModel.myPageItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = MemberInfoUpdateViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = PrivacyPolicyViewController()
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        default:
            return
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 24.0
        let height = 70.0
        return CGSize(width: width, height: height)
    }
}
