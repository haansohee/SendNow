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
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
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
            invitedGroupCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            invitedGroupCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            invitedGroupCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 5.0),
            invitedGroupCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            
            unusedFriendButton.topAnchor.constraint(equalTo: invitedGroupCollectionView.bottomAnchor, constant: 5.0),
            unusedFriendButton.leadingAnchor.constraint(equalTo: invitedGroupCollectionView.leadingAnchor),
            unusedFriendButton.trailingAnchor.constraint(equalTo: invitedGroupCollectionView.trailingAnchor),
            unusedFriendButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5.0),
            unusedFriendButton.heightAnchor.constraint(equalToConstant: 80.0)
        ])
    }
}
