//
//  BankInfoRequiredViewController.swift
//  SendNow
//
//  Created by 한소희 on 2/24/25.
//

import Foundation
import UIKit
import RxSwift

final class BankInfoRequiredViewController: BaseUIViewController {
    private let bankInfoRequiredView = BankInfoRequiredView()
    private let disposeBag = DisposeBag()
    private let bankInfoRequiredViewModel: BankInfoRequiredViewModel
    
    init(bankInfoRequriedViewModel: BankInfoRequiredViewModel = BankInfoRequiredViewModel(
        userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue))) {
        self.bankInfoRequiredViewModel = bankInfoRequriedViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBankInfoRequiredView()
        addSubivews()
        setLayoutConstraintsBankInfoRequiredView()
        bind()
    }
}

extension BankInfoRequiredViewController {
    
    // MARK: Configure
    private func configureBankInfoRequiredView() {
        self.isModalInPresentation = true
        self.modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .clear
        bankInfoRequiredView.translatesAutoresizingMaskIntoConstraints = false
        bankInfoRequiredView.layer.cornerRadius = 10
    }
    
    private func configureMemberInfoUpdateViewBankNameTextField(bankName: String, isEnabled: Bool) {
        bankInfoRequiredView.bankNameUploadTextField.text = bankName
        bankInfoRequiredView.bankNameUploadTextField.isEnabled = isEnabled
    }
    
    private func addSubivews() {
        view.addSubview(bankInfoRequiredView)
    }
    
    private func setLayoutConstraintsBankInfoRequiredView() {
        NSLayoutConstraint.activate([
            bankInfoRequiredView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140.0),
            bankInfoRequiredView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60.0),
            bankInfoRequiredView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60.0),
            bankInfoRequiredView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140.0),
        ])
    }
    
    // MARK: Bind
    
    private func bind() {
        bindBankNameUploadButton()
        bindUploadButton()
        bindBankInfoUpdatedSubject()
    }
    
    private func bindBankNameUploadButton() {
        bankInfoRequiredView.bankNameUploadButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                let bankNameMenuItems: [UIAction] = {
                    return [
                        UIAction(title: BankName.kbstar.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.kbstar.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.nhbank.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.nhbank.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.shinhan.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.shinhan.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.kebhana.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.kebhana.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.wooribank.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.wooribank.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.kakaobank.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: BankName.kakaobank.rawValue, isEnabled: false)}),
                        UIAction(title: BankName.directInput.rawValue, handler: { _ in self?.configureMemberInfoUpdateViewBankNameTextField(bankName: "", isEnabled: true)})
                    ]
                }()
                self?.bankInfoRequiredView.bankNameUploadButton.menu = UIMenu(title: "은행기관 선택", options: .displayInline, children: bankNameMenuItems)
            })
            .disposed(by: disposeBag)
    }

    private func bindUploadButton() {
        bankInfoRequiredView.uploadButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.bankInfoRequiredViewModel.updateMemberBankInfo(bankName: self?.bankInfoRequiredView.bankNameUploadTextField.text,
                                                                     accountNumber: self?.bankInfoRequiredView.accountNumberUploadTextField.text,
                                                                     kakaoPayURL: self?.bankInfoRequiredView.kakaoPayUrlUploadTextField.text)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindBankInfoUpdatedSubject() {
        bankInfoRequiredViewModel.bankInfoUpdatedSubject
            .asDriver(onErrorJustReturn: .networkError)
            .drive(onNext: {[weak self] bankInfoResponse in
                switch bankInfoResponse {
                case .networkError:
                    let message = "서버에 일시적인 문제가 생겼어요. 잠시 후에 시도해 주세요. 🥲"
                    self?.bankInfoUpdatedAlert(message: message, isUpdated: false)
                case .noValue:
                    let message = "계좌번호 혹은 카카오페이 송금 링크를 반드시 입력해야 바로보내 서비스를 이용할 수 있어요."
                    self?.bankInfoUpdatedAlert(message: message, isUpdated: false)
                case .success:
                    let message = "회원님의 정보가 업데이트되었어요. 바로보내 서비스를 이용해 보세요! 🙌🏻"
                    self?.bankInfoUpdatedAlert(message: message, isUpdated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Alert
    private func bankInfoUpdatedAlert(message: String, isUpdated: Bool) {
        let alertController = UIAlertController(title: "바로 보내", message: message, preferredStyle: .alert)
        
        let successAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        let failAction = UIAlertAction(title: "확인", style: .default) { _ in }
        
        alertController.addAction(isUpdated ? successAction : failAction)
        self.present(alertController, animated: true)
    }
}
