//
//  HomeView.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import UIKit

final class HomeView: UIView {
    let settingButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20.0, weight: .bold)
        button.setImage(UIImage(systemName: "gear", withConfiguration: imageConfig), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    private let memberContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "SubTitleColor")
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 24
        return view
    }()
    
    let memberNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0)
        label.text = "님 안녕하세요! 👋🏼"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let signoutButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .thin)
        return button
    }()
    
    private let friendListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21.0, weight: .bold)
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
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    let friendListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FriendListCollectionViewCell.self, forCellWithReuseIdentifier: FriendListCollectionViewCell.reuseIdentifier)
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

extension HomeView {
    private func addSubviews() {
        [
            memberContainerView,
            friendListLabel,
            friendRequestButton,
            friendListCollectionView
        ].forEach { self.addSubview($0) }
        [
            memberNicknameLabel,
            welcomeLabel,
            signoutButton
        ].forEach { memberContainerView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            memberContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            memberContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            memberContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            memberContainerView.heightAnchor.constraint(equalToConstant: 140.0),
            
            memberNicknameLabel.topAnchor.constraint(equalTo: memberContainerView.topAnchor, constant: 36.0),
            memberNicknameLabel.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor, constant: 12.0),
            memberNicknameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            welcomeLabel.centerYAnchor.constraint(equalTo: memberNicknameLabel.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: memberNicknameLabel.trailingAnchor, constant: 8.0),
            welcomeLabel.widthAnchor.constraint(equalToConstant: 140.0),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            signoutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor),
            signoutButton.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor, constant: -12.0),
            signoutButton.widthAnchor.constraint(equalToConstant: 80),
            signoutButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            friendListLabel.topAnchor.constraint(equalTo: memberContainerView.bottomAnchor, constant: 12.0),
            friendListLabel.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor),
            friendListLabel.heightAnchor.constraint(equalToConstant: 50.0),
            friendListLabel.widthAnchor.constraint(equalToConstant: 60.0),
            
            friendRequestButton.topAnchor.constraint(equalTo: friendListLabel.topAnchor),
            friendRequestButton.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor),
            friendRequestButton.heightAnchor.constraint(equalTo: friendListLabel.heightAnchor),
            friendRequestButton.widthAnchor.constraint(equalToConstant: 60.0),
            
            friendListCollectionView.topAnchor.constraint(equalTo: friendListLabel.bottomAnchor, constant: 8.0),
            friendListCollectionView.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor),
            friendListCollectionView.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor),
            friendListCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}
