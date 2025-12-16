//
//  HomeView.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import UIKit

final class HomeView: UIView {
    private let memberContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .subTitleColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 12.0
        return view
    }()
    
    let memberNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.medium.rawValue)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontName.pretendardRegular.rawValue, size: FontSize.small.rawValue)
        label.text = "님, 안녕하세요! 👋🏼"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.large.rawValue)
        label.text = "오늘의 정산 현황이에요"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let summaryCardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SummaryCardCollectionViewCell.self, forCellWithReuseIdentifier: SummaryCardCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        collectionView.layer.cornerRadius = 12.0
        return collectionView
    }()
    
    private let friendListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: FontName.pretendardBold.rawValue, size: FontSize.large.rawValue)
        label.text = "내 친구"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let friendRequestButton: AnimationButton = {
        let button = AnimationButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.badge.plus", withConfiguration: imageConfig), for: .normal)
        button.tintColor = .titleColor
        return button
    }()
    
    let friendListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FriendListCollectionViewCell.self, forCellWithReuseIdentifier: FriendListCollectionViewCell.reuseIdentifier)
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

extension HomeView {
    private func addSubviews() {
        [
            memberNicknameLabel,
            welcomeLabel,
            summaryLabel,
            summaryCardCollectionView,
            friendListLabel,
            friendRequestButton,
            friendListCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            memberNicknameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            memberNicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            memberNicknameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            welcomeLabel.centerYAnchor.constraint(equalTo: memberNicknameLabel.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: memberNicknameLabel.trailingAnchor, constant: 8.0),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 140.0),
            welcomeLabel.heightAnchor.constraint(equalTo: memberNicknameLabel.heightAnchor),
            
            summaryLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 28.0),
            summaryLabel.leadingAnchor.constraint(equalTo: memberNicknameLabel.leadingAnchor),
            summaryLabel.widthAnchor.constraint(equalToConstant: 200.0),
            summaryLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            summaryCardCollectionView.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 5.0),
            summaryCardCollectionView.leadingAnchor.constraint(equalTo: memberNicknameLabel.leadingAnchor),
            summaryCardCollectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            summaryCardCollectionView.heightAnchor.constraint(equalToConstant: 240.0),
            
            friendListLabel.topAnchor.constraint(equalTo: summaryCardCollectionView.bottomAnchor, constant: 12.0),
            friendListLabel.leadingAnchor.constraint(equalTo: memberNicknameLabel.leadingAnchor),
            friendListLabel.heightAnchor.constraint(equalTo: summaryLabel.heightAnchor),
            friendListLabel.widthAnchor.constraint(equalToConstant: 60.0),
            
            friendRequestButton.topAnchor.constraint(equalTo: friendListLabel.topAnchor),
            friendRequestButton.trailingAnchor.constraint(equalTo: summaryCardCollectionView.trailingAnchor),
            friendRequestButton.heightAnchor.constraint(equalTo: friendListLabel.heightAnchor),
            friendRequestButton.widthAnchor.constraint(equalToConstant: 60.0),
            
            friendListCollectionView.topAnchor.constraint(equalTo: friendListLabel.bottomAnchor, constant: 8.0),
            friendListCollectionView.leadingAnchor.constraint(equalTo: summaryCardCollectionView.leadingAnchor),
            friendListCollectionView.trailingAnchor.constraint(equalTo: summaryCardCollectionView.trailingAnchor),
            friendListCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}
