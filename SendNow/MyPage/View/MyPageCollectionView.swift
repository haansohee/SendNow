//
//  MyPageCollectionView.swift
//  SendNow
//
//  Created by 한소희 on 2/27/25.
//

import UIKit

final class MyPageCollectionView: UICollectionView {
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        return layout
    }()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: self.collectionViewFlowLayout)
        configureMyPageCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageCollectionView {
    // MARK: Configure
    private func configureMyPageCollectionView() {
        self.register(MyPageCollectionViewCell.self, forCellWithReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier)
        self.backgroundColor = .secondarySystemBackground
    }
}
