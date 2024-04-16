//
//  InvitedGroupCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import UIKit
import RxSwift

final class InvitedGroupCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private(set) var disposeBag = DisposeBag()
    
    private let friendNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "한땡땡"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let selectedButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        return button
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        configureInvitedGroupCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InvitedGroupCollectionViewCell {
    private func addSubviews() {
        [
            friendNicknameLabel,
            selectedButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            friendNicknameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            friendNicknameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            friendNicknameLabel.trailingAnchor.constraint(equalTo: selectedButton.leadingAnchor, constant: -8.0),
            friendNicknameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            
            selectedButton.centerYAnchor.constraint(equalTo: friendNicknameLabel.centerYAnchor),
            selectedButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            selectedButton.widthAnchor.constraint(equalToConstant: 50.0),
            selectedButton.heightAnchor.constraint(equalTo: selectedButton.widthAnchor)
        ])
    }
    
    private func configureInvitedGroupCollectionViewCell( ) {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 0.3
    }
}
