//
//  SettingNicknameViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SettingNicknameViewController: BaseUIViewController {
    private let settingNicknameView = SettingNicknameView()
    private let signupWithEmailViewModel: SignupWithEmailViewModel
    private let signinViewModel = SigninViewModel()
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
        configureSettingNicknameView()
        addSubviews()
        setLayoutConstraintsSigninView()
        bindAll()
    }
}

extension SettingNicknameViewController {
    private func configureSettingNicknameView() {
        settingNicknameView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(settingNicknameView)
    }
    
    private func setLayoutConstraintsSigninView() {
        NSLayoutConstraint.activate([
            settingNicknameView.topAnchor.constraint(equalTo: view.topAnchor),
            settingNicknameView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingNicknameView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingNicknameView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindNicknameDuplicateButton()
        bindNicknameTextField()
        bindIsDuplicatedNickname()
        bindSignupButton()
        bindIsSuccessedUpdatedNickname()
    }
    
    private func bindNicknameDuplicateButton() {
        settingNicknameView.nicknameDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let id = self?.settingNicknameView.nicknameTextField.text,
                      !id.isEmpty else { return }
                self?.signupWithEmailViewModel.isDuplicatedNickname(nickname: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindNicknameTextField() {
        settingNicknameView.nicknameTextField.rx.text
            .orEmpty
            .asDriver()
            .drive(onNext: {[weak self] inputNickname in
                self?.settingNicknameView.configureSignupButton(false)
                let isValid = inputNickname.isValidNickname
                self?.settingNicknameView.nicknameLabel.text = isValid ? "" : "닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요."
                self?.settingNicknameView.configureNicknameDuplicateButton(isValid)
                guard isValid else {
                    self?.settingNicknameView.configureSignupButton(isValid)
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedNickname() {
        signupWithEmailViewModel.isDuplicatedNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedID in
                self?.settingNicknameView.nicknameLabel.text = isDuplicatedID ? "사용 가능한 닉네임이에요." : "중복된 닉네임이에요. 다른 닉네임을 입력해 주세요."
                self?.settingNicknameView.configureSignupButton(isDuplicatedID)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignupButton() {
        settingNicknameView.signupButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let nickname = self?.settingNicknameView.nicknameTextField.text,
                      !nickname.isEmpty else { return }
                self?.signinViewModel.updateNickname(nickname)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSuccessedUpdatedNickname() {
        signinViewModel.isSuccessedUpdatedNickname
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { isSuccessedUpdatedNickname in
                guard isSuccessedUpdatedNickname else { return }
                let rootViewController = MainTabBarController()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
