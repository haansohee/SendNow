//
//  RequestFriendView.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import UIKit

final class FriendRequestView: UIView {
    let requestListButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    private let requestFriendLabel: SignupDescriptionLabel = {
        let label = SignupDescriptionLabel()
        label.text = "친구의 검색 ID를 입력하세요."
        return label
    }()
    
    let friendIdTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "FRIEND SEARCH ID"
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 12.0, weight: .light)
        textField.keyboardType = .asciiCapable
        return textField
    }()
    
    let searchButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .medium)
        button.layer.cornerRadius = 3.0
        return button
    }()
    
    let searchResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "검색 결과 🔍"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    let searchResultFriendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0)
        label.text = ""
        return label
    }()
    
    let friendRequestButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        button.layer.cornerRadius = 3.0
        button.isHidden = true
        return button
    }()
    
    private let resultStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemGray5
        return stackView
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

extension FriendRequestView {
    private func addSubviews() {
        [
            requestFriendLabel,
            friendIdTextField,
            searchButton,
            searchResultLabel,
            resultStackView
        ].forEach { self.addSubview($0) }
        [
            searchResultFriendLabel,
            friendRequestButton
        ].forEach { resultStackView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            requestFriendLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 66.0),
            requestFriendLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 36.0),
            requestFriendLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -36.0),
            requestFriendLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            friendIdTextField.topAnchor.constraint(equalTo: requestFriendLabel.bottomAnchor, constant: 12.0),
            friendIdTextField.leadingAnchor.constraint(equalTo: requestFriendLabel.leadingAnchor),
            friendIdTextField.trailingAnchor.constraint(equalTo: requestFriendLabel.trailingAnchor),
            friendIdTextField.heightAnchor.constraint(equalToConstant: 35.0),
            
            searchButton.topAnchor.constraint(equalTo: friendIdTextField.bottomAnchor, constant: 8.0),
            searchButton.centerXAnchor.constraint(equalTo: friendIdTextField.centerXAnchor),
            searchButton.heightAnchor.constraint(equalTo: friendIdTextField.heightAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 70.0),
            
            searchResultLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 44.0),
            searchResultLabel.leadingAnchor.constraint(equalTo: requestFriendLabel.leadingAnchor),
            searchResultLabel.trailingAnchor.constraint(equalTo: requestFriendLabel.trailingAnchor),
            searchResultLabel.heightAnchor.constraint(equalTo: requestFriendLabel.heightAnchor),
            
            resultStackView.topAnchor.constraint(equalTo: searchResultLabel.bottomAnchor, constant: 8.0),
            resultStackView.leadingAnchor.constraint(equalTo: requestFriendLabel.leadingAnchor),
            resultStackView.trailingAnchor.constraint(equalTo: requestFriendLabel.trailingAnchor),
            resultStackView.heightAnchor.constraint(equalToConstant: 50.0),
            
            friendRequestButton.centerYAnchor.constraint(equalTo: resultStackView.centerYAnchor),
            friendRequestButton.trailingAnchor.constraint(equalTo: resultStackView.trailingAnchor, constant: -12.0),
            friendRequestButton.heightAnchor.constraint(equalToConstant: 50.0),
            friendRequestButton.widthAnchor.constraint(equalTo: friendRequestButton.heightAnchor),
            
            searchResultFriendLabel.centerYAnchor.constraint(equalTo: friendRequestButton.centerYAnchor),
            searchResultFriendLabel.leadingAnchor.constraint(equalTo: resultStackView.leadingAnchor, constant: 12.0),
            searchResultFriendLabel.trailingAnchor.constraint(equalTo: friendRequestButton.leadingAnchor, constant: -12.0),
            searchResultFriendLabel.heightAnchor.constraint(equalTo: friendRequestButton.heightAnchor)
        ])
    }
}
