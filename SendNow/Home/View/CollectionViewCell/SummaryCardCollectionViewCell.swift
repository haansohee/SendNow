//
//  SummaryCardCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 11/23/25.
//

import UIKit

final class SummaryCardCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .titleColor
        imageView.image = UIImage(systemName: "envelope.fill")
        return imageView
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .customFont(.pretendardLight, size: 12.0)
        label.text = "보낼 금액"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .customFont(.pretendardBold, size: 15.0)
        label.text = "0 ₩"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        addSubviews()
        setLayoutConstraintsSummaryCardCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SummaryCardCollectionViewCell {
    private func addSubviews() {
        [
            imageView,
            subTitleLabel,
            titleLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraintsSummaryCardCollectionViewCell() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            imageView.heightAnchor.constraint(equalToConstant: 50.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            subTitleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            subTitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.0),
            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            titleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: subTitleLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: subTitleLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
    
    func configureSummaryCardCollectionViewCell(_ summaryInformation: SummaryInformation) {
        imageView.image = summaryInformation.image
        subTitleLabel.text = summaryInformation.subTitle
        titleLabel.text = summaryInformation.amount
    }
}
