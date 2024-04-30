//
//  HomeView.swift
//  SendNow
//
//  Created by 한소희 on 4/9/24.
//

import UIKit

final class HomeView: UIView {
    let notificationButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    let friendAddButton: AnimationButton = {
        let button = AnimationButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
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
        label.text = "테스트 닉네임"
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15.0, weight: .light)
        label.text = "님 안녕하세요! 😀"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let memberInfoEditButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("회원정보 수정 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .thin)
        return button
    }()
    
    let signoutButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("로그아웃 >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12.0, weight: .thin)
        return button
    }()
    
    private let groupListLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 21.0, weight: .bold)
        label.text = "그룹"
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let invitedGroupButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("정산 그룹 만들기", for: .normal)
        button.setTitleColor(UIColor(named: "TitleColor"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .light)
        return button
    }()
    
    let groupListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GroupListCollectionViewCell.self, forCellWithReuseIdentifier: GroupListCollectionViewCell.reuseIdentifier)
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

extension HomeView {
    private func addSubviews() {
        [
            memberContainerView,
            groupListLabel,
            invitedGroupButton,
            groupListCollectionView
        ].forEach { self.addSubview($0) }
        [
            memberNicknameLabel,
            welcomeLabel,
            memberInfoEditButton,
            signoutButton
        ].forEach { memberContainerView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            memberContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            memberContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            memberContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            memberContainerView.heightAnchor.constraint(equalToConstant: 140.0),
            
            memberNicknameLabel.centerYAnchor.constraint(equalTo: memberContainerView.centerYAnchor),
            memberNicknameLabel.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor, constant: 8.0),
            memberNicknameLabel.widthAnchor.constraint(equalToConstant: 160.0),
            
            welcomeLabel.centerYAnchor.constraint(equalTo: memberNicknameLabel.centerYAnchor),
            welcomeLabel.leadingAnchor.constraint(equalTo: memberNicknameLabel.trailingAnchor, constant: 5.0),
            welcomeLabel.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor, constant: -8.0),
            welcomeLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            signoutButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor),
            signoutButton.trailingAnchor.constraint(equalTo: welcomeLabel.trailingAnchor),
            signoutButton.widthAnchor.constraint(equalToConstant: 80),
            signoutButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            memberInfoEditButton.topAnchor.constraint(equalTo: signoutButton.topAnchor),
            memberInfoEditButton.trailingAnchor.constraint(equalTo: signoutButton.leadingAnchor),
            memberInfoEditButton.widthAnchor.constraint(equalToConstant: 100),
            memberInfoEditButton.heightAnchor.constraint(equalTo:signoutButton.heightAnchor),
            
            
            
            groupListLabel.topAnchor.constraint(equalTo: memberContainerView.bottomAnchor, constant: 12.0),
            groupListLabel.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor),
            groupListLabel.heightAnchor.constraint(equalToConstant: 50.0),
            groupListLabel.widthAnchor.constraint(equalToConstant: 60.0),
            
            invitedGroupButton.topAnchor.constraint(equalTo: groupListLabel.topAnchor),
            invitedGroupButton.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor),
            invitedGroupButton.heightAnchor.constraint(equalTo: groupListLabel.heightAnchor),
            invitedGroupButton.widthAnchor.constraint(equalToConstant: 120.0),
            
            groupListCollectionView.topAnchor.constraint(equalTo: groupListLabel.bottomAnchor, constant: 8.0),
            groupListCollectionView.leadingAnchor.constraint(equalTo: memberContainerView.leadingAnchor),
            groupListCollectionView.trailingAnchor.constraint(equalTo: memberContainerView.trailingAnchor),
            groupListCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8.0)
        ])
    }
}
