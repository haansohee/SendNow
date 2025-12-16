//
//  RemainderUserCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 7/20/25.
//

import UIKit

final class RemainderUserCollectionViewCell: UICollectionViewCell,ReuseIdentifierProtocol {
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont(name: FontName.pretendardRegular.rawValue, size: FontSize.small.rawValue)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(nicknameLabel)
        setLayoutConstrainst()
        configureReamidnerUserCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RemainderUserCollectionViewCell {
    private func setLayoutConstrainst() {
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 18.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            nicknameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -18.0)
        ])
    }
    
    private func configureReamidnerUserCollectionViewCell() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.backgroundColor = .systemBackground
    }
    
    func configureNicknameLabel(_ nickname: String) {
        nicknameLabel.text = nickname
    }
}
