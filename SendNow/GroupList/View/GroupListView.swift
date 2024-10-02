//
//  GroupListView.swift
//  SendNow
//
//  Created by 한소희 on 8/26/24.
//

import UIKit

final class GroupListView: UIView {
    let groupAddButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .light)
        button.setImage(UIImage(systemName: "plus.app", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    let groupListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupListCollectionViewCell.self, forCellWithReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
}
