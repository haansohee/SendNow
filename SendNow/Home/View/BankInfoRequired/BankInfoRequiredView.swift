//
//  BankInfoRequiredView.swift
//  SendNow
//
//  Created by 한소희 on 2/24/25.
//

import UIKit

final class BankInfoRequiredView: UIView {
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "친구에게 송금받을 계좌번호 혹은 카카오페이 링크 중 하나를 반드시 등록해 주세요."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let bankAccountInpuLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "계좌번호 등록하기"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    let bankNameUploadTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.isEnabled = false
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.placeholder = "은행 기관을 선택하세요."
        return textField
    }()
    
    let bankNameUploadButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.setTitle("은행기관 선택", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    let accountNumberUploadTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.placeholder = "계좌번호"
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let kakaoPayURLInputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "카카오페이 송금 링크 등록하기\n💡 카카오톡 [더보기] 탭에서 ⚙️ 버튼 옆에 있는 [QR코드 버튼] 클릭 후,\n송금코드 (￦) 버튼을 클릭 하면 카카오페이 송금 링크를 복사🔗 할 수 있어요."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()
    
    let kakaoPayUrlUploadTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.placeholder = "송금 코드 링크를 입력해 주세요."
        return textField
    }()
    
    let uploadButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubivews()
        setLayoutConstraints()
        self.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BankInfoRequiredView {
    private func addSubivews() {
        [
            descriptionTitleLabel,
            bankAccountInpuLabel,
            bankNameUploadTextField,
            bankNameUploadButton,
            accountNumberUploadTextField,
            kakaoPayURLInputLabel,
            kakaoPayUrlUploadTextField,
            uploadButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            bankAccountInpuLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 24.0),
            bankAccountInpuLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            bankAccountInpuLabel.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            bankAccountInpuLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            bankNameUploadButton.topAnchor.constraint(equalTo: bankAccountInpuLabel.bottomAnchor, constant: 8.0),
            bankNameUploadButton.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            bankNameUploadButton.widthAnchor.constraint(equalToConstant: 100.0),
            bankNameUploadButton.heightAnchor.constraint(equalToConstant: 35.0),
            
            bankNameUploadTextField.topAnchor.constraint(equalTo: bankNameUploadButton.topAnchor),
            bankNameUploadTextField.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            bankNameUploadTextField.trailingAnchor.constraint(equalTo: bankNameUploadButton.leadingAnchor, constant: -8.0),
            bankNameUploadTextField.heightAnchor.constraint(equalTo: bankNameUploadButton.heightAnchor),
            
            accountNumberUploadTextField.topAnchor.constraint(equalTo: bankNameUploadTextField.bottomAnchor, constant: 8.0),
            accountNumberUploadTextField.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            accountNumberUploadTextField.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            accountNumberUploadTextField.heightAnchor.constraint(equalTo: bankNameUploadTextField.heightAnchor),
            
            kakaoPayURLInputLabel.topAnchor.constraint(equalTo: accountNumberUploadTextField.bottomAnchor, constant: 24.0),
            kakaoPayURLInputLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            kakaoPayURLInputLabel.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            kakaoPayURLInputLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            kakaoPayUrlUploadTextField.topAnchor.constraint(equalTo: kakaoPayURLInputLabel.bottomAnchor, constant: 8.0),
            kakaoPayUrlUploadTextField.leadingAnchor.constraint(equalTo: accountNumberUploadTextField.leadingAnchor),
            kakaoPayUrlUploadTextField.trailingAnchor.constraint(equalTo: accountNumberUploadTextField.trailingAnchor),
            kakaoPayUrlUploadTextField.heightAnchor.constraint(equalTo: bankNameUploadTextField.heightAnchor),
            
            uploadButton.widthAnchor.constraint(equalToConstant: 120.0),
            uploadButton.heightAnchor.constraint(equalToConstant: 40.0),
            uploadButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
}
