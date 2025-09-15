//
//  SettleGroupViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import Foundation
import UIKit
import RxSwift
import Toast

final class SettleGroupViewController: BaseUIViewController {
    private let settleGroupView = SettleGroupView()
    private let settleGroupViewModel: SettleGroupViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SettleGroupViewModel = SettleGroupViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         groupID: Int? = nil) {
        self.settleGroupViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        guard let id = groupID else { return }
        settleGroupViewModel.setGroupID(id)
        settleGroupViewModel.loadGroupExpenseInformation()
        settleGroupViewModel.loadGroupCreatorID()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load : SettleGroupViewController")
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
        view.backgroundColor = .secondarySystemBackground
        navigationController?.topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settleGroupView.groupRemoveButton)
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
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceived), name: NSNotification.Name(NotificationName.uploadExpense.rawValue), object: nil)
    }
    
    @objc private func dataReceived() {
        settleGroupViewModel.loadGroupExpenseInformation()
    }
    
    private func bindAll() {
        bindGroupRemoveButton()
        bindSpendingDetailAddButton()
        bindIsLoadedGroupExpenseInfo()
        bindIsEqualCreatorUserID()
        bindIsDeletedGroup()
    }
    private func bindGroupRemoveButton() {
        settleGroupView.groupRemoveButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.confirmAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpendingDetailAddButton() {
        settleGroupView.spendingDetailAddButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let groupID = self?.settleGroupViewModel.groupID else { return }
                let spendingDetailViewController = UINavigationController(rootViewController: SpendingDetailsAddViewController(groupID: groupID))
                spendingDetailViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self?.present(spendingDetailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupExpenseInfo() {
        settleGroupViewModel.groupExpenseInfoSubject
            .asDriver(onErrorJustReturn: ("0", "0"))
            .drive(onNext: {[weak self] group, personal in
                self?.settleGroupView.spendingDetailCollectionView.reloadData()
                self?.settleGroupView.configurePaymentLabel(group: group, personal: personal)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsEqualCreatorUserID() {
        settleGroupViewModel.isEqualGroupCreatorSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isEqualCreatorUserID in
                self?.settleGroupView.groupRemoveButton.isEnabled = isEqualCreatorUserID
                self?.settleGroupView.groupRemoveButton.setTitle(isEqualCreatorUserID ? "그룹 삭제" : "", for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeletedGroup() {
        settleGroupViewModel.isDeletedGroup
            .subscribe(onNext: {[weak self] isDeletedGroup in
                guard isDeletedGroup else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }, onError: { error in
                print("ERROR")
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Alert
    private func confirmAlert() {
        let alertController = UIAlertController(title: "바로보내", message: "해당 그룹을 정말 삭제할까요? \n ⚠️ 삭제된 데이터는 복구되지 않습니다.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .destructive) {[weak self] _ in
            self?.settleGroupViewModel.deleteGroup()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {[weak self] in
            self?.present(alertController, animated: true)
        }
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let groupExpenseInformations = settleGroupViewModel.groupExpenseInformations,
              let groupExpensDetailInformations = groupExpenseInformations.expenseInformations else { return }
        let expenseID = groupExpensDetailInformations[indexPath.row].expenseID
        let groupID = groupExpensDetailInformations[indexPath.row].groupID
        let expenseClassfication = groupExpensDetailInformations[indexPath.row].expenseClassfication
        let expenseDate = groupExpensDetailInformations[indexPath.row].expenseDate
        let expenseDetails = groupExpensDetailInformations[indexPath.row].expenseDetails
        let viewController = SpendingDetailsViewController(
            expenseID: expenseID,
            groupID: groupID,
            expenseClassfication: expenseClassfication,
            expenseDate: expenseDate,
            expenseDetails: expenseDetails
        )
        navigationController?.pushViewController(viewController, animated: true)
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
