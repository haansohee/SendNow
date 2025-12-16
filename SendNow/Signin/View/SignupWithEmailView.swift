//
//  SignupWithEmailView.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit

final class SignupWithEmailView: UIScrollView {
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let emailLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "사용할 이메일을 입력해 주세요."
        return label
    }()
    
    let emailTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "EMAIL"
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    private let atSignLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "@"
        return label
    }()
    
    let emailAddressTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "이메일 양식을 선택하세요."
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.keyboardType = .asciiCapable
        textField.isEnabled = false
        return textField
    }()
    
    let naverAddressButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Naver", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let gmailAddressButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Gmail", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let icloudAddressButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("iCloud", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let directInputAddressButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("직접 입력", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let emailAuthSuccessLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "이메일 인증을 진행해 주세요."
        label.numberOfLines = 0
        return label
    }()
    
    let emailAuthTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "메일로 전송된 인증번호를 입력하세요."
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let sendAuthCodeButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("인증번호 전송", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let emailAuthButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("인증번호 확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let passwordLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "사용할 비밀번호를 입력해 주세요."
        label.numberOfLines = 0
        return label
    }()
    
    let passwordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "PASSWORD"
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let rePasswordTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "REPASSWORD"
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.keyboardType = .asciiCapable
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let nicknameLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "친구와 공유할 닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요."
        label.numberOfLines = 0
        return label
    }()
    
    let nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "NICKNAME"
        textField.font = .customFont(.pretendardLight, size: 12.0)
        return textField
    }()
    
    let nicknameDuplicateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let signupButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.titleLabel?.font = .customFont(.pretendardRegular, size: 12.0)
        button.layer.cornerRadius = 3.0
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
    
    func setEmailAddressTextField(_ text: String, _ isEnabled: Bool) {
        emailAddressTextField.text = text
        emailAddressTextField.isEnabled = isEnabled
    }
}

extension SignupWithEmailView {
    private func addSubviews() {
        self.addSubview(containerView)
        [
            emailLabel,
            emailTextField,
            atSignLabel,
            emailAddressTextField,
            naverAddressButton,
            gmailAddressButton,
            icloudAddressButton,
            directInputAddressButton,
            sendAuthCodeButton,
            emailAuthSuccessLabel,
            emailAuthTextField,
            emailAuthButton,
            passwordLabel,
            passwordTextField,
            rePasswordTextField,
            nicknameLabel,
            nicknameTextField,
            nicknameDuplicateButton,
            signupButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.contentLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.contentLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.contentLayoutGuide.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            emailLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 36.0),
            emailLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24.0),
            emailLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24.0),
            emailLabel.heightAnchor.constraint(equalToConstant: 24.0),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5.0),
            emailTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            atSignLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            atSignLabel.leadingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            atSignLabel.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            atSignLabel.widthAnchor.constraint(equalToConstant: 30.0),
            
            emailAddressTextField.topAnchor.constraint(equalTo: emailTextField.topAnchor),
            emailAddressTextField.leadingAnchor.constraint(equalTo: atSignLabel.trailingAnchor),
            emailAddressTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailAddressTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            naverAddressButton.topAnchor.constraint(equalTo: emailAddressTextField.bottomAnchor, constant: 8.0),
            naverAddressButton.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            naverAddressButton.widthAnchor.constraint(equalToConstant: 80.0),
            naverAddressButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            gmailAddressButton.topAnchor.constraint(equalTo: naverAddressButton.topAnchor),
            gmailAddressButton.leadingAnchor.constraint(equalTo: naverAddressButton.trailingAnchor, constant: 7.0),
            gmailAddressButton.widthAnchor.constraint(equalTo: naverAddressButton.widthAnchor),
            gmailAddressButton.heightAnchor.constraint(equalTo: naverAddressButton.heightAnchor),
            
            icloudAddressButton.topAnchor.constraint(equalTo: naverAddressButton.topAnchor),
            icloudAddressButton.leadingAnchor.constraint(equalTo: gmailAddressButton.trailingAnchor, constant: 7.0),
            icloudAddressButton.widthAnchor.constraint(equalTo: naverAddressButton.widthAnchor),
            icloudAddressButton.heightAnchor.constraint(equalTo: naverAddressButton.heightAnchor),
            
            directInputAddressButton.topAnchor.constraint(equalTo: naverAddressButton.topAnchor),
            directInputAddressButton.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            directInputAddressButton.widthAnchor.constraint(equalTo: naverAddressButton.widthAnchor),
            directInputAddressButton.heightAnchor.constraint(equalTo: naverAddressButton.heightAnchor),
            
            sendAuthCodeButton.topAnchor.constraint(equalTo: directInputAddressButton.bottomAnchor, constant: 24.0),
            sendAuthCodeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            sendAuthCodeButton.widthAnchor.constraint(equalToConstant: 85.0),
            sendAuthCodeButton.heightAnchor.constraint(equalToConstant: 35.0),
            
            emailAuthSuccessLabel.topAnchor.constraint(equalTo: sendAuthCodeButton.bottomAnchor, constant: 24.0),
            emailAuthSuccessLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailAuthSuccessLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailAuthSuccessLabel.heightAnchor.constraint(equalTo: emailLabel.heightAnchor),
            
            emailAuthTextField.topAnchor.constraint(equalTo: emailAuthSuccessLabel.bottomAnchor, constant: 5.0),
            emailAuthTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            emailAuthTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            emailAuthTextField.widthAnchor.constraint(equalToConstant: 230.0),
            
            emailAuthButton.topAnchor.constraint(equalTo: emailAuthTextField.topAnchor),
            emailAuthButton.leadingAnchor.constraint(equalTo: emailAuthTextField.trailingAnchor, constant: 8.0),
            emailAuthButton.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            emailAuthButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            passwordLabel.topAnchor.constraint(equalTo: emailAuthButton.bottomAnchor, constant: 48.0),
            passwordLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            passwordLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5.0),
            passwordTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            rePasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5.0),
            rePasswordTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            rePasswordTextField.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            rePasswordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: rePasswordTextField.bottomAnchor, constant: 48.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            nicknameLabel.heightAnchor.constraint(equalTo: passwordLabel.heightAnchor),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 5.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: emailLabel.leadingAnchor),
            nicknameTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            nicknameTextField.widthAnchor.constraint(equalTo: emailAuthTextField.widthAnchor),
            
            nicknameDuplicateButton.topAnchor.constraint(equalTo: nicknameTextField.topAnchor),
            nicknameDuplicateButton.leadingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor, constant: 8.0),
            nicknameDuplicateButton.trailingAnchor.constraint(equalTo: emailLabel.trailingAnchor),
            nicknameDuplicateButton.heightAnchor.constraint(equalTo: emailTextField.heightAnchor),
            
            signupButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 12.0),
            signupButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 35.0),
            signupButton.widthAnchor.constraint(equalToConstant: 60.0)
        ])
    }
}
