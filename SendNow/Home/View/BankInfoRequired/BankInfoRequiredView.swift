//
//  BankInfoRequiredView.swift
//  SendNow
//
//  Created by 한소희 on 2/24/25.
//

import UIKit

final class BankInfoRequiredView: UIView {
    let dismissButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    let dismissForeverButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다시보지않기", for: .normal)
        button.titleLabel?.font = .customFont(.pretendardSemiBold, size: 12.0)
        button.tintColor = .white
        button.backgroundColor = .systemGray4
        button.layer.cornerRadius = 12.0
        return button
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "친구에게 송금받을 카카오페이를 등록해 보세요! 간편한 정산 송금을 할 수 있어요. 😁"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .customFont(.pretendardSemiBold, size: 15.0)
        return label
    }()
    
    private let kakaoPayURLInputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "💡 카카오페이 송금 링크 등록하는 방법\n\n 카카오톡 [더보기] 탭에서 ⚙️ 버튼 옆에 있는 [QR코드 버튼] 클릭 후,\n송금코드 (￦) 버튼을 클릭 하면 카카오페이 송금 링크를 복사🔗 할 수 있어요."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .customFont(.pretendardLight, size: 15.0)
        return label
    }()
    
    let kakaoPayUrlUploadTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .none
        textField.font = .customFont(.pretendardLight, size: 12.0)
        textField.placeholder = "송금 코드 링크를 입력해 주세요."
        return textField
    }()
    
    let uploadButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.titleLabel?.font = .customFont(.pretendardSemiBold, size: 12.0)
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
            dismissButton,
            dismissForeverButton,
            descriptionTitleLabel,
            kakaoPayURLInputLabel,
            kakaoPayUrlUploadTextField,
            uploadButton
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            dismissButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            dismissButton.heightAnchor.constraint(equalToConstant: 40.0),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor),
            
            dismissForeverButton.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            dismissForeverButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            dismissForeverButton.widthAnchor.constraint(equalToConstant: 120.0),
            dismissForeverButton.heightAnchor.constraint(equalTo: dismissButton.heightAnchor),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 40.0),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            descriptionTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            descriptionTitleLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            kakaoPayURLInputLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 24.0),
            kakaoPayURLInputLabel.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            kakaoPayURLInputLabel.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            kakaoPayURLInputLabel.heightAnchor.constraint(equalToConstant: 160.0),
            
            kakaoPayUrlUploadTextField.topAnchor.constraint(equalTo: kakaoPayURLInputLabel.bottomAnchor, constant: 8.0),
            kakaoPayUrlUploadTextField.leadingAnchor.constraint(equalTo: descriptionTitleLabel.leadingAnchor),
            kakaoPayUrlUploadTextField.trailingAnchor.constraint(equalTo: descriptionTitleLabel.trailingAnchor),
            kakaoPayUrlUploadTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            uploadButton.widthAnchor.constraint(equalToConstant: 120.0),
            uploadButton.heightAnchor.constraint(equalToConstant: 40.0),
            uploadButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0)
        ])
    }
}
