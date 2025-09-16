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

final class SpendingDetailsAddViewController: BaseUIViewController {
    private let spendingDetailAddView = SpendingDetailsAddView()
    private let settleGroupViewModel: SettleGroupViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SettleGroupViewModel = SettleGroupViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         groupID: Int) {
        self.settleGroupViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        settleGroupViewModel.setGroupID(groupID)
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
//        settleGroupViewModel.loadGroupMemberInformation()
    }
}

extension SpendingDetailsAddViewController {
    private func configureSettleGroupView() {
        spendingDetailAddView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        navigationItem.title = "지출 내역 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spendingDetailAddView.spendingDetailAddButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spendingDetailAddView.cancelButton)
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
    
    private func selectClassfication(_ view: SpendingDetailsclassficationView, _ otherViews: [SpendingDetailsclassficationView], _ tag: Int) {
        switch tag {
        case 0:
            view.tag = 1
            view.classficationImage.tintColor = UIColor(named: "TitleColor")
            view.classficationLabel.textColor = UIColor(named: "TitleColor")
            guard let classfication = view.classficationLabel.text,
                  !classfication.isEmpty else { return }
            settleGroupViewModel.selectExpenseClassfication(classfication)
            otherViews.forEach {
                $0.tag = 0
                $0.classficationImage.tintColor = .systemGray3
                $0.classficationLabel.textColor = .systemGray3
            }
        case 1:
            view.tag = 0
            view.classficationImage.tintColor = .systemGray3
            view.classficationLabel.textColor = .systemGray3
            settleGroupViewModel.deselectexpenseClassfication()
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
        bindSpendingDetailsclassficationView()
        bindpSendingDetailAddButton()
        bindIsUploadedExpenseInfo()
    }
    
    private func bindCancelButton() {
        spendingDetailAddView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpendingDetailsclassficationView() {
        spendingDetailAddView.trafficclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let otherViews = [self.spendingDetailAddView.accommodationclassficationView,
                                  self.spendingDetailAddView.tourismclassficationView,
                                  self.spendingDetailAddView.foodclassficationView,
                                  self.spendingDetailAddView.etcclassficationView]
                self.selectClassfication(self.spendingDetailAddView.trafficclassficationView,
                                         otherViews,
                                         self.spendingDetailAddView.trafficclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.accommodationclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let otherViews = [self.spendingDetailAddView.trafficclassficationView,
                                  self.spendingDetailAddView.tourismclassficationView,
                                  self.spendingDetailAddView.foodclassficationView,
                                  self.spendingDetailAddView.etcclassficationView]
                self.selectClassfication(self.spendingDetailAddView.accommodationclassficationView,
                                         otherViews,
                                         self.spendingDetailAddView.accommodationclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.tourismclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let otherViews = [self.spendingDetailAddView.trafficclassficationView,
                                  self.spendingDetailAddView.accommodationclassficationView,
                                  self.spendingDetailAddView.foodclassficationView,
                                  self.spendingDetailAddView.etcclassficationView]
                self.selectClassfication(self.spendingDetailAddView.tourismclassficationView,
                                         otherViews,
                                         self.spendingDetailAddView.tourismclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.foodclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let otherViews = [self.spendingDetailAddView.trafficclassficationView,
                                  self.spendingDetailAddView.accommodationclassficationView,
                                  self.spendingDetailAddView.tourismclassficationView,
                                  self.spendingDetailAddView.etcclassficationView]
                self.selectClassfication(self.spendingDetailAddView.foodclassficationView,
                                         otherViews,
                                         self.spendingDetailAddView.foodclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.etcclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                let otherViews = [self.spendingDetailAddView.trafficclassficationView,
                                  self.spendingDetailAddView.accommodationclassficationView,
                                  self.spendingDetailAddView.tourismclassficationView,
                                  self.spendingDetailAddView.foodclassficationView]
                self.selectClassfication(self.spendingDetailAddView.etcclassficationView,
                                          otherViews,
                                          self.spendingDetailAddView.etcclassficationView.tag)
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
                guard let expenseClassfication = self?.settleGroupViewModel.expenseClassfication else {
                    self?.checkAlert(message: "지출 내역의 분류를 선택하세요!")
                    return
                }
                
                self?.settleGroupViewModel.uploadExpenseInformation(expenseClassfication: expenseClassfication, expenseDetail: detailContent, expenseAmount: expense, expenseDate: date)
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
}
