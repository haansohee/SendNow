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
        [
            signupWithEmailView.passwordTextField,
            signupWithEmailView.rePasswordTextField,
            signupWithEmailView.idTextField,
            signupWithEmailView.nicknameTextField
        ].forEach { $0.delegate = self }
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
        bindIsDuplicatedEmail()
        bindEmailAuthButton()
        bindIdDuplicateButton()
        bindIsDuplicatedID()
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
    
    private func bindIdDuplicateButton() {
        signupWithEmailView.idDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let id = self?.signupWithEmailView.idTextField.text,
                      !id.isEmpty else { return }
                self?.signupWithEmailViewModel.checkDuplicateID(nickname: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedID() {
        signupWithEmailViewModel.isDuplicatedID
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedID in
                self?.signupWithEmailViewModel.setIsCheckedDuplicatedID(isDuplicatedID)
                guard isDuplicatedID else {
                    self?.signupWithEmailView.idLabel.text = "중복된 아이디예요."
                    return }
                self?.signupWithEmailView.idLabel.text = "사용 가능한 아이디예요."
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignupButton() {
        signupWithEmailView.signupButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let searchID = self?.signupWithEmailView.idTextField.text,
                      let nickname = self?.signupWithEmailView.nicknameTextField.text,
                      let email = self?.signupWithEmailView.emailTextField.text,
                      let emailAddress = self?.signupWithEmailView.emailAddressTextField.text,
                      let password = self?.signupWithEmailView.passwordTextField.text,
                      let fcmToken = UserDefaults.standard.string(forKey: MemberInfoField.fcmToken.rawValue),
                      !(searchID.isEmpty),
                      !(nickname.isEmpty),
                      !(email.isEmpty),
                      !(emailAddress.isEmpty),
                      !(password.isEmpty) else {
                    self?.blankAlert(title: "바로보내 회원가입", message: "이메일, 아이디, 비밀번호, 닉네임을 모두 입력해 주세요.")
                    return }
                guard let isCheckedAuthCode = self?.signupWithEmailViewModel.isCheckedAuthCode,
                      let isCheckedDuplicatedID = self?.signupWithEmailViewModel.isCheckedDuplicatedID,
                      let isCheckedValidNickname = self?.signupWithEmailViewModel.isCheckedValidNickname,
                      let isEnabledSignupButton = self?.signupWithEmailViewModel.isEnabledSignupButton,
                      isCheckedAuthCode,
                      isCheckedDuplicatedID,
                      isCheckedValidNickname,
                      isEnabledSignupButton else {
                    self?.blankAlert(title: "바로보내 회원가입", message: "이메일 인증 및 아이디 중복 검사, 정확한 비밀번호 작성 등 모두 진행해 주세요!")
                    return }
                let isSetNoti = UserDefaults.standard.bool(forKey: MemberInfoField.isSetNoti.rawValue)
                let signinWithEmailInfo = SigninWithEmailDomain(searchID: searchID,
                                                                nickname: nickname,
                                                                email: "\(email)@\(emailAddress)",
                                                                password: password,
                                                                isSetNoti: isSetNoti,
                                                                fcmToken: fcmToken)
                self?.signupWithEmailViewModel.signupWithEmail(signinWithEmailInfo)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsCompletedSignup() {
        signupWithEmailViewModel.isCompletedSignup
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isCompletedSignup in
                guard isCompletedSignup else {
                    self?.signupSuccessAlert(title: "바로 보내", message: "서버가 불안정합니다. 잠시후에 시도해 주세요.")
                    return }
                self?.signupSuccessAlert(title: "회원가입 완료", message: "로그인을 진행해 주세요!")
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

//MARK: UITextFieldDelegate
extension SignupWithEmailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case signupWithEmailView.passwordTextField:
            guard let password = textField.text,
                  let newRange = Range(range, in: password) else { return true }
            let inputPassword = string.trimmingCharacters(in: .whitespacesAndNewlines)
                        let newPassword = password.replacingCharacters(in: newRange, with: inputPassword).trimmingCharacters(in: .whitespacesAndNewlines)
            if newPassword.isValidPassword {
                signupWithEmailView.passwordLabel.text = "사용할 비밀번호를 입력해 주세요."
            } else {
                signupWithEmailView.passwordLabel.text = "사용할 비밀번호를 영어 대소문자, 숫자, 특수문자를 조합하여 \n 8~30자로 입력해 주세요."
            }
            return true
            
        case signupWithEmailView.rePasswordTextField:
            guard let rePassword = textField.text,
                  let newRange = Range(range, in: rePassword),
                  let password = signupWithEmailView.passwordTextField.text else { return true }
            let inputPassword = string.trimmingCharacters(in: .whitespacesAndNewlines)
                       let newPassword = rePassword.replacingCharacters(in: newRange, with: inputPassword)
                           .trimmingCharacters(in: .whitespacesAndNewlines)
            let isValid = newPassword.isValidPassword
            if (newPassword == password) && isValid {
                signupWithEmailViewModel.setIsEnabledSignupButton(true)
                signupWithEmailView.passwordLabel.text = "사용할 비밀번호를 입력해 주세요."
            } else if newPassword != password {
                signupWithEmailView.passwordLabel.text = "비밀번호가 일치하지 않아요."
                signupWithEmailViewModel.setIsEnabledSignupButton(false)
            }
            signupWithEmailViewModel.setIsEnabledSignupButton(isValid)
            return true
            
        case signupWithEmailView.idTextField:
            guard let id = textField.text,
                  let newRange = Range(range, in: id) else { return true }
            let inputID = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newID = id.replacingCharacters(in: newRange, with: inputID).trimmingCharacters(in: .whitespacesAndNewlines)
            let isValid = newID.isValidID
            signupWithEmailViewModel.setIsEnabledSignupButton(isValid)
            if isValid {
                signupWithEmailView.idLabel.text = "사용할 아이디를 입력해 주세요."
                signupWithEmailView.idDuplicateButton.isEnabled = true
                signupWithEmailView.idDuplicateButton.backgroundColor = UIColor(named: "TitleColor")
            } else {
                signupWithEmailView.idLabel.text = "사용할 아이디를 8~16자로 입력해 주세요. \n 영어 대소문자, 숫자, 특수문자만 입력할 수 있어요."
                signupWithEmailView.idDuplicateButton.isEnabled = false
                signupWithEmailView.idDuplicateButton.backgroundColor = .lightGray
            }
            return true
            
        case signupWithEmailView.nicknameTextField:
            guard let nickname = textField.text,
                  let newRange = Range(range, in: nickname) else { return true }
            let inputNickname = string.trimmingCharacters(in: .whitespacesAndNewlines)
            let newNickname = nickname.replacingCharacters(in: newRange, with: inputNickname).trimmingCharacters(in: .whitespacesAndNewlines)
            let isValid = newNickname.isValidNickname
            signupWithEmailViewModel.setIsCheckedValidNickname(isValid)
            if isValid {
                signupWithEmailView.nicknameLabel.text = "친구들에게 보여질 이름을 입력해 주세요."
            } else {
                signupWithEmailView.nicknameLabel.text = "한글만 가능하며, 13자 이내로 입력해 주세요."
            }
            return true
            
        default:
            return true
        }
    }
}
