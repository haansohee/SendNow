//
//  SettleGroupInitView.swift
//  SendNow
//
//  Created by 한소희 on 7/20/25.
//

import UIKit

final class SettleGroupInitView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "바로보내 💸"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "모임의 이름을 정해 주세요! 이름을 정해 다른 모임과 구분할 수 있어요. 😁"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "모임 이름"
        textField.backgroundColor = .secondarySystemBackground
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let remainderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label
        label.textAlignment = .center
        label.text = "정산 시 나누어 떨어지지 않는 금액을 부담할 그룹원을 선택해 주세요!"
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
        return collectionView
    }()
    
    let doneButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton: AnimationButton = {
        let button = AnimationButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
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
            titleLabel,
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
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            groupNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            groupNameLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            groupNameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            groupNameTextField.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor, constant: 12.0),
            groupNameTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 48.0),
            groupNameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -48.0),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 60.0),
            
            remainderLabel.topAnchor.constraint(equalTo: groupNameTextField.bottomAnchor, constant: 24.0),
            remainderLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            remainderLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            remainderUserCollectionView.topAnchor.constraint(equalTo: remainderLabel.bottomAnchor, constant: 12.0),
            remainderUserCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            remainderUserCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            cancelButton.topAnchor.constraint(equalTo: remainderUserCollectionView.bottomAnchor, constant: 18.0),
            cancelButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: -24.0),
            cancelButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0),
            cancelButton.heightAnchor.constraint(equalToConstant: 40.0),
            
            doneButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 24.0),
            doneButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            doneButton.heightAnchor.constraint(equalTo: cancelButton.heightAnchor)
        ])
    }
}
