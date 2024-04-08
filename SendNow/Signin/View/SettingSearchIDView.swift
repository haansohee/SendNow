//
//  SettingSearchIDView.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import UIKit

final class SettingSearchIDView: UIView {
    let idLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "친구 검색 시 사용될 아이디를 입력해 주세요. \n 영문자, 숫자, 특수문자만 입력 가능해요."
        label.numberOfLines = 0
        return label
    }()
    
    let idTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "ID"
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    let idDuplicateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("중복확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .medium)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    private let nicknameLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "친구들에게 보여질 이름을 입력해 주세요."
        label.isHidden = true
        return label
    }()
    
    private let nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "NICKNAME"
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.isHidden = true
        return textField
    }()
    
    let signupButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("가입하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .medium)
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
}

extension SettingSearchIDView {
    private func addSubviews() {
        [
            idLabel,
            idTextField,
            idDuplicateButton,
            nicknameLabel,
            nicknameTextField,
            signupButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            idLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 55.0),
            idLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            idLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            idLabel.heightAnchor.constraint(equalToConstant: 34.0),
            
            idTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 12.0),
            idTextField.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            idTextField.widthAnchor.constraint(equalToConstant: 230.0),
            idTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            idDuplicateButton.topAnchor.constraint(equalTo: idTextField.topAnchor),
            idDuplicateButton.leadingAnchor.constraint(equalTo: idTextField.trailingAnchor, constant: 8.0),
            idDuplicateButton.trailingAnchor.constraint(equalTo: idLabel.trailingAnchor),
            idDuplicateButton.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 24.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: idLabel.trailingAnchor),
            nicknameLabel.heightAnchor.constraint(equalTo: idLabel.heightAnchor),
            
            nicknameTextField.topAnchor.constraint(equalTo: idLabel.bottomAnchor, constant: 12.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: idLabel.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: idLabel.trailingAnchor),
            nicknameTextField.heightAnchor.constraint(equalTo: idTextField.heightAnchor),
            
            signupButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 12.0),
            signupButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 35.0),
            signupButton.widthAnchor.constraint(equalToConstant: 60.0)
        ])
    }
}
