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
        configure()
        addSubivews()
        setLayoutConstraints()
        bind()
    }
}

extension BankInfoRequiredViewController {
    
    // MARK: Configure
    private func configure() {
        self.isModalInPresentation = true
        self.modalPresentationCapturesStatusBarAppearance = true
        view.backgroundColor = .clear
        bankInfoRequiredView.translatesAutoresizingMaskIntoConstraints = false
        bankInfoRequiredView.layer.cornerRadius = 10
    }
    
    private func addSubivews() {
        view.addSubview(bankInfoRequiredView)
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            bankInfoRequiredView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140.0),
            bankInfoRequiredView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 60.0),
            bankInfoRequiredView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60.0),
            bankInfoRequiredView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140.0),
        ])
    }
    
    // MARK: Bind
    private func bind() {
        bindUploadButton()
        bindDismissedButton()
        bindDismissedForeverButton()
        bindIsUpdatedKakaoPayUrlSubject()
        bindIsUpdatedKakaoPayUrlDimissedSubject()
    }
    
    private func bindUploadButton() {
        bankInfoRequiredView.uploadButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let kakaoPayURL = self?.bankInfoRequiredView.kakaoPayUrlUploadTextField.text,
                      !kakaoPayURL.isEmpty else { return }
                self?.bankInfoRequiredViewModel.updateKakaoPayURL(kakaoPayURL)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDismissedButton() {
        bankInfoRequiredView.dismissButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindDismissedForeverButton() {
        bankInfoRequiredView.dismissForeverButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.bankInfoRequiredViewModel.updateKakaoPayUrlDismissed()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedKakaoPayUrlSubject() {
        bankInfoRequiredViewModel.isUpdatedKakaoPayUrlSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedKakaoPayUrl in
                let message = isUpdatedKakaoPayUrl ? "카카오페이 링크 등록이 완료되었어요!" : "유효한 카카오페이 링크가 아니에요. 다시 시도 해 주세요."
                self?.bankInfoUpdatedAlert(message: message, isUpdated: isUpdatedKakaoPayUrl)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedKakaoPayUrlDimissedSubject() {
        bankInfoRequiredViewModel.isUpdatedKakaoPayUrlDismissedSubject
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedKakaoPayUrlSubject in
                guard isUpdatedKakaoPayUrlSubject else { return }
                self?.dismiss(animated: true)
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
