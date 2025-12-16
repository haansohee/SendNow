//
//  SettleGroupInitView.swift
//  SendNow
//
//  Created by 한소희 on 7/20/25.
//

import UIKit

final class SettleGroupInitView: UIView {
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontName.pretendardSemiBold.rawValue, size: FontSize.small.rawValue)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "모임의 이름을 정해 주세요.\n이름을 정해 다른 모임과 구분할 수 있어요."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 이름"
        textField.backgroundColor = .secondarySystemBackground
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.extraSmall.rawValue)
        return textField
    }()
    
    private let remainderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: FontName.pretendardSemiBold.rawValue, size: FontSize.small.rawValue)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "정산 시 나누어 떨어지지 않는 금액을\n부담할 그룹원을 선택해 주세요.\n(나중에 변경 가능해요. 😁)"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let remainderUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RemainderUserCollectionViewCell.self, forCellWithReuseIdentifier: RemainderUserCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = false
        collectionView.allowsMultipleSelection = false 
        return collectionView
    }()
    
    let doneButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.small.rawValue)
        button.backgroundColor = .systemGray
        button.isEnabled = false
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.small.rawValue)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettleGroupInitView {
    private func addSubviews() {
        [
            groupNameLabel,
            groupNameTextField,
            remainderLabel,
            remainderUserCollectionView,
            doneButton,
            cancelButton
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            groupNameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            groupNameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 60.0),
            
            groupNameTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 12.0),
            groupNameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            groupNameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 45.0),
            
            remainderLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 24.0),
            remainderLabel.leadingAnchor.constraint(equalTo: groupNameLabel.leadingAnchor),
            remainderLabel.trailingAnchor.constraint(equalTo: groupNameLabel.trailingAnchor),
            remainderLabel.heightAnchor.constraint(equalTo: groupNameLabel.heightAnchor),
            
            remainderUserCollectionView.topAnchor.constraint(equalTo: remainderLabel.bottomAnchor, constant: 12.0),
            remainderUserCollectionView.leadingAnchor.constraint(equalTo: groupNameLabel.leadingAnchor),
            remainderUserCollectionView.trailingAnchor.constraint(equalTo: groupNameLabel.trailingAnchor),
            remainderUserCollectionView.heightAnchor.constraint(equalToConstant: 180.0),
            
            cancelButton.topAnchor.constraint(equalTo: remainderUserCollectionView.bottomAnchor, constant: 30.0),
            cancelButton.leadingAnchor.constraint(equalTo: groupNameLabel.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: groupNameLabel.centerXAnchor, constant: -24.0),
            cancelButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            doneButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: groupNameLabel.centerXAnchor, constant: 24.0),
            doneButton.trailingAnchor.constraint(equalTo: groupNameLabel.trailingAnchor),
            doneButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }
}
