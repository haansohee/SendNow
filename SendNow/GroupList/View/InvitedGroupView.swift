//
//  InvitedGroupCollectionView.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import UIKit

final class InvitedGroupView: UIView {
    let invitedButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("초대하기", for: .normal)
        button.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        return button
    }()
    
    private let unusedFriendButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("앱을 사용하지 않는 친구와 사용하고 싶은가요? >", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13.0, weight: .bold)
        return button
    }()
    
    let invitedGroupCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private let selectRemainderUserLabel: UILabel = {
        let label = UILabel()
        label.text = "정산 금액이 나누어 떨어지지 않을 경우,\n나머지 금액을 지불할 친구를 선택해 주세요.\n나머지 금액을 지불할 친구는 나중에도 변경이 가능해요."
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let remainderUserCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
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

extension InvitedGroupView {
    private func addSubviews() {
        [
            unusedFriendButton,
            invitedGroupCollectionView,
            selectRemainderUserLabel,
            remainderUserCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            invitedGroupCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            invitedGroupCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5.0),
            invitedGroupCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            invitedGroupCollectionView.heightAnchor.constraint(equalToConstant: 250.0),
            
            selectRemainderUserLabel.topAnchor.constraint(equalTo: invitedGroupCollectionView.bottomAnchor, constant: 12.0),
            selectRemainderUserLabel.leadingAnchor.constraint(equalTo: invitedGroupCollectionView.leadingAnchor),
            selectRemainderUserLabel.trailingAnchor.constraint(equalTo: invitedGroupCollectionView.trailingAnchor),
            
            remainderUserCollectionView.topAnchor.constraint(equalTo: selectRemainderUserLabel.bottomAnchor),
            remainderUserCollectionView.leadingAnchor.constraint(equalTo: invitedGroupCollectionView.leadingAnchor),
            remainderUserCollectionView.trailingAnchor.constraint(equalTo: invitedGroupCollectionView.trailingAnchor),
            remainderUserCollectionView.heightAnchor.constraint(equalToConstant: 250.0),
            
            unusedFriendButton.topAnchor.constraint(equalTo: remainderUserCollectionView.bottomAnchor, constant: 12.0),
            unusedFriendButton.leadingAnchor.constraint(equalTo: invitedGroupCollectionView.leadingAnchor),
            unusedFriendButton.trailingAnchor.constraint(equalTo: invitedGroupCollectionView.trailingAnchor),
            unusedFriendButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5.0),
            unusedFriendButton.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }
}
