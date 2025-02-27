//
//  MyPageCollecionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 2/27/25.
//

import UIKit

final class MyPageCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubivews()
        setLayoutConstraint()
        configureMyPageCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageCollectionViewCell {
    private func addSubivews() {
        contentView.addSubview(titleLabel)
    }
    
    private func setLayoutConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -12.0),
        ])
    }
    
    private func configureMyPageCollectionViewCell() {
        self.layer.cornerRadius = 12.0
        self.backgroundColor = .systemBackground
    }
    
    func configureTitleLabel(_ text: String) {
        titleLabel.text = text
    }
}
