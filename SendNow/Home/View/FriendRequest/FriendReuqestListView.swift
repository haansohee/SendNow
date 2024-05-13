//
//  FriendReuqestListView.swift
//  SendNow
//
//  Created by 한소희 on 4/30/24.
//

import UIKit

final class FriendReuqestListView: UICollectionView {
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10.0
        layout.scrollDirection = .vertical
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        translatesAutoresizingMaskIntoConstraints = false
        contentInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        backgroundColor = .systemBackground
        isPagingEnabled = false
        register(FriendRequestListCollectionViewCell.self, forCellWithReuseIdentifier: FriendRequestListCollectionViewCell.reuseIdentifier)
        register(FriendReuqestListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FriendReuqestListHeaderView.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
