//
//  FriendListCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 8/23/24.
//

import UIKit

final class FriendListCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let friendNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "바로보내 친구가 존재하지 않아요. 🥲 \n 친구를 초대하여 바로보내를 같이 사용해 보세요!"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .customFont(.pretendardSemiBold, size: 15.0)
        return label
    }()
    
    private let deleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("친구 삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .customFont(.pretendardBold, size: 12.0)
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        configureFriendListCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendListCollectionViewCell {
    private func addSubviews() {
        [
            deleteButton,
            friendNameLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            deleteButton.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 35.0),
            deleteButton.widthAnchor.constraint(equalToConstant: 60.0),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            
            friendNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            friendNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            friendNameLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12.0),
            friendNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
        ])
    }
    
    private func configureFriendListCollectionViewCell( ) {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 12.0
        contentView.backgroundColor = .systemBackground
    }
    
    func setFriendListCollectionViewCell(_ nickname: String) {
        friendNameLabel.text = nickname
        deleteButton.isHidden = false
    }
}
