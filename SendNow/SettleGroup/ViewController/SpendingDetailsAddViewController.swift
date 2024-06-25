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
    private let settleGroupViewModel = SettleGroupViewModel()
    private let disposeBag = DisposeBag()
    
    init(groupID: Int) {
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
    
    override var childForStatusBarStyle: UIViewController? {
        let viewController = HomeViewController()
        return viewController
    }
}

extension SpendingDetailsAddViewController {
    private func configureSettleGroupView() {
        spendingDetailAddView.translatesAutoresizingMaskIntoConstraints = false
        spendingDetailAddView.remainderAmountPayUserCollectionView.dataSource = self
        spendingDetailAddView.remainderAmountPayUserCollectionView.delegate = self
        self.modalPresentationCapturesStatusBarAppearance = true
        self.sheetPresentationController?.prefersGrabberVisible = true
        view.backgroundColor = UIColor(named: "BackColor")
        navigationItem.title = "지출 내역 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spendingDetailAddView.spendingDetailAddButton)
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
    
    private func selectClassfication(_ view: SpendingDetailsClassficationView, _ otherViews: [SpendingDetailsClassficationView], _ tag: Int) {
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
            settleGroupViewModel.deselectExpenseClassfication()
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
        bindSpendingDetailsClassficationView()
        bindpSendingDetailAddButton()
        bindIsUploadedExpenseInfo()
        bindIsLoadedGroupMemberInfo()
    }
    
    private func bindSpendingDetailsClassficationView() {
        spendingDetailAddView.trafficClassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassficationView = self?.spendingDetailAddView.trafficClassficationView,
                      let accommodationClassficationView = self?.spendingDetailAddView.accommodationClassficationView,
                      let tourismClassficationView = self?.spendingDetailAddView.tourismClassficationView,
                      let foodClassficationView = self?.spendingDetailAddView.foodClassficationView,
                      let etcClassficationView = self?.spendingDetailAddView.etcClassficationView else { return }
                let otherViews = [accommodationClassficationView,
                                  tourismClassficationView,
                                  foodClassficationView,
                                  etcClassficationView]
                self?.selectClassfication(trafficClassficationView, otherViews, trafficClassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.accommodationClassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassficationView = self?.spendingDetailAddView.trafficClassficationView,
                      let accommodationClassficationView = self?.spendingDetailAddView.accommodationClassficationView,
                      let tourismClassficationView = self?.spendingDetailAddView.tourismClassficationView,
                      let foodClassficationView = self?.spendingDetailAddView.foodClassficationView,
                      let etcClassficationView = self?.spendingDetailAddView.etcClassficationView else { return }
                let otherViews = [trafficClassficationView,
                                  tourismClassficationView,
                                  foodClassficationView,
                                  etcClassficationView]
                self?.selectClassfication(accommodationClassficationView, otherViews, accommodationClassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.tourismClassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassficationView = self?.spendingDetailAddView.trafficClassficationView,
                      let accommodationClassficationView = self?.spendingDetailAddView.accommodationClassficationView,
                      let tourismClassficationView = self?.spendingDetailAddView.tourismClassficationView,
                      let foodClassficationView = self?.spendingDetailAddView.foodClassficationView,
                      let etcClassficationView = self?.spendingDetailAddView.etcClassficationView else { return }
                let otherViews = [trafficClassficationView,
                                  accommodationClassficationView,
                                  foodClassficationView,
                                  etcClassficationView]
                self?.selectClassfication(tourismClassficationView, otherViews, tourismClassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.foodClassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassficationView = self?.spendingDetailAddView.trafficClassficationView,
                      let accommodationClassficationView = self?.spendingDetailAddView.accommodationClassficationView,
                      let tourismClassficationView = self?.spendingDetailAddView.tourismClassficationView,
                      let foodClassficationView = self?.spendingDetailAddView.foodClassficationView,
                      let etcClassficationView = self?.spendingDetailAddView.etcClassficationView else { return }
                let otherViews = [trafficClassficationView,
                                  accommodationClassficationView,
                                  tourismClassficationView,
                                  etcClassficationView]
                self?.selectClassfication(foodClassficationView, otherViews, foodClassficationView.tag)
            })
            .disposed(by: disposeBag)
        
        spendingDetailAddView.etcClassficationView.rx
            .tapGesture()
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: {[weak self] _ in
                guard let trafficClassficationView = self?.spendingDetailAddView.trafficClassficationView,
                      let accommodationClassficationView = self?.spendingDetailAddView.accommodationClassficationView,
                      let tourismClassficationView = self?.spendingDetailAddView.tourismClassficationView,
                      let foodClassficationView = self?.spendingDetailAddView.foodClassficationView,
                      let etcClassficationView = self?.spendingDetailAddView.etcClassficationView else { return }
                let otherViews = [trafficClassficationView,
                                  accommodationClassficationView,
                                  tourismClassficationView,
                                  foodClassficationView]
                self?.selectClassfication(etcClassficationView, otherViews, etcClassficationView.tag)
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
                guard let remainderUser = self?.settleGroupViewModel.remainderUserID else {
                    self?.checkAlert(message: "나머지 금액을 지불할 친구를 선택하세요!")
                    return
                }
                self?.settleGroupViewModel.uploadExpenseInformation(expenseClassfication: expenseClassfication, expenseDetail: detailContent, expenseAmount: expense, expenseDate: date, remainderUserID: remainderUser)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUploadedExpenseInfo() {
        settleGroupViewModel.isUploadedExpenseInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext:{[weak self] isUploadedExpenseInfo in
                guard isUploadedExpenseInfo else { return }
                NotificationCenter.default.post(name: NSNotification.Name("uploadExpense"), object: isUploadedExpenseInfo)
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
        let width = (UIScreen.main.bounds.width) - 50.0
        let height = 40.0
        return CGSize(width: width, height: height)
    }
}
