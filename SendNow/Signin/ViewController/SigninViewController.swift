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

final class SigninViewController: UIViewController {
    private let signinView = SigninView()
    private let signinViewModel = SigninViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSigninView()
        addSubviews()
        setLayoutConstraintsSigninView()
        bindAll()
    }
}

extension SigninViewController {
    private func configureSigninView() {
        signinView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        self.hideKeyboardGesture()
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
    
    private func bindAll() {
        bindSignupWithEmailButton()
        bindSigninWithKakaoButton()
        bindSigninWithAppleButton()
        bindSigninButton()
        bindRegistrationRequired()
        bindIsExistedSearchID()
        bindIsSuccessedSignupWithApple()
        bindIsExistedEmail()
        bindIsPasswordMatching()
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
            .asDriver()
            .drive(onNext: {[weak self] _ in
                guard let email = self?.signinView.emailTextField.text,
                      let password = self?.signinView.passwordTextField.text,
                      !(email.isEmpty),
                      !(password.isEmpty) else { return }
                self?.signinViewModel.signinWithEmail(email)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindRegistrationRequired() {
        signinViewModel.isRegisteredKakaoMember
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isRegisteredKakaoMember in
                print("isRegisteredKakaoMember: \(isRegisteredKakaoMember)")
                guard isRegisteredKakaoMember else {
                    let rootViewController = MainTabBarController()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.changeRootViewController(rootViewController, animated: true)
                    return }
                self?.navigationController?.pushViewController(SettingSearchIDViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsExistedSearchID() {
        signinViewModel.isExistedSearchID
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isExistedSearchID in
                guard !isExistedSearchID else {
                    let rootViewController = MainTabBarController()
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                    sceneDelegate.changeRootViewController(rootViewController, animated: true)
                    return }
                guard let appleMemberInfo = self?.signinViewModel.signupWithAppleInfo else { return }
                self?.navigationController?.pushViewController(SettingSearchIDViewController(appleMemberInfo: appleMemberInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSuccessedSignupWithApple() {
        signinViewModel.isSuccessedSignupWithApple
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSuccessedSignupWithApple in
                guard isSuccessedSignupWithApple else { return }
                guard let signupWithAppleInfo = self?.signinViewModel.signupWithAppleInfo else { return }
                self?.navigationController?.pushViewController(SettingSearchIDViewController(appleMemberInfo: signupWithAppleInfo), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsExistedEmail() {
        signinViewModel.isExistedEmail
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isExistedEmail in
                guard isExistedEmail else {
                    self?.blankAlert(title: "바로보내", message: "존재하지 않는 이메일이에요.")
                    return
                }
                guard let inputPassword = self?.signinView.passwordTextField.text,
                      !(inputPassword.isEmpty) else { return }
                self?.signinViewModel.isPasswordMatching(inputPassword)
                let rootViewController = MainTabBarController()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsPasswordMatching() {
        signinViewModel.isPasswordMatching
            .asDriver(onErrorJustReturn: false)
            .drive(onNext:{[weak self] isPasswordMatching in
                guard isPasswordMatching else {
                    self?.blankAlert(title: "바로보내", message: "이메일 혹은 비밀번호가 일치하지 않아요.")
                    return }
                self?.signinViewModel.setUserDefaultsEmailMember()
            })
            .disposed(by: disposeBag)
    }
    
    private func blankAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "확인", style: .cancel) { _ in }
        alertController.addAction(doneAction)
        self.present(alertController, animated: true)
    }
}

extension SigninViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = credential.user
            guard let identityToken = credential.identityToken,
                  let appleToken = String(data: identityToken, encoding: .utf8),
                  let fullName = credential.fullName else { return }
            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: userIdentifier) {[weak self] credentialState, error in
                switch credentialState {
                case .authorized:
                    if let email = credential.email {
                        guard let familyName = fullName.familyName,
                              let givenName = fullName.givenName else { return }
                        let nickname = "\(familyName)\(givenName)"
                        let appleMemberInfo = SigninWithAppleDomain(searchID: "", nickname: nickname, email: email, appleToken: appleToken)
                        self?.signinViewModel.signupWithApple(appleMemberInfo)
                    } else {
                        self?.signinViewModel.signinWithApple(appleToken)
                    }
                    return
                default: return
                }
            }
        }
    }
}

extension SigninViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
