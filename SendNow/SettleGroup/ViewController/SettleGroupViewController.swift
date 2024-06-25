//
//  SettleGroupViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import Foundation
import UIKit
import RxSwift

final class SettleGroupViewController: UIViewController {
    private let settleGroupView = SettleGroupView()
    private let settleGroupViewModel = SettleGroupViewModel()
    private let disposeBag = DisposeBag()
    
    init(groupID: Int) {
        super.init(nibName: nil, bundle: nil)
        settleGroupViewModel.setGroupID(groupID)
        settleGroupViewModel.loadGroupExpenseInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettleGroupView()
        addSubviews()
        setLayoutConstraintsSettleGroupView()
        notificationInvitedFriendObsever()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settleGroupViewModel.loadGroupExpenseInformation()
    }
}

extension SettleGroupViewController {
    private func configureSettleGroupView() {
        settleGroupView.translatesAutoresizingMaskIntoConstraints = false
        settleGroupView.spendingDetailCollectionView.dataSource = self
        settleGroupView.spendingDetailCollectionView.delegate = self
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(settleGroupView)
    }
    
    private func setLayoutConstraintsSettleGroupView() {
        NSLayoutConstraint.activate([
            settleGroupView.topAnchor.constraint(equalTo: view.topAnchor),
            settleGroupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settleGroupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settleGroupView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func notificationInvitedFriendObsever() {
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: NSNotification.Name("uploadExpense"), object: nil)
    }
    
    @objc private func dataReceived() {
        settleGroupViewModel.loadGroupExpenseInformation()
    }
    
    private func bindAll() {
        bindSpendingDetailAddButton()
        bindIsLoadedGroupExpenseInfo()
    }
    
    private func bindSpendingDetailAddButton() {
        settleGroupView.spendingDetailAddButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let groupID = self?.settleGroupViewModel.groupID else { return }
                let spendingDetailViewController = UINavigationController(rootViewController: SpendingDetailsAddViewController(groupID: groupID))
                self?.present(spendingDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupExpenseInfo() {
        settleGroupViewModel.isLoadedGroupExpenseInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedGroupExpenseInfo in
                guard isLoadedGroupExpenseInfo else { return }
                self?.settleGroupView.spendingDetailCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SettleGroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settleGroupViewModel.groupExpenseInformations?.expenseInformations?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpendingDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? SpendingDetailCollectionViewCell else { return UICollectionViewCell() }
        guard let groupExpenseInformations = settleGroupViewModel.groupExpenseInformations,
              let groupExpenseDetailInformations = settleGroupViewModel.groupExpenseInformations?.expenseInformations else { return cell }
        cell.setSpendingDetailCollectionViewCellLabel(groupExpenseInfo: groupExpenseDetailInformations[indexPath.row])
        guard let myExpenses = groupExpenseInformations.myExpenses,
              let groupExpenses = groupExpenseInformations.groupExpenses else { return cell }
        settleGroupView.myTotalContentLabel.text = "\(myExpenses)원"
        settleGroupView.groupTotalContentLabel.text = "\(groupExpenses)원"
        return cell
    }
    
    
}

extension SettleGroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 36.0
        let height = 80.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
