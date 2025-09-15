//
//  MemberInfoUpdateViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/29/24.
//

import Foundation
import UIKit
import RxSwift

final class MemberInfoUpdateViewController: BaseUIViewController {
    private let memberInfoUpdateView = MemberInfoUpdateView()
    private let homeViewModel: HomeViewModel
    private let memberInfoUpdateViewModel: MemberInfoUpdateViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel = HomeViewModel(userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue)),
         updateViewModel: MemberInfoUpdateViewModel = MemberInfoUpdateViewModel(
            userID: UserDefaults.standard.integer(forKey: MemberInfoField.userID.rawValue),
            signinType: SigninType(
                rawValue: UserDefaults.standard.string(forKey: MemberInfoField.signinType.rawValue) ?? "") ?? .default)) {
        self.homeViewModel = viewModel
        self.memberInfoUpdateViewModel = updateViewModel
        super.init(nibName: nil, bundle: nil)
        homeViewModel.loadMemberInformation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemberInfoView()
        addSubviews()
        setLayoutConstraintsMemberInfoUpdateView()
        bindAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        homeViewModel.loadMemberInformation()
        configureMemberInfoUpdateViewNicknamePlaceholder()
        configureMemberInfoUpdateViewAccountInfo()
    }
}

extension MemberInfoUpdateViewController {
    private func configureMemberInfoView() {
        memberInfoUpdateView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        navigationItem.title = "회원정보"
        navigationController?.navigationBar.tintColor = UIColor(named: "TitleColor")
    }
    
    private func addSubviews() {
        view.addSubview(memberInfoUpdateView)
    }
    
    private func setLayoutConstraintsMemberInfoUpdateView() {
        NSLayoutConstraint.activate([
            memberInfoUpdateView.topAnchor.constraint(equalTo: view.topAnchor),
            memberInfoUpdateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memberInfoUpdateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memberInfoUpdateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Configure
    private func configureMemberInfoUpdateViewNicknamePlaceholder() {
        guard let nickname = homeViewModel.loginMemberInformation?.nickname else { return }
        memberInfoUpdateView.nicknameTextField.placeholder = nickname
    }
    
    private func configureMemberInfoUpdateViewBankNameTextField(bankName: String, isEnabled: Bool) {
        memberInfoUpdateView.bankNameUploadTextField.text = bankName
        memberInfoUpdateView.bankNameUploadTextField.isEnabled = isEnabled
    }
    
    private func configureMemberInfoUpdateViewAccountInfo() {
        let bankName = homeViewModel.loginMemberInformation?.bankName ?? "은행 기관을 선택하세요."
        let accountNumber = homeViewModel.loginMemberInformation?.accountNumber ?? "계좌번호"
        let kakaoPayUrl = homeViewModel.loginMemberInformation?.kakaoPayUrl ?? "송금 코드 링크를 입력해 주세요."
        memberInfoUpdateView.configureMemberAccountInfo(bankName: bankName,
                                                        accountNumber: accountNumber,
                                                        kakaoPayUrl: kakaoPayUrl)
    }
    
    //MARK: Bind
    private func bindAll() {
        bindNicknameDuplicateButton()
        bindNicknameUpdateButton()
        bindBankNameUploadButton()
        bindKakaoPayUrlUploadButton()
        bindAccountNumberUploadButton()
        bindCancelAccountButton()
        bindNicknameTextField()
        bindIsDuplicatedNickname()
        bindIsUpdatedNickname()
        bindIsUpdatedAccountNumber()
        bindIsUpdatedKakaoPayUrl()
        bindIsCanceldAccount()
    }
    
    private func bindNicknameDuplicateButton() {
        memberInfoUpdateView.nicknameDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = self?.memberInfoUpdateView.nicknameTextField.text,
                      !(nickname.isEmpty) else { return }
                self?.memberInfoUpdateViewModel.isDuplicatedNickname(nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameUpdateButton() {
        memberInfoUpdateView.nicknameUpdateButton.rx.tap
            .asDriver()
            .drive(onNext:{[weak self] _ in
                guard let updateNickname = self?.memberInfoUpdateView.nicknameTextField.text,
                      !updateNickname.isEmpty else { return }
                self?.memberInfoUpdateViewModel.updateNickname(updateNickname: updateNickname)
            }).disposed(by: disposeBag)
    }
    
    private func bindBankNameUploadButton() {
        memberInfoUpdateView.bankNameUploadButton.rx.tap
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
                self?.memberInfoUpdateView.bankNameUploadButton.menu = UIMenu(title: "은행기관 선택", options: .displayInline, children: bankNameMenuItems)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindAccountNumberUploadButton() {
        memberInfoUpdateView.accountNumberUploadButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let bankName = self?.memberInfoUpdateView.bankNameUploadTextField.text,
                      !bankName.isEmpty else {
                    self?.confirmAlert(title: "바로보내", message: "은행기관을 선택해 주세요.")
                    return
                }
                guard let accountNumber = self?.memberInfoUpdateView.accountNumberUploadTextField.text,
                      !accountNumber.isEmpty else {
                    self?.confirmAlert(title: "바로보내", message: "계좌번호를 입력해 주세요.")
                    return
                }
                self?.memberInfoUpdateViewModel.updateAccountNumber(bankName: bankName, accountNumber: accountNumber)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindKakaoPayUrlUploadButton() {
        memberInfoUpdateView.kakaoPayUrlUploadButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let kakaoPayUrl = self?.memberInfoUpdateView.kakaoPayUrlUploadTextField.text,
                      !kakaoPayUrl.isEmpty else {
                    self?.confirmAlert(title: "바로보내", message: "코드 송금 링크를 입력해 주세요!")
                    return }
                self?.memberInfoUpdateViewModel.updateKakaoPayUrl(kakaoPayUrl: kakaoPayUrl)
            }).disposed(by: disposeBag)
    }
    
    private func bindCancelAccountButton() {
        memberInfoUpdateView.cancelAccountButton.rx.tap
            .subscribe(onNext: {[weak self] in
                self?.cancelAccountAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameTextField() {
        memberInfoUpdateView.nicknameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputNickname in
                let isValid = inputNickname.isValidNickname
                self?.memberInfoUpdateView.nicknameLabel.text = isValid ? "" : "닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요."
                self?.memberInfoUpdateView.configureNicknameDuplicateButton(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedNickname() {
        memberInfoUpdateViewModel.isDuplicatedNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedNickname in
                self?.memberInfoUpdateView.nicknameLabel.text = isDuplicatedNickname ? "사용 가능한 닉네임이에요." : "중복된 닉네임이에요."
                self?.memberInfoUpdateView.configureNicknameUpdateButton(isDuplicatedNickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedNickname() {
        memberInfoUpdateViewModel.isUpdatedNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedNickname in
                guard isUpdatedNickname else {
                    self?.confirmAlert(title: "바로보내", message: "잠시후에 시도해 주세요. 🥲")
                    return }
                guard let updateNickname = self?.memberInfoUpdateView.nicknameTextField.text,
                      !updateNickname.isEmpty else { return }
                self?.confirmAlert(title: "바로보내", message: "변경이 완료되었어요.")
                self?.memberInfoUpdateView.nicknameTextField.text = ""
                self?.memberInfoUpdateView.nicknameLabel.text = "닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요."
                self?.memberInfoUpdateView.nicknameTextField.placeholder = updateNickname
                self?.memberInfoUpdateView.configureNicknameUpdateButton(false)
                self?.memberInfoUpdateView.configureNicknameDuplicateButton(false)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedAccountNumber() {
        memberInfoUpdateViewModel.isUpdatedAccountNumber
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedAccountNumber in
                guard isUpdatedAccountNumber else {
                    self?.confirmAlert(title: "바로보내", message: "잠시후에 시도해 주세요. 🥲")
                    return
                }
                self?.confirmAlert(title: "바로보내", message: "계좌번호가 등록되었어요.")
                guard let updateBankName = self?.memberInfoUpdateView.bankNameUploadTextField.text,
                      let updateAccountNumber = self?.memberInfoUpdateView.accountNumberUploadTextField.text,
                      !updateBankName.isEmpty,
                      !updateAccountNumber.isEmpty else { return }
                self?.memberInfoUpdateView.bankNameUploadTextField.placeholder = updateBankName
                self?.memberInfoUpdateView.accountNumberUploadTextField.placeholder = updateAccountNumber
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsUpdatedKakaoPayUrl() {
        memberInfoUpdateViewModel.isUpdatedKakaoPayUrl
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isUpdatedKakaoPayUrl in
                guard isUpdatedKakaoPayUrl else {
                    self?.confirmAlert(title: "바로보내", message: "유효하지 않은 링크예요. 🥲")
                    return
                }
                self?.confirmAlert(title: "바로보내", message: "카카오페이 송금링크가 등록되었어요.")
                guard let updateKakaoPayUrl = self?.memberInfoUpdateView.kakaoPayUrlUploadTextField.text,
                      !updateKakaoPayUrl.isEmpty else { return }
                self?.memberInfoUpdateView.kakaoPayUrlUploadTextField.placeholder = updateKakaoPayUrl
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCanceldAccount() {
        memberInfoUpdateViewModel.isCanceledAccount
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCanceledAccount in
                guard isCanceledAccount else {
                    self?.confirmAlert(title: "바로보내", message: "잠시후에 시도해 주세요.")
                    return }
                let rootViewController = UINavigationController(rootViewController: SigninViewController())
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Alert
    private func cancelAccountAlert() {
        let message = "⚠️ 탈퇴 후 해당 계정과 관련된 모든 데이터는 복구할 수 없으며, 계정을 다시 활성화할 수 없습니다. \n 탈퇴하시겠습니까? 🥲"
        let alertController = UIAlertController(title: "바로보내", message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "탈퇴하기", style: .destructive) {[weak self] _ in
            self?.memberInfoUpdateViewModel.cancelAccount()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(doneAction)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {[weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
