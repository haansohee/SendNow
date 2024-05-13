//
//  FriendRequestListCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import UIKit
import RxSwift

final class FriendRequestListCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private(set) var disposeBag = DisposeBag()
    
    let friendNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0)
        label.text = "친구 요청이 없어요."
        return label
    }()
    
    let requestCancelButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("요청 취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10.0
        button.isHidden = true
        return button
    }()
    
    let requesetAcceptButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("요청 수락", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.backgroundColor = UIColor(named: "TitleColor")
        button.layer.cornerRadius = 10.0
        button.isHidden = true
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendRequestListCollectionViewCell {
    private func addSubviews() {
        [
            requestCancelButton,
            requesetAcceptButton,
            friendNicknameLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            requestCancelButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            requestCancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14.0),
            requestCancelButton.heightAnchor.constraint(equalToConstant: 35.0),
            requestCancelButton.widthAnchor.constraint(equalToConstant: 60.0),
            
            requesetAcceptButton.centerYAnchor.constraint(equalTo: requestCancelButton.centerYAnchor),
            requesetAcceptButton.trailingAnchor.constraint(equalTo: requestCancelButton.leadingAnchor, constant: -8.0),
            requesetAcceptButton.heightAnchor.constraint(equalTo: requestCancelButton.heightAnchor),
            requesetAcceptButton.widthAnchor.constraint(equalTo: requestCancelButton.widthAnchor),
            
            friendNicknameLabel.centerYAnchor.constraint(equalTo: requesetAcceptButton.centerYAnchor),
            friendNicknameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 14.0),
            friendNicknameLabel.trailingAnchor.constraint(equalTo: requesetAcceptButton.leadingAnchor, constant: -24.0),
            friendNicknameLabel.heightAnchor.constraint(equalTo: requestCancelButton.heightAnchor)
        ])
    }
}
