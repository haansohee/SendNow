//
//  IndividualRemmitDetailViewController.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import Foundation
import UIKit
import RxSwift

final class IndividualRemmitDetailViewController: UIViewController {
    private let individualRemmitDetailView = IndividualRemmitDetailView()
    private let settleGroupViewModel = SettleGroupViewModel()
    private let disposeBag = DisposeBag()
    
    init(groupID: Int) {
        super.init(nibName: nil, bundle: nil)
        settleGroupViewModel.setGroupID(groupID)
        settleGroupViewModel.loadGroupSettlementInforamtion()
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
        settleGroupViewModel.loadGroupSettlementInforamtion()
    }
}

extension IndividualRemmitDetailViewController {
    private func configureIndividualRemmitDetailView() {
        individualRemmitDetailView.translatesAutoresizingMaskIntoConstraints = false
        individualRemmitDetailView.individualRemmitCollectionView.delegate = self
        individualRemmitDetailView.individualRemmitCollectionView.dataSource = self
        individualRemmitDetailView.amountBalanceCollectionView.delegate = self
        individualRemmitDetailView.amountBalanceCollectionView.dataSource = self
        view.backgroundColor = UIColor(named: "BackColor")
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
        bindIsLoadedGroupSettlementInfo()
    }
    
    private func bindIsLoadedGroupSettlementInfo() {
        settleGroupViewModel.isLoadedGroupSettlementInfo
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isLoadedGroupSettlementInfo in
                guard isLoadedGroupSettlementInfo else { return }
                self?.individualRemmitDetailView.individualRemmitCollectionView.reloadData()
                self?.individualRemmitDetailView.amountBalanceCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension IndividualRemmitDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case individualRemmitDetailView.individualRemmitCollectionView:
            guard let detailsInfo = settleGroupViewModel.groupSettlementInformations?.settlementDetails else { return 0 }
            return detailsInfo.count
        case individualRemmitDetailView.amountBalanceCollectionView:
            guard let balanceInfo = settleGroupViewModel.groupSettlementInformations?.settlementBalance else { return 0 }
            return balanceInfo.count

        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case individualRemmitDetailView.individualRemmitCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndividualRemmitDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? IndividualRemmitDetailCollectionViewCell else { return UICollectionViewCell() }
            guard let settlementInformations = settleGroupViewModel.groupSettlementInformations else { return cell }
            cell.configureIndividualRemmitDetailCollectionViewCell(information: settlementInformations.settlementDetails[indexPath.row])
            guard let kakaoPayUrl = settlementInformations.settlementDetails[indexPath.row].kakaoPayURL else {
                cell.receiverKakaoPayButton.isHidden = true
                return cell
            }
            cell.receiverKakaoPayButton.isHidden = false
            cell.receiverKakaoPayButton.isEnabled = settleGroupViewModel.compareUserID(fromUserID: settlementInformations.settlementDetails[indexPath.row].fromUserID)
            cell.rx.didTapKakaoPayUrlButton
                .asDriver()
                .drive(onNext: {[weak self] _ in
                    guard let amount = self?.toHexValue(settlementInformations.settlementDetails[indexPath.row].amount),
                          let url = URL(string: "\(String(describing: kakaoPayUrl))\(String(describing: amount))") else { return }
                    UIApplication.shared.open(url, options: [:])
                })
                .disposed(by: cell.disposeBag)
            cell.rx.didTapCopyButton
                .asDriver()
                .drive(onNext: { _ in
                    guard let bankName = settlementInformations.settlementDetails[indexPath.row].bankName,
                          let accountNumber = settlementInformations.settlementDetails[indexPath.row].accountNumber else { return }
                    UIPasteboard.general.string = "\(bankName) \(accountNumber)"
                })
                .disposed(by: cell.disposeBag)
                
            return cell
        case individualRemmitDetailView.amountBalanceCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AmountBalanceCollectionViewCell.reuseIdentifier, for: indexPath) as? AmountBalanceCollectionViewCell else { return UICollectionViewCell() }
            guard let balanceInformation = settleGroupViewModel.groupSettlementInformations?.settlementBalance else { return cell }
            individualRemmitDetailView.setAmountBalanceCollectionViewHeight(Double(balanceInformation.count))
            cell.configureCell(balanceInformation[indexPath.row])
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
            let width = (UIScreen.main.bounds.width) - 36.0
            let height = 150.0
            return CGSize(width: width, height: height)
        case individualRemmitDetailView.amountBalanceCollectionView:
            let width = (UIScreen.main.bounds.width) - 36.0
            let height = 30.0
            return CGSize(width: width, height: height)
        default:
            return .zero
        }
    }
}
