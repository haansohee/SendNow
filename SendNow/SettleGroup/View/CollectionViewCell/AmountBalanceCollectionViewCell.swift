//
//  AmountBalanceCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 5/30/24.
//

import UIKit

final class AmountBalanceCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    private let amountValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        label.layer.cornerRadius = 24.0
        label.layer.masksToBounds = false
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

extension AmountBalanceCollectionViewCell {
    private func addSubviews() {
        [
            nicknameLabel,
            amountValueLabel,
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            nicknameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 100.0),
            
            amountValueLabel.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor),
            amountValueLabel.leadingAnchor.constraint(equalTo: nicknameLabel.trailingAnchor),
            amountValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24.0),
            amountValueLabel.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    func configureCell(_ balanceInformation: SettlementBalanceDomain) {
        nicknameLabel.text = "\(balanceInformation.nickname) 님"
        guard let receiveAmount = balanceInformation.receiveAmount,
              let sendAmount = balanceInformation.sendAmount else {
            amountValueLabel.text = "0원"
            return
        }
        if receiveAmount > 0 {
            amountValueLabel.text = "\(receiveAmount)원"
            amountValueLabel.textColor = UIColor(named: "TitleColor")
        } else if sendAmount < 0 {
            amountValueLabel.text = "\(sendAmount)원"
            amountValueLabel.textColor = .systemRed
        } else {
            amountValueLabel.text = "0원"
            amountValueLabel.textColor = .label
        }
    }
}
