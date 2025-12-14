//
//  IndividualRemmitDetailViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation
import UIKit
import RxSwift

final class IndividualRemmitDetailViewController: BaseUIViewController {
    private let individualRemmitDetailView = IndividualRemmitDetailView()
    private let settleGroupView = SettleGroupView()
    private let individualRemmitDetailViewModel: IndividualRemmitDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: IndividualRemmitDetailViewModel = IndividualRemmitDetailViewModel(userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))
         , groupID: Int) {
        self.individualRemmitDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        individualRemmitDetailViewModel.setGroupID(groupID)
        individualRemmitDetailViewModel.loadGroupSettlementInforamtion()
        individualRemmitDetailViewModel.loadCompletionRemittanceInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureIndividualRemmitDetailView()
        addSubviews()
        setLayoutConstraintsIndividualRemmitDetailView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        individualRemmitDetailViewModel.loadGroupSettlementInforamtion()
        individualRemmitDetailViewModel.loadCompletionRemittanceInformation()
    }
}

extension IndividualRemmitDetailViewController {
    private func configureIndividualRemmitDetailView() {
        individualRemmitDetailView.translatesAutoresizingMaskIntoConstraints = false
        [
            individualRemmitDetailView.individualRemmitCollectionView,
            individualRemmitDetailView.amountBalanceCollectionView,
            individualRemmitDetailView.completedRemittanceCollectionView
        ].forEach {
            $0.delegate = self
            $0.dataSource = self
        }
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        view.addSubview(individualRemmitDetailView)
    }
    
    private func setLayoutConstraintsIndividualRemmitDetailView() {
        NSLayoutConstraint.activate([
            individualRemmitDetailView.topAnchor.constraint(equalTo: view.topAnchor),
            individualRemmitDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            individualRemmitDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            individualRemmitDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func toHexValue(_ value: Int) -> String {
        return String((value * 524288), radix: 16)
    }
    
    private func bindAll() {
        bindGroupManagementButton()
        bindIsLoadedGroupSettlementInfo()
        bindIsLoadedCompletionRemittanceInfo()
    }
    
    private func bindGroupManagementButton() {
        settleGroupView.groupManagementButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let groupID = self?.individualRemmitDetailViewModel.groupID else { return }
                self?.navigationController?.pushViewController(GroupManagementViewController(groupID: groupID), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedGroupSettlementInfo() {
        individualRemmitDetailViewModel.isLoadedGroupSettlementInfo
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedGroupSettlementInfoResult in
                switch isLoadedGroupSettlementInfoResult {
                case .success():
                    self?.individualRemmitDetailView.individualRemmitCollectionView.reloadData()
                    self?.individualRemmitDetailView.amountBalanceCollectionView.reloadData()
                    self?.individualRemmitDetailView.completedRemittanceCollectionView.reloadData()
                case .failure(_):
                    self?.serverErrorAlert()
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsLoadedCompletionRemittanceInfo() {
        individualRemmitDetailViewModel.isLoadedCompletionRemittanceInfo
            .asDriver(onErrorJustReturn: .failure(ErrorName.serverError))
            .drive(onNext: {[weak self] isLoadedCompletionRemittanceInfoResult in
                switch isLoadedCompletionRemittanceInfoResult {
                case .success():
                    self?.individualRemmitDetailView.completedRemittanceCollectionView.reloadData()
                case .failure(_):
                    self?.serverErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
}

extension IndividualRemmitDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case individualRemmitDetailView.individualRemmitCollectionView:
            guard let detailsInfo = individualRemmitDetailViewModel.groupSettlementInformations?.settlementDetails else { return 0 }
            return detailsInfo.count
            
        case individualRemmitDetailView.amountBalanceCollectionView:
            guard let balanceInfo = individualRemmitDetailViewModel.groupSettlementInformations?.settlementBalance else { return 0 }
            return balanceInfo.count
            
        case individualRemmitDetailView.completedRemittanceCollectionView:
            guard let remittanceInfo = individualRemmitDetailViewModel.remittanceInformations else {
                return 1 }
            return individualRemmitDetailViewModel.remittanceInformations?.count == 0 ? 1 : remittanceInfo.count

        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case individualRemmitDetailView.individualRemmitCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndividualRemmitDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? IndividualRemmitDetailCollectionViewCell else { return UICollectionViewCell() }
            guard let settlementInformations = individualRemmitDetailViewModel.groupSettlementInformations,
                  let settlementDetails = settlementInformations.settlementDetails[safe: indexPath.row] else { return cell }
            cell.configureIndividualRemmitDetailCollectionViewCell(information: settlementDetails)
            guard let kakaoPayUrl = settlementDetails.kakaoPayURL else {
                cell.receiverKakaoPayButton.isHidden = true
                return cell
            }
            cell.receiverKakaoPayButton.isHidden = false
            cell.receiverKakaoPayButton.isEnabled = individualRemmitDetailViewModel
                .compareUserID(fromUserID: settlementDetails.fromUserID)
            
            cell.rx.didTapKakaoPayUrlButton
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    guard let strToIntAmount = self?.individualRemmitDetailViewModel.parseFormattednumberSimple(settlementDetails.amount),
                          let amount = self?.toHexValue(strToIntAmount),
                          let url = URL(string: "\(String(describing: kakaoPayUrl))\(String(describing: amount))") else { return }
                    UIApplication.shared.open(url, options: [:])
                })
                .disposed(by: cell.disposeBag)
            return cell
            
        case individualRemmitDetailView.amountBalanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmountBalanceCollectionViewCell.reuseIdentifier, for: indexPath) as? AmountBalanceCollectionViewCell else { return UICollectionViewCell() }
            guard let balanceInformationList = individualRemmitDetailViewModel.groupSettlementInformations?.settlementBalance,
                  let balanceInformation = balanceInformationList[safe: indexPath.row] else { return cell }
            individualRemmitDetailView.setAmountBalanceCollectionViewHeight(Double(balanceInformationList.count))
            
            let transactionRole = individualRemmitDetailViewModel.comparedAmount(balanceInformation)
            cell.configureCell(transactionRole, balanceInformation)
            
            if balanceInformation.userID == individualRemmitDetailViewModel.userID {
                cell.nicknameLabel.text = "\(balanceInformation.nickname) (본인)"
            }
            return cell
            
        case individualRemmitDetailView.completedRemittanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedRemittanceCollectionViewCell.reuseIdentifier, for: indexPath) as? CompletedRemittanceCollectionViewCell else { return UICollectionViewCell () }
            guard let remittanceInformationList = individualRemmitDetailViewModel.remittanceInformations,
                  !remittanceInformationList.isEmpty,
                  let remittanceInformation = remittanceInformationList[safe: indexPath.row] else {
                cell.configureEmptyCell()
                return cell }
            cell.configureLabel(with: remittanceInformation)
            
            cell.rx.didTapCompletedButton
                .subscribe(onNext: { [weak self] in
                    let remittanceUpdatedStatus = !remittanceInformation.isCompletedRemittance
                    let remittanceStatusDomain = RemittanceStatusDomain(settlementID: remittanceInformation.settlementID,
                                                                        isCompletedRemittance: remittanceUpdatedStatus)
                    self?.individualRemmitDetailViewModel.setCompletedRemittance(remittanceStatusDomain) { isUpdated in
                        guard isUpdated else { return }
                        DispatchQueue.main.async {
                            cell.completedButton.setImage(UIImage(systemName: remittanceUpdatedStatus ? "checkmark.square.fill" : "square"), for: .normal)
                        }
                        if remittanceUpdatedStatus {
                            self?.individualRemmitDetailViewModel.sendRemittanceNotification(settlementID: remittanceStatusDomain.settlementID)
                        }
                    }
                })
                .disposed(by: cell.disposeBag)
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension IndividualRemmitDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case individualRemmitDetailView.individualRemmitCollectionView:
            let width = collectionView.bounds.width - 12.0
            let height = 150.0
            return CGSize(width: width, height: height)
            
        case individualRemmitDetailView.amountBalanceCollectionView:
            let width = collectionView.bounds.width - 12.0
            let height = 30.0
            return CGSize(width: width, height: height)
            
        case individualRemmitDetailView.completedRemittanceCollectionView:
            let size = collectionView.bounds.height - 12.0
            return CGSize(width: size, height: size)
            
        default:
            return .zero
        }
    }
}
