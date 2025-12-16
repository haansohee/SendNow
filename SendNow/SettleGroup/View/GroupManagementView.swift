//
//  GroupManagementView.swift
//  SendNow
//
//  Created by 한소희 on 11/29/25.
//

import UIKit

final class GroupManagementView: UIView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let groupNameUpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그룹 이름 변경하기"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let groupNameUpdateSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "변경할 그룹 이름을 입력한 후 '변경하기' 버튼을 눌러 주세요."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let groupNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.textColor = .label
        textField.font = .systemFont(ofSize: 14.0)
        textField.placeholder = "그룹 이름"
        return textField
    }()
    
    let groupNameUpdateButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .titleColor
        button.layer.cornerRadius = 5.0
        button.setTitle("변경하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0)
        return button
    }()
    
    private let groupNameView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private let groupRemainderUserTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나머지 정산 금액 지불할 친구 변경하기"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let groupRemainderUserSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "나머지 정산 금액을 지불할 그룹원을 선택해 주세요.\n현재 관리자만 변경할 수 있어요."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let groupRemainderMemberListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private let groupRemainderMemberView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private let groupManagerUpdateTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그룹 관리자 변경하기"
        label.textColor = .label
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let groupManagerUpdateSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "변경할 그룹 관리자를 선택해 주세요.\n현재 관리자만 변경할 수 있어요."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let groupMemberListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(InvitedGroupCollectionViewCell.self, forCellWithReuseIdentifier: InvitedGroupCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = false
        return collectionView
    }()
    
    private let groupManagerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    private let groupDeleteSubTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그룹 관리자만 그룹을 삭제할 수 있어요.\n⚠️ 그룹 삭제 시, 삭제된 내역은 복구할 수 없습니다."
        label.textColor = .secondaryLabel
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let groupDeleteButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 5.0
        button.setTitle("그룹 삭제하기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        button.isEnabled = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraintsGroupManagementView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GroupManagementView {
    private func addSubviews() {
        [
            groupNameUpdateTitleLabel,
            groupNameUpdateSubTitleLabel,
            groupNameTextField,
            groupNameUpdateButton
        ].forEach { groupNameView.addSubview($0) }
        
        [
            groupManagerUpdateTitleLabel,
            groupManagerUpdateSubTitleLabel,
            groupMemberListCollectionView
        ].forEach { groupManagerView.addSubview($0) }

        [
            groupRemainderUserTitleLabel,
            groupRemainderUserSubTitleLabel,
            groupRemainderMemberListCollectionView
        ].forEach { groupRemainderMemberView.addSubview($0) }
        
        [
            groupNameView,
            groupManagerView,
            groupRemainderMemberView,
            groupDeleteSubTitleLabel,
            groupDeleteButton
        ].forEach { contentView.addSubview($0) }
        
        scrollView.addSubview(contentView)
        
        addSubview(scrollView)
    }
    
    private func setLayoutConstraintsGroupManagementView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            groupNameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24.0),
            groupNameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            groupNameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            groupNameView.heightAnchor.constraint(equalToConstant: 130.0),
            
            groupNameUpdateTitleLabel.topAnchor.constraint(equalTo: groupNameView.topAnchor),
            groupNameUpdateTitleLabel.leadingAnchor.constraint(equalTo: groupNameView.leadingAnchor, constant: 8.0),
            groupNameUpdateTitleLabel.trailingAnchor.constraint(equalTo: groupNameView.trailingAnchor, constant: -8.0),
            groupNameUpdateTitleLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            groupNameUpdateSubTitleLabel.topAnchor.constraint(equalTo: groupNameUpdateTitleLabel.bottomAnchor),
            groupNameUpdateSubTitleLabel.leadingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.leadingAnchor),
            groupNameUpdateSubTitleLabel.trailingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.trailingAnchor),
            groupNameUpdateSubTitleLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            groupNameTextField.bottomAnchor.constraint(equalTo: groupNameView.bottomAnchor, constant: -8.0),
            groupNameTextField.leadingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.leadingAnchor),
            groupNameTextField.trailingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.centerXAnchor, constant: -8.0),
            groupNameTextField.heightAnchor.constraint(equalToConstant: 30.0),
            
            groupNameUpdateButton.bottomAnchor.constraint(equalTo: groupNameTextField.bottomAnchor),
            groupNameUpdateButton.leadingAnchor.constraint(equalTo: groupNameTextField.trailingAnchor, constant: 15.0),
            groupNameUpdateButton.trailingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.trailingAnchor),
            groupNameUpdateButton.heightAnchor.constraint(equalTo: groupNameTextField.heightAnchor),
            
            groupRemainderMemberView.topAnchor.constraint(equalTo: groupNameView.bottomAnchor, constant: 24.0),
            groupRemainderMemberView.leadingAnchor.constraint(equalTo: groupNameView.leadingAnchor),
            groupRemainderMemberView.trailingAnchor.constraint(equalTo: groupNameView.trailingAnchor),
            groupRemainderMemberView.heightAnchor.constraint(equalToConstant: 220.0),
            
            groupRemainderUserTitleLabel.topAnchor.constraint(equalTo: groupRemainderMemberView.topAnchor),
            groupRemainderUserTitleLabel.leadingAnchor.constraint(equalTo: groupRemainderMemberView.leadingAnchor, constant: 8.0),
            groupRemainderUserTitleLabel.trailingAnchor.constraint(equalTo: groupRemainderMemberView.trailingAnchor, constant: -8.0),
            groupRemainderUserTitleLabel.heightAnchor.constraint(equalTo: groupNameUpdateTitleLabel.heightAnchor),
            
            groupRemainderUserSubTitleLabel.topAnchor.constraint(equalTo: groupRemainderUserTitleLabel.bottomAnchor),
            groupRemainderUserSubTitleLabel.leadingAnchor.constraint(equalTo: groupRemainderUserTitleLabel.leadingAnchor),
            groupRemainderUserSubTitleLabel.trailingAnchor.constraint(equalTo: groupRemainderUserTitleLabel.trailingAnchor),
            groupRemainderUserSubTitleLabel.heightAnchor.constraint(equalTo: groupNameUpdateSubTitleLabel.heightAnchor),
            
            groupRemainderMemberListCollectionView.topAnchor.constraint(equalTo: groupRemainderUserSubTitleLabel.bottomAnchor),
            groupRemainderMemberListCollectionView.leadingAnchor.constraint(equalTo: groupRemainderUserTitleLabel.leadingAnchor),
            groupRemainderMemberListCollectionView.trailingAnchor.constraint(equalTo: groupRemainderUserTitleLabel.trailingAnchor),
            groupRemainderMemberListCollectionView.heightAnchor.constraint(equalToConstant: 120.0),
            
            groupManagerView.topAnchor.constraint(equalTo: groupRemainderMemberView.bottomAnchor, constant: 24.0),
            groupManagerView.leadingAnchor.constraint(equalTo: groupNameView.leadingAnchor),
            groupManagerView.trailingAnchor.constraint(equalTo: groupNameView.trailingAnchor),
            groupManagerView.heightAnchor.constraint(equalToConstant: 220.0),
            
            groupManagerUpdateTitleLabel.topAnchor.constraint(equalTo: groupManagerView.topAnchor),
            groupManagerUpdateTitleLabel.leadingAnchor.constraint(equalTo: groupManagerView.leadingAnchor, constant: 8.0),
            groupManagerUpdateTitleLabel.trailingAnchor.constraint(equalTo: groupManagerView.trailingAnchor, constant: -8.0),
            groupManagerUpdateTitleLabel.heightAnchor.constraint(equalTo: groupNameUpdateTitleLabel.heightAnchor),
            
            groupManagerUpdateSubTitleLabel.topAnchor.constraint(equalTo: groupManagerUpdateTitleLabel.bottomAnchor),
            groupManagerUpdateSubTitleLabel.leadingAnchor.constraint(equalTo: groupManagerUpdateTitleLabel.leadingAnchor),
            groupManagerUpdateSubTitleLabel.trailingAnchor.constraint(equalTo: groupManagerUpdateTitleLabel.trailingAnchor),
            groupManagerUpdateSubTitleLabel.heightAnchor.constraint(equalTo: groupNameUpdateSubTitleLabel.heightAnchor),
            
            groupMemberListCollectionView.topAnchor.constraint(equalTo: groupManagerUpdateSubTitleLabel.bottomAnchor),
            groupMemberListCollectionView.leadingAnchor.constraint(equalTo: groupManagerUpdateTitleLabel.leadingAnchor),
            groupMemberListCollectionView.trailingAnchor.constraint(equalTo: groupManagerUpdateTitleLabel.trailingAnchor),
            groupMemberListCollectionView.heightAnchor.constraint(equalToConstant: 120.0),
            
            groupDeleteSubTitleLabel.topAnchor.constraint(equalTo: groupManagerView.bottomAnchor, constant: 24.0),
            groupDeleteSubTitleLabel.leadingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.leadingAnchor),
            groupDeleteSubTitleLabel.trailingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.trailingAnchor),
            groupDeleteSubTitleLabel.heightAnchor.constraint(equalTo: groupNameUpdateSubTitleLabel.heightAnchor),
            
            groupDeleteButton.topAnchor.constraint(equalTo: groupDeleteSubTitleLabel.bottomAnchor, constant: 8.0),
            groupDeleteButton.leadingAnchor.constraint(equalTo: groupNameUpdateTitleLabel.leadingAnchor),
            groupDeleteButton.widthAnchor.constraint(equalToConstant: 100.0),
            groupDeleteButton.heightAnchor.constraint(equalToConstant: 30.0),
            groupDeleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24.0)
            
        ])
    }
    
    func configureGroupManagementView(groupName: String, isCreatorUser: Bool) {
        groupNameTextField.placeholder = "\(groupName)"
        groupDeleteButton.isEnabled = isCreatorUser
        groupDeleteButton.backgroundColor = isCreatorUser ? .systemRed : .systemGray
    }
}
