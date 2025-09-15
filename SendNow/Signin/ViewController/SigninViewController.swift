//
//  SigninViewController.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

final class SigninViewController: BaseUIViewController {
    private let signinView = SigninView()
    private let signinViewModel: SigninViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: SigninViewModel = SigninViewModel()) {
        self.signinViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSigninView()
        addSubviews()
        setLayoutConstraintsSigninView()
        registerForFCMTokenNotification()
        bindAll()
    }
}

extension SigninViewController {
    private func configureSigninView() {
        signinView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(signinView)
    }
    
    private func setLayoutConstraintsSigninView() {
        NSLayoutConstraint.activate([
            signinView.topAnchor.constraint(equalTo: view.topAnchor),
            signinView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signinView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signinView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: NotificationCenter
    private func registerForFCMTokenNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFcmToken), name: NSNotification.Name(NotificationName.fetchApnsToken.rawValue), object: nil)
    }
    
    @objc func updateFcmToken() {
        signinViewModel.updateFCMToken()
    }
    
    //MARK: Bind
    private func bindAll() {
        bindSignupWithEmailButton()
        bindSigninWithKakaoButton()
        bindSigninWithAppleButton()
        bindSigninButton()
        bindIsSuccessSignin()
        bindIsValidEmailPassword()
    }
    
    private func bindSignupWithEmailButton() {
        signinView.signupWithEmail.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(SignupWithEmailViewController(), animated: true)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSigninWithKakaoButton() {
        signinView.signinWithKakaoButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.signinViewModel.signinWithKakao()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSigninWithAppleButton() {
        signinView.signinWithAppleButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                let request = ASAuthorizationAppleIDProvider().createRequest()
                request.requestedScopes = [.email, .fullName]
                
                let controller = ASAuthorizationController(authorizationRequests: [request])
                controller.delegate = self
                controller.presentationContextProvider = self
                controller.performRequests()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSigninButton() {
        signinView.signinButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let email = self?.signinView.emailTextField.text,
                      let password = self?.signinView.passwordTextField.text,
                      !(email.isEmpty),
                      !(password.isEmpty) else {
                    DispatchQueue.main.async {
                        self?.confirmAlert(title: "바로보내", message: "이메일과 비밀번호를 입력해 주세요.")
                    }
                    return }
                self?.signinViewModel.isValidEmailPassword(email, password) // 가입되어 있는 이메일인지와 패스워드 일치여부 확인
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSuccessSignin() {
        signinViewModel.isSuccessSignin
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSuccessSignin in
                guard isSuccessSignin else {
                    self?.navigationController?.pushViewController(SettingNicknameViewController(), animated: true)
                    return }
                let rootViewController = MainTabBarController()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsValidEmailPassword() {
        signinViewModel.isValidEmailPassword
            .asDriver(onErrorJustReturn: false)
            .drive(onNext:{[weak self] isValidEmailPassword in  // 기입한 이메일의 가입 여부와 비밀번호 일치 여부 확인
                guard isValidEmailPassword else {
                    self?.confirmAlert(title: "바로보내", message: "가입된 이메일이 아니거나 비밀번호가 일치하지 않아요.")
                    return }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: ASAuthorizationControllerDelegate
extension SigninViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            guard let identityToken = credential.identityToken,
                  let appleToken = String(data: identityToken, encoding: .utf8),
                  let authorizationCodeData = credential.authorizationCode,
                  let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else { return }
            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: userIdentifier) {[weak self] credentialState, error in
                switch credentialState {
                case .authorized:
                    self?.signinViewModel.signinWithApple(appleToken, authorizationCode)
                    return
                    
                default:
                    print("🚨ERROR!! : \(credentialState.rawValue)")
                    self?.confirmAlert(title: "바로보내", message: "회원님의 애플 계정으로 로그인 및 회원가입이 불가능해요. \n 바로보내 고객센터로 문의해 주세요. \n 고객센터 이메일: balobonae@gmail.com")
                    return
                }
            }
        }
    }
}

//MARK: ASAuthorizationControllerPresentationContextProviding
extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
