//
//  SpendingDetailsViewController.swift
//  SendNow
//
//  Created by 한소희 on 2/28/25.
//

import Foundation
import UIKit
import RxSwift

final class SpendingDetailsViewController: UIViewController {
    private let spendingDetailsView = SpendingDetailsAddView()
    private let settleGroupViewModel: SettleGroupViewModel
    private let disposeBag = DisposeBag()
    
    private let updateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        button.tag = 0
        return button
    }()
    
    private let saveButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    private let deleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        button.backgroundColor = .red
        button.layer.cornerRadius = 12.0
        button.isEnabled = false
        button.isHidden = true
        return button
    }()
    
    init(settleGroupViewModel: SettleGroupViewModel = SettleGroupViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         expenseID: Int,
         groupID: Int) {
        self.settleGroupViewModel = settleGroupViewModel
        super.init(nibName: nil, bundle: nil)
        self.settleGroupViewModel.setGroupID(groupID)
        self.settleGroupViewModel.setExpenseID(expenseID)
        self.settleGroupViewModel.loadGroupMemberInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpendingDetailsView()
        addSubviews()
        setLayoutConstraintsSpendingDetailsView()
        bindAll()
    }
}

extension SpendingDetailsViewController {
    private func configureSpendingDetailsView() {
        spendingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        spendingDetailsView.remainderAmountPayUserCollectionView.delegate = self
        spendingDetailsView.remainderAmountPayUserCollectionView.dataSource = self
        spendingDetailsView.spendingDetailAddButton.setTitle("수정", for: .normal)
        view.backgroundColor = .secondarySystemBackground
        self.navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spendingDetailsView.cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: updateButton)
        navigationItem.title = "지출 상세 내역"
    }
    
    private func addSubviews() {
        [
            spendingDetailsView,
            saveButton,
            deleteButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayoutConstraintsSpendingDetailsView() {
        NSLayoutConstraint.activate([
            spendingDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spendingDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            spendingDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            saveButton.topAnchor.constraint(equalTo: spendingDetailsView.bottomAnchor, constant: 24.0),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36.0),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -16.0),
            saveButton.heightAnchor.constraint(equalToConstant: 50.0),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24.0),
            
            deleteButton.topAnchor.constraint(equalTo: saveButton.topAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 16.0),
            deleteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36.0),
            deleteButton.heightAnchor.constraint(equalTo: saveButton.heightAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor)
        ])
    }
    
    // MARK: Bind
    private func bindAll() {
        bindUpdateButton()
        bindCancelButton()
        bindIsLoadedGroupMemberInfo()
        bindLoadedGroupExpenseDetailInfoSubject()
    }
    
    private func bindUpdateButton() {
        updateButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                [
                    self?.saveButton,
                    self?.deleteButton
                ]
                    .compactMap { $0 }
                    .forEach {
                        $0.isEnabled = true
                        $0.isHidden = false
                    }
                self?.updateButton.tag = 1
                self?.updateButton.isHidden = true
                self?.updateButton.isEnabled = false
                self?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

//                self?.updateButton.setTitle("수정 완료", for: .normal)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCancelButton() {
        spendingDetailsView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                [
                    self?.saveButton,
                    self?.deleteButton
                ]
                    .compactMap { $0 }
                    .forEach {
                        $0.isEnabled = false
                        $0.isHidden = true
                    }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupMemberInfo() {
        settleGroupViewModel.isLoadedGroupMemberInfo
            .subscribe(onNext: {[weak self] isLoadedGroupMemberInfo in
                guard isLoadedGroupMemberInfo,
                      let expenseID = self?.settleGroupViewModel.expenseID else { return }
                self?.settleGroupViewModel.loadExpenseDetailInformation(expenseID)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadedGroupExpenseDetailInfoSubject() {
        settleGroupViewModel.loadedGroupExpenseDetailInfoSubject
            .asDriver(onErrorJustReturn: Void())
            .drive(onNext: {[weak self] _ in
                guard let expenseDetailInfo = self?.settleGroupViewModel.expenseDetailInformation,
                      let groupMemberInfo = self?.settleGroupViewModel.groupMemberInformations else { return }
                self?.spendingDetailsView.configureSpendingDetailView(expenseDetailInfo)
                self?.spendingDetailsView.remainderAmountPayUserCollectionView.reloadData()
                if let index = groupMemberInfo.firstIndex(where: {$0.userID == expenseDetailInfo.remainderUserID }) {
                    let indexPath = IndexPath(item: index, section: 0)
                    self?.spendingDetailsView.remainderAmountPayUserCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Alert
    private func cancelAlert() {
        
    }
    
    private func saveAlert() {
        
    }
}

extension SpendingDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settleGroupViewModel.groupMemberInformations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        guard let groupMemberInformations = settleGroupViewModel.groupMemberInformations else { return cell }
//              let expenseDetailInfo = settleGroupViewModel.expenseDetailInformation else { return cell }
        cell.friendNicknameLabel.text = groupMemberInformations[indexPath.row].nickname
        cell.selectedButton.isHidden = false
        return cell
    }
}

extension SpendingDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 100
        let height = 50.0
        return CGSize(width: width, height: height)
    }
}
