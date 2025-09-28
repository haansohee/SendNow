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
        label.text = "수정할 닉네임을 3~16자 이내로 입력해 주세요. \n 영어, 한글, 숫자만 입력 가능해요.입력하세요."
        label.numberOfLines = 0
        return label
    }()
    
    let nicknameTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
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
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .medium)
        button.layer.cornerRadius = 5.0
        return button
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
    
    let cancelAccountButton: AnimationButton = {
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
            nicknameDuplicateButton,
            nicknameUpdateButton,
            kakaoPayLabel,
            kakaoPayUrlUploadTextField,
            kakaoPayUrlUploadButton,
            kakaoPayUrlUploadDescriptionLabel,
            imageStackView,
            cancelAccountButton
        ].forEach { self.addSubview($0) }
        [
            kakaoPayUploadDescriptionWonSignImageView,
            kakaoPayUploadDescriptionArrowImageView,
            kakaoPayUploadDescriptionLinkImageView
        ].forEach { imageStackView.addSubview($0) }
    }
    
    func configureMemberAccountInfo(kakaoPayUrl: String) {
        kakaoPayUrlUploadTextField.placeholder = kakaoPayUrl
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            nicknameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            nicknameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 12.0),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 220.0),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            nicknameDuplicateButton.topAnchor.constraint(equalTo: nicknameTextField.topAnchor),
            nicknameDuplicateButton.leadingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor, constant: 8.0),
            nicknameDuplicateButton.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            nicknameDuplicateButton.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            nicknameUpdateButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            nicknameUpdateButton.topAnchor.constraint(equalTo: nicknameDuplicateButton.bottomAnchor, constant: 14.0),
            nicknameUpdateButton.heightAnchor.constraint(equalTo: nicknameDuplicateButton.heightAnchor),
            nicknameUpdateButton.widthAnchor.constraint(equalTo: nicknameDuplicateButton.widthAnchor),

            kakaoPayLabel.topAnchor.constraint(equalTo: nicknameUpdateButton.bottomAnchor, constant: 50.0),
            kakaoPayLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            kakaoPayLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            kakaoPayLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            kakaoPayUrlUploadTextField.topAnchor.constraint(equalTo: kakaoPayLabel.bottomAnchor, constant: 12.0),
            kakaoPayUrlUploadTextField.leadingAnchor.constraint(equalTo: nicknameTextField.leadingAnchor),
            kakaoPayUrlUploadTextField.trailingAnchor.constraint(equalTo: nicknameTextField.trailingAnchor),
            kakaoPayUrlUploadTextField.heightAnchor.constraint(equalTo: nicknameTextField.heightAnchor),
            
            kakaoPayUrlUploadButton.topAnchor.constraint(equalTo: kakaoPayUrlUploadTextField.topAnchor),
            kakaoPayUrlUploadButton.leadingAnchor.constraint(equalTo: nicknameDuplicateButton.leadingAnchor),
            kakaoPayUrlUploadButton.trailingAnchor.constraint(equalTo: nicknameDuplicateButton.trailingAnchor),
            kakaoPayUrlUploadButton.heightAnchor.constraint(equalTo: nicknameDuplicateButton.heightAnchor),
            
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
            
            cancelAccountButton.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 50.0),
            cancelAccountButton.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            cancelAccountButton.trailingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            cancelAccountButton.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    func configureNicknameDuplicateButton(_ isEnabled: Bool) {
        nicknameDuplicateButton.isEnabled = isEnabled
        nicknameDuplicateButton.backgroundColor = isEnabled ? UIColor(named: "SubTitleColor") : .lightGray
        nicknameDuplicateButton.setTitleColor(isEnabled ? .black : .white, for: .normal)
    }
    
    func configureNicknameUpdateButton(_ isEnabled: Bool) {
        nicknameUpdateButton.isEnabled = isEnabled
        nicknameUpdateButton.backgroundColor = isEnabled ? UIColor(named: "TitleColor") : .lightGray
    }
}
