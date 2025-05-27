//
//  SpendingDetailsAddViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import Foundation
import UIKit
import RxSwift
import RxGesture

final class SpendingDetailsAddViewController: UIViewController {
    private let spendingDetailAddView = SpendingDetailsAddView()
    private let settleGroupViewModel: SettleGroupViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SettleGroupViewModel = SettleGroupViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         groupID: Int) {
        self.settleGroupViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        settleGroupViewModel.setGroupID(groupID)
        settleGroupViewModel.loadGroupMemberInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettleGroupView()
        addSubviews()
        setLayoutConstraintsSettleGroupView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settleGroupViewModel.loadGroupMemberInformation()
    }
}

extension SpendingDetailsAddViewController {
    private func configureSettleGroupView() {
        spendingDetailAddView.translatesAutoresizingMaskIntoConstraints = false
        spendingDetailAddView.remainderAmountPayUserCollectionView.dataSource = self
        spendingDetailAddView.remainderAmountPayUserCollectionView.delegate = self
        view.backgroundColor = .systemBackground
        navigationItem.title = "지출 내역 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spendingDetailAddView.spendingDetailAddButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spendingDetailAddView.cancelButton)
        navigationController?.navigationBar.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(spendingDetailAddView)
    }
    
    private func setLayoutConstraintsSettleGroupView() {
        NSLayoutConstraint.activate([
            spendingDetailAddView.topAnchor.constraint(equalTo: view.topAnchor),
            spendingDetailAddView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spendingDetailAddView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spendingDetailAddView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func selectClassification(_ view: SpendingDetailsClassificationView, _ otherViews: [SpendingDetailsClassificationView], _ tag: Int) {
        switch tag {
        case 0:
            view.tag = 1
            view.classificationImage.tintColor = UIColor(named: "TitleColor")
            view.classificationLabel.textColor = UIColor(named: "TitleColor")
            guard let classification = view.classificationLabel.text,
                  !classification.isEmpty else { return }
            settleGroupViewModel.selectExpenseClassification(classification)
            otherViews.forEach {
                $0.tag = 0
                $0.classificationImage.tintColor = .systemGray3
                $0.classificationLabel.textColor = .systemGray3
            }
        case 1:
            view.tag = 0
            view.classificationImage.tintColor = .systemGray3
            view.classificationLabel.textColor = .systemGray3
            settleGroupViewModel.deselectExpenseClassification()
        default: return
        }
    }

    
    private func checkAlert(message: String) {
        let alertController = UIAlertController(title: "바로보내", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel)
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
    
    private func bindAll() {
        bindCancelButton()
        bindSpendingDetailsClassificationView()
        bindpSendingDetailAddButton()
        bindIsUploadedExpenseInfo()
        bindIsLoadedGroupMemberInfo()
    }
    
    private func bindCancelButton() {
        spendingDetailAddView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpendingDetailsClassificationView() {
        spendingDetailAddView.trafficClassificationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassificationView = self?.spendingDetailAddView.trafficClassificationView,
                      let accommodationclassificationView = self?.spendingDetailAddView.accommodationClassificationView,
                      let tourismclassificationView = self?.spendingDetailAddView.tourismClassificationView,
                      let foodclassificationView = self?.spendingDetailAddView.foodClassificationView,
                      let etcclassificationView = self?.spendingDetailAddView.etcClassificationView else { return }
                let otherViews = [accommodationclassificationView,
                                  tourismclassificationView,
                                  foodclassificationView,
                                  etcclassificationView]
                self?.selectClassification(trafficClassificationView, otherViews, trafficClassificationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.accommodationClassificationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficclassificationView = self?.spendingDetailAddView.trafficClassificationView,
                      let accommodationclassificationView = self?.spendingDetailAddView.accommodationClassificationView,
                      let tourismclassificationView = self?.spendingDetailAddView.tourismClassificationView,
                      let foodclassificationView = self?.spendingDetailAddView.foodClassificationView,
                      let etcclassificationView = self?.spendingDetailAddView.etcClassificationView else { return }
                let otherViews = [trafficclassificationView,
                                  tourismclassificationView,
                                  foodclassificationView,
                                  etcclassificationView]
                self?.selectClassification(accommodationclassificationView, otherViews, accommodationclassificationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.tourismClassificationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficclassificationView = self?.spendingDetailAddView.trafficClassificationView,
                      let accommodationclassificationView = self?.spendingDetailAddView.accommodationClassificationView,
                      let tourismclassificationView = self?.spendingDetailAddView.tourismClassificationView,
                      let foodclassificationView = self?.spendingDetailAddView.foodClassificationView,
                      let etcclassificationView = self?.spendingDetailAddView.etcClassificationView else { return }
                let otherViews = [trafficclassificationView,
                                  accommodationclassificationView,
                                  foodclassificationView,
                                  etcclassificationView]
                self?.selectClassification(tourismclassificationView, otherViews, tourismclassificationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.foodClassificationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficclassificationView = self?.spendingDetailAddView.trafficClassificationView,
                      let accommodationclassificationView = self?.spendingDetailAddView.accommodationClassificationView,
                      let tourismclassificationView = self?.spendingDetailAddView.tourismClassificationView,
                      let foodclassificationView = self?.spendingDetailAddView.foodClassificationView,
                      let etcclassificationView = self?.spendingDetailAddView.etcClassificationView else { return }
                let otherViews = [trafficclassificationView,
                                  accommodationclassificationView,
                                  tourismclassificationView,
                                  etcclassificationView]
                self?.selectClassification(foodclassificationView, otherViews, foodclassificationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.etcClassificationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficclassificationView = self?.spendingDetailAddView.trafficClassificationView,
                      let accommodationclassificationView = self?.spendingDetailAddView.accommodationClassificationView,
                      let tourismclassificationView = self?.spendingDetailAddView.tourismClassificationView,
                      let foodclassificationView = self?.spendingDetailAddView.foodClassificationView,
                      let etcclassificationView = self?.spendingDetailAddView.etcClassificationView else { return }
                let otherViews = [trafficclassificationView,
                                  accommodationclassificationView,
                                  tourismclassificationView,
                                  foodclassificationView]
                self?.selectClassification(etcclassificationView, otherViews, etcclassificationView.tag)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindpSendingDetailAddButton() {
        spendingDetailAddView.spendingDetailAddButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let date = self?.spendingDetailAddView.datePicker.date,
                      let detailContent = self?.spendingDetailAddView.contentTextField.text,
                      let expense = self?.spendingDetailAddView.paymentTextField.text else { return }
                guard !detailContent.isEmpty,
                      !expense.isEmpty else {
                    self?.checkAlert(message: "상세 내역을 입력하세요!")
                    return
                }
                guard let expenseclassification = self?.settleGroupViewModel.expenseclassification else {
                    self?.checkAlert(message: "지출 내역의 분류를 선택하세요!")
                    return
                }
                guard let remainderUser = self?.settleGroupViewModel.remainderUserID else {
                    self?.checkAlert(message: "나머지 금액을 지불할 친구를 선택하세요!")
                    return
                }
                self?.settleGroupViewModel.uploadExpenseInformation(expenseclassification: expenseclassification, expenseDetail: detailContent, expenseAmount: expense, expenseDate: date, remainderUserID: remainderUser)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUploadedExpenseInfo() {
        settleGroupViewModel.isUploadedExpenseInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext:{[weak self] isUploadedExpenseInfo in
                guard isUploadedExpenseInfo else { return }
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupMemberInfo() {
        settleGroupViewModel.isLoadedGroupMemberInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedGroupMemberInfo in
                guard isLoadedGroupMemberInfo else { return }
                self?.spendingDetailAddView.remainderAmountPayUserCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension SpendingDetailsAddViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settleGroupViewModel.groupMemberInformations?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier, for: indexPath) as? InvitedGroupCollectionViewCell else { return UICollectionViewCell() }
        guard let groupMemberInformations = settleGroupViewModel.groupMemberInformations else { return cell }
        cell.friendNicknameLabel.text = groupMemberInformations[indexPath.row].nickname
        cell.selectedButton.isHidden = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let groupMemberInformations = settleGroupViewModel.groupMemberInformations else { return }
        settleGroupViewModel.selectRemainderAmountUser(userID: groupMemberInformations[indexPath.row].userID)
    }
}

extension SpendingDetailsAddViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width) - 100.0
        let height = 50.0
        return CGSize(width: width, height: height)
    }
}
