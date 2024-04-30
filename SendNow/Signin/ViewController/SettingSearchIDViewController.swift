//
//  SettingSearchIDViewController.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SettingSearchIDViewController: UIViewController {
    private let settingSearchIDView = SettingSearchIDView()
    private let signupWithEmailViewModel = SignupWithEmailViewModel()
    private let signinViewModel = SigninViewModel()
    private let disposeBag = DisposeBag()

    
    init(appleMemberInfo: SigninWithAppleDomain? = nil) {
        super.init(nibName: nil, bundle: nil)
        guard let appleMemberInfo = appleMemberInfo else {
            signinViewModel.signinType = .kakao
            return
        }
        signinViewModel.setSignupWithAppleInfo(appleMemberInfo)
        signinViewModel.signinType = .apple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSettingSearchIDView()
        addSubviews()
        setLayoutConstraintsSigninView()
        bindAll()
    }
}

extension SettingSearchIDViewController {
    private func configureSettingSearchIDView() {
        settingSearchIDView.translatesAutoresizingMaskIntoConstraints = false
        settingSearchIDView.idTextField.delegate = self
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(settingSearchIDView)
    }
    
    private func setLayoutConstraintsSigninView() {
        NSLayoutConstraint.activate([
            settingSearchIDView.topAnchor.constraint(equalTo: view.topAnchor),
            settingSearchIDView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingSearchIDView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingSearchIDView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Bind
    private func bindAll() {
        bindIdDuplicateButton()
        bindIsDuplicatedID()
        bindSignupButton()
        bindIsSuccessedSignupWithKakao()
        bindIsSuccessedUpdatedSearchID()
    }
    
    private func bindIdDuplicateButton() {
        settingSearchIDView.idDuplicateButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let id = self?.settingSearchIDView.idTextField.text,
                      !id.isEmpty else { return }
                self?.signupWithEmailViewModel.checkDuplicateID(nickname: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsDuplicatedID() {
        signupWithEmailViewModel.isDuplicatedID
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isDuplicatedID in
                guard isDuplicatedID else {
                    self?.settingSearchIDView.idLabel.text = "사용 가능한 아이디예요."
                    self?.settingSearchIDView.signupButton.backgroundColor = UIColor(named: "TitleColor")
                    self?.settingSearchIDView.signupButton.isEnabled = true
                    return }
                self?.settingSearchIDView.idLabel.text = "중복된 아이디입니다. 다른 아이디를 입력해 주세요."
                self?.settingSearchIDView.signupButton.backgroundColor = .lightGray
                self?.settingSearchIDView.signupButton.isEnabled = false
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSignupButton() {
        settingSearchIDView.signupButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                guard let id = self?.settingSearchIDView.idTextField.text,
                      !id.isEmpty else { return }
                switch self?.signinViewModel.signinType {
                case .kakao:
                    self?.signinViewModel.signupWithKakao(id: id)
                case .apple:
                    guard let appleToken = self?.signinViewModel.signupWithAppleInfo?.appleToken else { return }
                    self?.signinViewModel.updateSearchID(appleToken, id)
                default: return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSuccessedSignupWithKakao() {
        signinViewModel.isSuccessedSignupWithKakao
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSuccessedSignupWithKakao in
                guard isSuccessedSignupWithKakao else { return }
                let rootViewController = MainTabBarController()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindIsSuccessedUpdatedSearchID() {
        signinViewModel.isSuccessedUpdatedSearchID
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {[weak self] isSuccessedUpdatedSearchID in
                guard isSuccessedUpdatedSearchID,
                      let appleToken = self?.signinViewModel.signupWithAppleInfo?.appleToken else { return }
                self?.signinViewModel.signinWithApple(appleToken)
                let rootViewController = MainTabBarController()
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                sceneDelegate.changeRootViewController(rootViewController, animated: true)
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: UITextFieldDelegate
extension SettingSearchIDViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let id = textField.text,
              let newRange = Range(range, in: id) else { return true }
        let inputID = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let newID = id.replacingCharacters(in: newRange, with: inputID).trimmingCharacters(in: .whitespacesAndNewlines)
        
        if newID.isValidID {
            settingSearchIDView.idLabel.text = "사용할 아이디를 입력해 주세요."
            settingSearchIDView.idDuplicateButton.isEnabled = true
            settingSearchIDView.idDuplicateButton.backgroundColor = UIColor(named: "TitleColor")
        } else {
            settingSearchIDView.idLabel.text = "사용할 아이디를 8~16자로 입력해 주세요. \n 영어 대소문자, 숫자, 특수문자만 입력할 수 있어요."
            settingSearchIDView.idDuplicateButton.isEnabled = false
            settingSearchIDView.idDuplicateButton.backgroundColor = .lightGray
        }
        return true
    }
}
