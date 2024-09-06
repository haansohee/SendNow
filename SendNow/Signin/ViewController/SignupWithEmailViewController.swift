//
//  SignupWithEmailViewController.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit
import RxSwift

final class SignupWithEmailViewController: UIViewController {
    private let signupWithEmailView = SignupWithEmailView()
    private let signupWithEmailViewModel: SignupWithEmailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SignupWithEmailViewModel = SignupWithEmailViewModel()) {
        self.signupWithEmailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSignupWithEmailView()
        addSubviews()
        setLayoutConstraintssignupWithEmailView()
        bindAll()
    }
}

extension SignupWithEmailViewController {
    private func configureSignupWithEmailView() {
        signupWithEmailView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.title = "가입하기"
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(signupWithEmailView)
    }
    
    private func setLayoutConstraintssignupWithEmailView() {
        NSLayoutConstraint.activate([
            signupWithEmailView.topAnchor.constraint(equalTo: view.topAnchor),
            signupWithEmailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signupWithEmailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signupWithEmailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindEmailAddressButton()
        bindSendAuthCodeAutton()
        bindSignupButton()
        bindEmailAuthButton()
        bindNicknameDuplicateButton()
        bindPasswordTextField()
        bindRePasswordTextField()
        bindNicknameTextField()
        bindIsDuplicatedEmail()
        bindIsDuplicatedNickname()
        bindIsCompletedSignup()
    }
    
    private func bindEmailAddressButton() {
        signupWithEmailView.naverAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.signupWithEmailView.setEmailAddressTextField(MailAddress.Naver.rawValue, false)
            })
            .disposed(by: disposeBag)
        
        signupWithEmailView.gmailAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.signupWithEmailView.setEmailAddressTextField(MailAddress.Gmail.rawValue, false)
            })
            .disposed(by: disposeBag)
        
        signupWithEmailView.icloudAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.signupWithEmailView.setEmailAddressTextField(MailAddress.iCloud.rawValue, false)
            })
            .disposed(by: disposeBag)
        
        signupWithEmailView.directInputAddressButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.signupWithEmailView.setEmailAddressTextField("", true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSendAuthCodeAutton() {
        signupWithEmailView.sendAuthCodeButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let email = self?.signupWithEmailView.emailTextField.text,
                      let emailAddress = self?.signupWithEmailView.emailAddressTextField.text else { return }
                guard !email.isEmpty && !emailAddress.isEmpty else {
                    self?.signupWithEmailView.emailAuthSuccessLabel.text = "이메일을 입력한 후 인증을 진행해 주세요."
                    return }
                self?.signupWithEmailViewModel.sendEmailAuthCode(email: "\(email)@\(emailAddress)")
                self?.signupWithEmailView.emailAuthSuccessLabel.text = "인증번호를 보내는 중이에요."
            })
            .disposed(by: disposeBag)
    }
    
    private func bindEmailAuthButton() {
        signupWithEmailView.emailAuthButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let inputAuthCode = self?.signupWithEmailView.emailAuthTextField.text,
                      !inputAuthCode.isEmpty,
                      let authCode = self?.signupWithEmailViewModel.emailAuthCodeInfo?.authCode else {
                    return }
                self?.signupWithEmailViewModel.setIsCheckedAuthCode(Int(inputAuthCode) == authCode)
                guard Int(inputAuthCode) == authCode else {
                    self?.signupWithEmailView.emailAuthSuccessLabel.text = "인증번호가 일치하지 않아요. 🥲"
                    return }
                self?.signupWithEmailView.emailAuthSuccessLabel.text = "이메일 인증이 완료되었어요!"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameDuplicateButton() {
        signupWithEmailView.nicknameDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = self?.signupWithEmailView.nicknameTextField.text,
                      !nickname.isEmpty else { return }
                self?.signupWithEmailViewModel.isDuplicatedNickname(nickname: nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignupButton() {
        signupWithEmailView.signupButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                      guard let nickname = self?.signupWithEmailView.nicknameTextField.text,
                      let email = self?.signupWithEmailView.emailTextField.text,
                      let emailAddress = self?.signupWithEmailView.emailAddressTextField.text,
                      let password = self?.signupWithEmailView.passwordTextField.text,
                      let fcmToken = UserDefaults.standard.string(forKey: MemberInfoField.fcmToken.rawValue),
                      !(nickname.isEmpty),
                      !(email.isEmpty),
                      !(emailAddress.isEmpty),
                      !(password.isEmpty) else {
                    self?.blankAlert(title: "바로보내 회원가입", message: "이메일, 아이디, 비밀번호, 닉네임을 모두 입력해 주세요.")
                    return }
                guard let isCheckedAuthCode = self?.signupWithEmailViewModel.isCheckedAuthCode,
                      let isCheckedValidNickname = self?.signupWithEmailViewModel.isCheckedValidNickname,
                      let isEnabledSignupButton = self?.signupWithEmailViewModel.isEnabledSignupButton,
                      isCheckedAuthCode,
                      isCheckedValidNickname,
                      isEnabledSignupButton else {
                    self?.blankAlert(title: "바로보내 회원가입", message: "이메일 인증 및 아이디 중복 검사, 정확한 비밀번호 작성 등 모두 진행해 주세요!")
                    return }
                let isSetNoti = UserDefaults.standard.bool(forKey: MemberInfoField.isSetNoti.rawValue)
                let signinWithEmailInfo = SigninWithEmailDomain(nickname: nickname,
                                                                email: "\(email)@\(emailAddress)",
                                                                password: password,
                                                                isSetNoti: isSetNoti,
                                                                fcmToken: fcmToken)
                self?.signupWithEmailViewModel.signupWithEmail(signinWithEmailInfo)
            })
            .disposed(by: disposeBag)
    }

    private func bindPasswordTextField() {
        signupWithEmailView.passwordTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputPassword in
                let isValid = inputPassword.isValidPassword
                self?.signupWithEmailView.passwordLabel.text = isValid ? "사용할 비밀번호를 입력해 주세요." : "사용할 비밀번호를 영어 대소문자, 숫자, 특수문자를 조합하여 \n 8~30자로 입력해 주세요."
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRePasswordTextField() {
        signupWithEmailView.rePasswordTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputRePassword in
                guard let password = self?.signupWithEmailView.passwordTextField.text,
                      !(password.isEmpty) else { return }
                self?.signupWithEmailViewModel.setIsEnabledSignupButton(inputRePassword.isValidPassword)
                if (inputRePassword == password) && inputRePassword.isValidPassword {
                    self?.signupWithEmailViewModel.setIsEnabledSignupButton(true)
                    self?.signupWithEmailView.passwordLabel.text = "사용할 비밀번호를 입력해 주세요."
                } else if inputRePassword != password {
                    self?.signupWithEmailView.passwordLabel.text = "비밀번호가 일치하지 않아요."
                    self?.signupWithEmailViewModel.setIsEnabledSignupButton(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameTextField() {
        signupWithEmailView.nicknameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputNickname in
                let isValid = inputNickname.isValidNickname
                self?.signupWithEmailViewModel.setIsEnabledSignupButton(isValid)
                self?.signupWithEmailView.nicknameLabel.text = isValid ? "" : "친구와 공유할 닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요."
                self?.signupWithEmailView.nicknameDuplicateButton.isEnabled = isValid
                self?.signupWithEmailView.nicknameDuplicateButton.backgroundColor = isValid ? UIColor(named: "TitleColor") : .lightGray
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedEmail() {
        signupWithEmailViewModel.isDuplicatedEmail
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedEmail in
                guard isDuplicatedEmail else {
                    self?.signupWithEmailView.emailAuthSuccessLabel.text = "메일이 도착했어요! 인증번호를 입력해 주세요."
                    return }
                self?.signupWithEmailView.emailAuthSuccessLabel.text = "이미 가입된 이메일이에요. 🥲"
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedNickname() {
        signupWithEmailViewModel.isDuplicatedNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedNickname in
                self?.signupWithEmailViewModel.setIsDuplicatedNickname(isDuplicatedNickname)
                self?.signupWithEmailView.nicknameLabel.text = isDuplicatedNickname ? "사용 가능한 닉네임이에요." : "중복된 닉네임이에요."
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCompletedSignup() {
        signupWithEmailViewModel.isCompletedSignup
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCompletedSignup in
                self?.signupSuccessAlert(title: "바로 보내",
                                         message: isCompletedSignup ? "회원가입이 완료되었어요. \n 로그인을 진행해 주세요!" : "서버가 불안정합니다. 잠시후에 시도해 주세요.")
            })
            .disposed(by: disposeBag)
    }
    //MARK: Alert
    private func blankAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel) { _ in }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)  
    }
    
    private func signupSuccessAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .default) {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
}
