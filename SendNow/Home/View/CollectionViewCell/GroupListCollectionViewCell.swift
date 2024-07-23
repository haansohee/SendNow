//
//  GroupListCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 4/15/24.
//

import UIKit
import RxSwift

final class GroupListCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private(set) var disposeBag = DisposeBag()
    
    private let groupNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "정산 모임이 아직 없어요. 🥲"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.textColor = .label
        label.font = .systemFont(ofSize: 11.0)
        return label
    }()
    
    private let invitedFriendsNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "친구를 초대해 정산 모임을 만들어 보세요!"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
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
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
    
    func setGroupListCollectionViewCellLabel(_ groupList: GroupListDomain) {
        let friendsName = groupList.groupFriends.joined(separator: ", ")
        groupNameLabel.text = groupList.groupName
        creationDateLabel.text = groupList.createdDate
        invitedFriendsNameLabel.text = friendsName
    }
}
