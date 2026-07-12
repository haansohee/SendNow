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
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        collectionView.register(AmountBalanceCollectionViewCell.self, forCellWithReuseIdentifier: AmountBalanceCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    let individualRemmitCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(IndividualRemmitDetailCollectionViewCell.self, forCellWithReuseIdentifier: IndividualRemmitDetailCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private let remittaceCheckDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.text = "✅ 송금 여부를 까먹지 않도록 체크 해 보세요."
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let completedRemittanceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CompletedRemittanceCollectionViewCell.self, forCellWithReuseIdentifier: CompletedRemittanceCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IndividualRemmitDetailView {
    private func addSubviews() {
        [
            amountBalanceCollectionView,
            individualRemmitCollectionView,
            remittaceCheckDescriptionLabel,
            completedRemittanceCollectionView
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            amountBalanceCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            amountBalanceCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            amountBalanceCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            
            individualRemmitCollectionView.topAnchor.constraint(equalTo: amountBalanceCollectionView.bottomAnchor),
            individualRemmitCollectionView.leadingAnchor.constraint(equalTo: amountBalanceCollectionView.leadingAnchor),
            individualRemmitCollectionView.trailingAnchor.constraint(equalTo: amountBalanceCollectionView.trailingAnchor),
            
            remittaceCheckDescriptionLabel.topAnchor.constraint(equalTo: individualRemmitCollectionView.bottomAnchor, constant: 2.0),
            remittaceCheckDescriptionLabel.leadingAnchor.constraint(equalTo: amountBalanceCollectionView.leadingAnchor),
            remittaceCheckDescriptionLabel.trailingAnchor.constraint(equalTo: amountBalanceCollectionView.trailingAnchor),
            remittaceCheckDescriptionLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            completedRemittanceCollectionView.topAnchor.constraint(equalTo: remittaceCheckDescriptionLabel.bottomAnchor, constant: 2.0),
            completedRemittanceCollectionView.leadingAnchor.constraint(equalTo: amountBalanceCollectionView.leadingAnchor),
            completedRemittanceCollectionView.trailingAnchor.constraint(equalTo: amountBalanceCollectionView.trailingAnchor),
            completedRemittanceCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            completedRemittanceCollectionView.heightAnchor.constraint(equalToConstant: 160.0),
        ])
    }
    
    func setAmountBalanceCollectionViewHeight(_ balanceInformationCount: Double) {
        let height = balanceInformationCount * 50.0
        amountBalanceCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
