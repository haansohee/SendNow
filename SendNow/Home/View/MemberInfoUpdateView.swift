//
//  MemberInfoUpdateView.swift
//  SendNow
//
//  Created by 한소희 on 4/28/24.
//

import UIKit

final class MemberInfoUpdateView: UIView {
    let nicknameLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "수정할 닉네임을 입력하세요."
        return label
    }()
    
    let nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        return textField
    }()
    
    let nicknameUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let accountNumberLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "친구에게 송금받을 계좌번호를 입력 후 등록해 주세요."
        label.numberOfLines = 0
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
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .medium)
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
    
    let accountNumberUploadButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let kakaoPayLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "카카오페이 링크를 등록해 놓으면 \n 친구가 편하게 입금해 줄 수 있어요!"
        label.numberOfLines = 0
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
    
    let kakaoPayUrlUploadButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
    }()
    
    private let kakaoPayUrlUploadDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "🌟 카카오톡 [더보기] 탭에서 ⚙️ 버튼 옆에 있는 \n QR코드 버튼 클릭 후, 아래와 같은 순서로 카카오페이 송금 링크를 발급받을 수 있어요."
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 5.0
        return stackView
    }()
    
    private let kakaoPayUploadDescriptionWonSignImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "wonsign.circle")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let kakaoPayUploadDescriptionArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let kakaoPayUploadDescriptionLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "link")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let withoutButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
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

extension MemberInfoUpdateView {
    private func addSubviews() {
        [
            nicknameLabel,
            nicknameTextField,
            nicknameUpdateButton,
            accountNumberLabel,
            bankNameUploadTextField,
            bankNameUploadButton,
            accountNumberUploadTextField,
            accountNumberUploadButton,
            kakaoPayLabel,
            kakaoPayUrlUploadTextField,
            kakaoPayUrlUploadButton,
            kakaoPayUrlUploadDescriptionLabel,
            imageStackView,
            withoutButton
        ].forEach { self.addSubview($0) }
        [
            kakaoPayUploadDescriptionWonSignImageView,
            kakaoPayUploadDescriptionArrowImageView,
            kakaoPayUploadDescriptionLinkImageView
        ].forEach { imageStackView.addSubview($0) }
    }
    
    func configureMemberAccountInfo(bankName: String, accountNumber: String, kakaoPayUrl: String) {
        bankNameUploadTextField.placeholder = bankName
        accountNumberUploadTextField.placeholder = accountNumber
        kakaoPayUrlUploadTextField.placeholder = kakaoPayUrl
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            nicknameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 12.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 220.0),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            nicknameUpdateButton.topAnchor.constraint(equalTo: nicknameTextField.topAnchor),
            nicknameUpdateButton.leadingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor, constant: 8.0),
            nicknameUpdateButton.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            nicknameUpdateButton.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            accountNumberLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 50.0),
            accountNumberLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            accountNumberLabel.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            accountNumberLabel.heightAnchor.constraint(equalTo: nicknameLabel.heightAnchor),
            
            bankNameUploadTextField.topAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor, constant: 12.0),
            bankNameUploadTextField.leadingAnchor.constraint(equalTo: accountNumberLabel.leadingAnchor),
            bankNameUploadTextField.widthAnchor.constraint(equalTo: nicknameTextField.widthAnchor),
            bankNameUploadTextField.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            bankNameUploadButton.topAnchor.constraint(equalTo: bankNameUploadTextField.topAnchor),
            bankNameUploadButton.leadingAnchor.constraint(equalTo: bankNameUploadTextField.trailingAnchor, constant: 8.0),
            bankNameUploadButton.trailingAnchor.constraint(equalTo: accountNumberLabel.trailingAnchor),
            bankNameUploadButton.heightAnchor.constraint(equalTo: bankNameUploadTextField.heightAnchor),
            
            accountNumberUploadTextField.topAnchor.constraint(equalTo: bankNameUploadTextField.bottomAnchor, constant: 12.0),
            accountNumberUploadTextField.leadingAnchor.constraint(equalTo: accountNumberLabel.leadingAnchor),
            accountNumberUploadTextField.widthAnchor.constraint(equalTo: nicknameTextField.widthAnchor),
            accountNumberUploadTextField.heightAnchor.constraint(equalTo: bankNameUploadTextField.heightAnchor),
            
            accountNumberUploadButton.topAnchor.constraint(equalTo: accountNumberUploadTextField.topAnchor),
            accountNumberUploadButton.leadingAnchor.constraint(equalTo: accountNumberUploadTextField.trailingAnchor, constant: 8.0),
            accountNumberUploadButton.trailingAnchor.constraint(equalTo: accountNumberLabel.trailingAnchor),
            accountNumberUploadButton.heightAnchor.constraint(equalTo: accountNumberUploadTextField.heightAnchor),
            
            
            kakaoPayLabel.topAnchor.constraint(equalTo: accountNumberUploadTextField.bottomAnchor, constant: 50.0),
            kakaoPayLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            kakaoPayLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            kakaoPayLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            kakaoPayUrlUploadTextField.topAnchor.constraint(equalTo: kakaoPayLabel.bottomAnchor, constant: 12.0),
            kakaoPayUrlUploadTextField.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            kakaoPayUrlUploadTextField.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            kakaoPayUrlUploadTextField.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            kakaoPayUrlUploadButton.topAnchor.constraint(equalTo: kakaoPayUrlUploadTextField.topAnchor),
            kakaoPayUrlUploadButton.leadingAnchor.constraint(equalTo: nicknameUpdateButton.leadingAnchor),
            kakaoPayUrlUploadButton.trailingAnchor.constraint(equalTo: nicknameUpdateButton.trailingAnchor),
            kakaoPayUrlUploadButton.heightAnchor.constraint(equalTo: nicknameUpdateButton.heightAnchor),
            
            kakaoPayUrlUploadDescriptionLabel.topAnchor.constraint(equalTo: kakaoPayUrlUploadTextField.bottomAnchor, constant: 36.0),
            kakaoPayUrlUploadDescriptionLabel.leadingAnchor.constraint(equalTo: kakaoPayLabel.leadingAnchor),
            kakaoPayUrlUploadDescriptionLabel.trailingAnchor.constraint(equalTo: kakaoPayLabel.trailingAnchor),
            kakaoPayUrlUploadDescriptionLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            imageStackView.topAnchor.constraint(equalTo: kakaoPayUrlUploadDescriptionLabel.bottomAnchor, constant: 12.0),
            imageStackView.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            imageStackView.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            imageStackView.heightAnchor.constraint(equalToConstant: 30.0),
            
            kakaoPayUploadDescriptionWonSignImageView.topAnchor.constraint(equalTo: imageStackView.topAnchor),
            kakaoPayUploadDescriptionWonSignImageView.leadingAnchor.constraint(equalTo: imageStackView.leadingAnchor, constant: 44.0),
            kakaoPayUploadDescriptionWonSignImageView.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor),
            kakaoPayUploadDescriptionWonSignImageView.widthAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.heightAnchor),
            
            kakaoPayUploadDescriptionArrowImageView.topAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.topAnchor),
            kakaoPayUploadDescriptionArrowImageView.centerXAnchor.constraint(equalTo: imageStackView.centerXAnchor),
            kakaoPayUploadDescriptionArrowImageView.widthAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.widthAnchor),
            kakaoPayUploadDescriptionArrowImageView.heightAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.heightAnchor),
            
            kakaoPayUploadDescriptionLinkImageView.topAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.topAnchor),
            kakaoPayUploadDescriptionLinkImageView.trailingAnchor.constraint(equalTo: imageStackView.trailingAnchor, constant: -44.0),
            kakaoPayUploadDescriptionLinkImageView.widthAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.widthAnchor),
            kakaoPayUploadDescriptionLinkImageView.heightAnchor.constraint(equalTo: kakaoPayUploadDescriptionWonSignImageView.heightAnchor),
            
            withoutButton.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 50.0),
            withoutButton.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            withoutButton.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            withoutButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
}
