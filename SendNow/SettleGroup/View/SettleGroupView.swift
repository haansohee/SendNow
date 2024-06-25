//
//  SettleGroupView.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

final class SettleGroupView: UIView {
    let spendingDetailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "BackColor")
        collectionView.isPagingEnabled = false
        collectionView.register(SpendingDetailCollectionViewCell.self, forCellWithReuseIdentifier: SpendingDetailCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    let spendingDetailAddButton: AnimationButton = {
        let button = AnimationButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30.0, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "TitleColor")
        button.layer.cornerRadius = 25.0
        return button
    }()
    
    private let myTotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "내가 낸 비용"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    let myTotalContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0원"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let groupTotalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "우리 모임의 총 비용"
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    let groupTotalContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0원"
        label.textAlignment = .right
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
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

extension SettleGroupView {
    private func addSubviews() {
        [
            spendingDetailCollectionView,
            spendingDetailAddButton,
            myTotalLabel,
            myTotalContentLabel,
            groupTotalLabel,
            groupTotalContentLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            spendingDetailAddButton.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            spendingDetailAddButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -24.0),
            spendingDetailAddButton.heightAnchor.constraint(equalToConstant: 50.0),
            spendingDetailAddButton.widthAnchor.constraint(equalTo: spendingDetailAddButton.heightAnchor),
            
            myTotalLabel.centerYAnchor.constraint(equalTo: spendingDetailAddButton.centerYAnchor),
            myTotalLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            myTotalLabel.trailingAnchor.constraint(equalTo: spendingDetailAddButton.leadingAnchor),
            myTotalLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            myTotalContentLabel.topAnchor.constraint(equalTo: myTotalLabel.bottomAnchor),
            myTotalContentLabel.leadingAnchor.constraint(equalTo: myTotalLabel.leadingAnchor),
            myTotalContentLabel.trailingAnchor.constraint(equalTo: myTotalLabel.trailingAnchor),
            myTotalContentLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
            
            groupTotalLabel.centerYAnchor.constraint(equalTo: myTotalLabel.centerYAnchor),
            groupTotalLabel.leadingAnchor.constraint(equalTo: spendingDetailAddButton.trailingAnchor),
            groupTotalLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            groupTotalLabel.heightAnchor.constraint(equalTo: myTotalLabel.heightAnchor),
            
            groupTotalContentLabel.topAnchor.constraint(equalTo: groupTotalLabel.bottomAnchor),
            groupTotalContentLabel.leadingAnchor.constraint(equalTo: groupTotalLabel.leadingAnchor),
            groupTotalContentLabel.trailingAnchor.constraint(equalTo: groupTotalLabel.trailingAnchor),
            groupTotalContentLabel.bottomAnchor.constraint(equalTo: myTotalContentLabel.bottomAnchor),
            
            spendingDetailCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            spendingDetailCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            spendingDetailCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            spendingDetailCollectionView.bottomAnchor.constraint(equalTo: myTotalLabel.topAnchor)
        ])
    }
}
