//
//  SpendingDetailsViewController.swift
//  SendNow
//
//  Created by 한소희 on 2/28/25.
//

import Foundation
import UIKit
import RxSwift

final class SpendingDetailsViewController: BaseUIViewController {
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
    
    private let backButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("< 뒤로가기", for: .normal)
        button.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .light)
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
    
    init(
        settleGroupViewModel: SettleGroupViewModel = SettleGroupViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
        expenseID: Int,
        groupID: Int,
        expenseClassfication: String,
        expenseDate: String,
        expenseDetails: String,
        isActiveSettlement: Bool
    ) {
        self.settleGroupViewModel = settleGroupViewModel
        super.init(nibName: nil, bundle: nil)
        self.settleGroupViewModel.setGroupID(groupID)
        self.settleGroupViewModel.setExpenseID(expenseID)
        self.settleGroupViewModel.selectExpenseClassfication(expenseClassfication)
        self.settleGroupViewModel.setExpenseDate(expenseDate)
        self.settleGroupViewModel.setIsActiveSettlement(isActiveSettlement)
        self.settleGroupViewModel.loadSettlementCreatorID()
        self.settleGroupViewModel.loadExpenseDetailInformation(expenseID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSpendingDetailsView()
        configureDatePicker()
        configureSettlementGroupViewState()
        disableEditing()
        addSubviews()
        setLayoutConstraintsSpendingDetailsView()
        bindAll()
    }
}

extension SpendingDetailsViewController {
    private func configureSpendingDetailsView() {
        spendingDetailsView.translatesAutoresizingMaskIntoConstraints = false
        spendingDetailsView.spendingDetailAddButton.setTitle("수정", for: .normal)
        spendingDetailsView.contentTextField.text = settleGroupViewModel.expenseDetails
        spendingDetailsView.datePicker.isEnabled = false
        view.backgroundColor = .secondarySystemBackground
        self.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.title = "지출 상세 내역"
    }
    
    private func configureDatePicker() {
        guard let date = settleGroupViewModel.expenseDate else { return }
        spendingDetailsView.datePicker.date = date
    }
    
    private func configureSettlementGroupViewState() {
        guard let isActive = settleGroupViewModel.isActiveSettlement,
              isActive else { return }
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: updateButton)
    }
    
    private func disableEditing() {
        spendingDetailsView.contentTextField.isEnabled = false
        spendingDetailsView.paymentTextField.isEnabled = false
        settleGroupViewModel.setCanSelectItems(false)
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
        bindBackButton()
        bindUpdateButton()
        bindCancelButton()
        bindSaveButton()
        bindDeleteButton()
        bindSpendingDetailsclassficationView()
        bindLoadedGroupExpenseDetailInfoSubject()
        bindIsUpdatedSpendingDetailInfoSubject()
        bindIsDeleteSpendingDetailInfoSubject()
        bindIsEqualSettlementCreatorSubject()
    }
    
    private func bindBackButton() {
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                switch self?.updateButton.tag {
                case 0:
                    self?.navigationController?.popViewController(animated: true)
                case 1:
                    self?.cancelAlert()
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUpdateButton() {
        updateButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.saveButton.isEnabled = true
                self.saveButton.isHidden = false
                
                self.deleteButton.isEnabled = true
                self.deleteButton.isHidden = false
                
                self.updateButton.tag = 1
                self.updateButton.isHidden = true
                self.updateButton.isEnabled = false
                
                self.spendingDetailsView.contentTextField.isEnabled = true
                self.spendingDetailsView.paymentTextField.isEnabled = true
                self.spendingDetailsView.datePicker.isEnabled = true
                self.settleGroupViewModel.setCanSelectItems(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindCancelButton() {
        spendingDetailsView.cancelButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.saveButton.isEnabled = false
                self.saveButton.isHidden = true
                
                self.deleteButton.isEnabled = false
                self.deleteButton.isHidden = true
                
                self.spendingDetailsView.datePicker.isEnabled = false
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSaveButton() {
        saveButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.saveAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDeleteButton() {
        deleteButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.deleteAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpendingDetailsclassficationView() {
        spendingDetailsView.trafficclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard self?.updateButton.tag == 1,
                      let self = self else { return }
                let otherViews = [self.spendingDetailsView.accommodationclassficationView,
                                  self.spendingDetailsView.tourismclassficationView,
                                  self.spendingDetailsView.foodclassficationView,
                                  self.spendingDetailsView.etcclassficationView]
                self.selectClassification(self.spendingDetailsView.trafficclassficationView,
                                          otherViews,
                                          self.spendingDetailsView.trafficclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailsView.accommodationclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard self?.updateButton.tag == 1,
                      let self = self else { return }
                let otherViews = [self.spendingDetailsView.trafficclassficationView,
                                  self.spendingDetailsView.tourismclassficationView,
                                  self.spendingDetailsView.foodclassficationView,
                                  self.spendingDetailsView.etcclassficationView]
                self.selectClassification(self.spendingDetailsView.accommodationclassficationView,
                                           otherViews,
                                           self.spendingDetailsView.accommodationclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailsView.tourismclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard self?.updateButton.tag == 1,
                      let self = self else { return }
                let otherViews = [self.spendingDetailsView.trafficclassficationView,
                                  self.spendingDetailsView.accommodationclassficationView,
                                  self.spendingDetailsView.foodclassficationView,
                                  self.spendingDetailsView.etcclassficationView]
                self.selectClassification(self.spendingDetailsView.tourismclassficationView,
                                          otherViews,
                                          self.spendingDetailsView.tourismclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailsView.foodclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard self?.updateButton.tag == 1,
                      let self = self else { return }
                let otherViews = [self.spendingDetailsView.trafficclassficationView,
                                  self.spendingDetailsView.accommodationclassficationView,
                                  self.spendingDetailsView.tourismclassficationView,
                                  self.spendingDetailsView.etcclassficationView]
                self.selectClassification(self.spendingDetailsView.foodclassficationView,
                                          otherViews,
                                          self.spendingDetailsView.foodclassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailsView.etcclassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard self?.updateButton.tag == 1,
                      let self = self else { return }
                let otherViews = [self.spendingDetailsView.trafficclassficationView,
                                  self.spendingDetailsView.accommodationclassficationView,
                                  self.spendingDetailsView.tourismclassficationView,
                                  self.spendingDetailsView.foodclassficationView]
                self.selectClassification(self.spendingDetailsView.etcclassficationView,
                                          otherViews,
                                          self.spendingDetailsView.etcclassficationView.tag)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindLoadedGroupExpenseDetailInfoSubject() {
        settleGroupViewModel.loadedGroupExpenseDetailInfoSubject
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] loadedGroupExpenseDetailInfoResult in
                switch loadedGroupExpenseDetailInfoResult {
                case .success():
                    guard let expenseDetailInfo = self?.settleGroupViewModel.expenseDetailInformation else { return }
                    self?.spendingDetailsView.configureSpendingDetailView(expenseDetailInfo)
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedSpendingDetailInfoSubject() {
        settleGroupViewModel.isUpdatedSpendingDetailInfoSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdated in
                guard isUpdated else {
                    self?.failedAlert()
                    return }
                self?.view.makeToast("수정이 완료되었어요!", duration: 0.5) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDeleteSpendingDetailInfoSubject() {
        settleGroupViewModel.isDeletedSpendingDetailInfoSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDeleted in
                guard isDeleted else {
                    self?.failedAlert()
                    return
                }
                self?.view.makeToast("삭제가 완료되었어요!", duration: 0.5) { _ in
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsEqualSettlementCreatorSubject() {
        settleGroupViewModel.isEqualSettlementCreatorSubject
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isEqualSettlementCreatorResult in
                switch isEqualSettlementCreatorResult {
                case .success(let isEqualSettlementCreator):
                    self?.updateButton.isEnabled = isEqualSettlementCreator
                    self?.updateButton.isHidden = !isEqualSettlementCreator
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: select classification
    private func selectClassification(_ view: SpendingDetailsclassficationView, _ otherViews: [SpendingDetailsclassficationView], _ tag: Int) {
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
    
    //MARK: Alert
    private func cancelAlert() {
        let alertController = UIAlertController(title: "바로보내", message: "지출 내역 정보 수정을 취소할까요? \n (수정된 내용은 삭제됩니다.)", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            self?.updateButton.tag = 0
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func saveAlert() {
        let alertController = UIAlertController(title: "바로보내", message: "수정한 지출 내역 정보를 저장할까요?", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            guard let expenseClassfication = self?.settleGroupViewModel.expenseClassfication,
                  let expenseDetails = self?.spendingDetailsView.contentTextField.text,
                  let expenseAmount = self?.spendingDetailsView.paymentTextField.text,
                  let expenseDate = self?.spendingDetailsView.datePicker.date
            else { return }
            self?.settleGroupViewModel.updateSpendingDetailInformation(expensClassfication: expenseClassfication, expenseDetails: expenseDetails, expenseAmount: expenseAmount, expenseDate: expenseDate)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func deleteAlert() {
        let alertController = UIAlertController(title: "바로보내", message: "해당 지출 내역을 삭제할까요? \n ⚠️삭제된 내용은 복구되지 않습니다.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "삭제하기", style: .default) {[weak self] _ in
            guard let expenseID = self?.settleGroupViewModel.expenseID,
                  let groupID = self?.settleGroupViewModel.groupID else { return }
            self?.settleGroupViewModel.deleteSpendingDetailInformation(expenseID: expenseID, groupID: groupID)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    private func failedAlert() {
        let alertController = UIAlertController(title: "바로보내", message: "지출 내역 정보 수정을 실패했어요. 잠시후 다시 시도 해 주세요. 🥲\n(같은 오류가 발생할 경우, 고객센터에 문의해 주세요.)", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
}
