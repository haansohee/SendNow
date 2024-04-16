//
//  GroupListCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 4/15/24.
//

import UIKit

final class GroupListCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그룹이름 테스트"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2024년 4월 16일"
        label.textAlignment = .right
        label.textColor = .label
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    private let invitedFriendsNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "한담곰, 쭌담곰, 아기감자, 아기고구마"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        configureGroupListCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupListCollectionViewCell {
    private func addSubviews() {
        [
            groupNameLabel,
            creationDateLabel,
            invitedFriendsNameLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            groupNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5.0),
            groupNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            groupNameLabel.trailingAnchor.constraint(equalTo: creationDateLabel.leadingAnchor, constant: 5.0),
            groupNameLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            creationDateLabel.centerYAnchor.constraint(equalTo: groupNameLabel.centerYAnchor),
            creationDateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            creationDateLabel.heightAnchor.constraint(equalToConstant: 60.0),
            creationDateLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            invitedFriendsNameLabel.topAnchor.constraint(equalTo: groupNameLabel.bottomAnchor),
            invitedFriendsNameLabel.leadingAnchor.constraint(equalTo: groupNameLabel.leadingAnchor),
            invitedFriendsNameLabel.trailingAnchor.constraint(equalTo: creationDateLabel.trailingAnchor),
            invitedFriendsNameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5.0)
        ])
    }
    
    private func configureGroupListCollectionViewCell( ) {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 0.3
    }
}
