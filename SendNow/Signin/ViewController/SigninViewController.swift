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

final class SigninViewController: UIViewController {
    private let signinView = SigninView()
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
    }
    
    private func bindSignupWithEmailButton() {
        signinView.signupWithEmail.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                self?.navigationController?.pushViewController(SignupWithEmailViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
