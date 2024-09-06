//
//  SettingNicknameView.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import UIKit

final class SettingNicknameView: UIView {
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
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        return textField
    }()
    
    let nicknameDuplicateButton: AnimationButton = {
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

extension SettingNicknameView {
    private func addSubviews() {
        [
            nicknameLabel,
            nicknameTextField,
            nicknameDuplicateButton,
            signupButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 55.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            nicknameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 34.0),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 12.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 230.0),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            nicknameDuplicateButton.topAnchor.constraint(equalTo: nicknameTextField.topAnchor),
            nicknameDuplicateButton.leadingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor, constant: 8.0),
            nicknameDuplicateButton.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            nicknameDuplicateButton.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            signupButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 24.0),
            signupButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            signupButton.heightAnchor.constraint(equalToConstant: 35.0),
            signupButton.widthAnchor.constraint(equalToConstant: 60.0)
        ])
    }
    
    func configureNicknameDuplicateButton(_ isEnabled: Bool) {
        nicknameDuplicateButton.isEnabled = isEnabled
        nicknameDuplicateButton.backgroundColor = isEnabled ? UIColor(named: "SubTitleColor") : .lightGray
        nicknameDuplicateButton.setTitleColor(isEnabled ? .black : .white, for: .normal)
    }
    
    func configureSignupButton(_ isEnabled: Bool) {
        signupButton.isEnabled = isEnabled
        signupButton.backgroundColor = isEnabled ? UIColor(named: "TitleColor") : .lightGray
    }
}
