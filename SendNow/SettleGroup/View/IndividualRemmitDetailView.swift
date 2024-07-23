//
//  IndividualRemmitDetailView.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import UIKit

final class IndividualRemmitDetailView: UIView {
    let amountBalanceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AmountBalanceCollectionViewCell.self, forCellWithReuseIdentifier: AmountBalanceCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        collectionView.layer.masksToBounds = false
        collectionView.layer.cornerRadius = 24.0
        return collectionView
    }()
    
    let individualRemmitCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IndividualRemmitDetailCollectionViewCell.self, forCellWithReuseIdentifier: IndividualRemmitDetailCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor(named: "BackColor")
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

extension IndividualRemmitDetailView {
    private func addSubviews() {
        [
            amountBalanceCollectionView,
            individualRemmitCollectionView
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            amountBalanceCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            amountBalanceCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            amountBalanceCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            
            individualRemmitCollectionView.topAnchor.constraint(equalTo: amountBalanceCollectionView.bottomAnchor, constant: 12.0),
            individualRemmitCollectionView.leadingAnchor.constraint(equalTo: amountBalanceCollectionView.leadingAnchor),
            individualRemmitCollectionView.trailingAnchor.constraint(equalTo: amountBalanceCollectionView.trailingAnchor),
            individualRemmitCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
    
    func setAmountBalanceCollectionViewHeight(_ balanceInformationCount: Double) {
        let height = balanceInformationCount * 35.0
        amountBalanceCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
