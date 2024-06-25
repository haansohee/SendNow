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
    
    let friendNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.text = "초대할 수 있는 친구가 없어요. 🥲"
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let selectedButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = UIColor(named: "TitleColor")
        button.isHidden = true
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
    
    override var isSelected: Bool {
        didSet {
            let emptyImage = UIImage(systemName: "circle")
            let image = UIImage(systemName: "circle.fill")
            selectedButton.setImage(self.isSelected ? image : emptyImage, for: .normal)
        }
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
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
}
