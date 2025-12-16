//
//  SigninView.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit

final class SigninView: UIView {
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "간편한 정산 앱 💸"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .customFont(.pretendardLight, size: 21.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바로 보내"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .customFont(.pretendardBold, size: 25.0)
        return label
    }()
    
    let emailTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "EMAIL"
        textField.borderStyle = .none
        textField.font = .customFont(.pretendardLight, size: 15.0)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "PASSWORD"
        textField.borderStyle = .none
        textField.font = .customFont(.pretendardLight, size: 15.0)
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signinButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 15.0)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let signupWithEmail: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이메일로 가입하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 15.0)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let signinWithSNSLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SNS계정으로 이용해 보세요."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .customFont(.pretendardLight, size: 15.0)
        return label
    }()
    
    let signinWithAppleButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        button.setTitle(" Apple로 계속하기", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 15.0)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let signinWithKakaoButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "kakao_sigin_logo"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SigninView {
    private func addSubviews() {
        [
            subTitleLabel,
            titleLabel,
            emailTextField,
            passwordTextField,
            signinButton,
            signinWithSNSLabel,
            signupWithEmail,
            signinWithAppleButton,
            signinWithKakaoButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 88.0),
            subTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 42.0),
            subTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -42.0),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42.0),
            emailTextField.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5.0),
            passwordTextField.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            signinButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8.0),
            signinButton.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            signinButton.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            signinButton.heightAnchor.constraint(equalToConstant: 45.0),
            
            signupWithEmail.topAnchor.constraint(equalTo: signinButton.bottomAnchor, constant: 12.0),
            signupWithEmail.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            signupWithEmail.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            signupWithEmail.heightAnchor.constraint(equalTo: signinButton.heightAnchor),
            
            signinWithSNSLabel.topAnchor.constraint(equalTo: signupWithEmail.bottomAnchor, constant: 65.0),
            signinWithSNSLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            signinWithSNSLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            signinWithSNSLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            signinWithAppleButton.topAnchor.constraint(equalTo: signinWithSNSLabel.bottomAnchor, constant: 5.0),
            signinWithAppleButton.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            signinWithAppleButton.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            signinWithAppleButton.heightAnchor.constraint(equalTo: signinButton.heightAnchor),
            
            signinWithKakaoButton.topAnchor.constraint(equalTo: signinWithAppleButton.bottomAnchor, constant: 12.0),
            signinWithKakaoButton.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            signinWithKakaoButton.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            signinWithKakaoButton.heightAnchor.constraint(equalTo: signinButton.heightAnchor),
        ])
    }
}
