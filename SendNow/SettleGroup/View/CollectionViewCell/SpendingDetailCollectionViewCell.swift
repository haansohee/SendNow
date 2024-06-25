//
//  SpendingDetailCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

final class SpendingDetailCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private let spendingClassficationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 15.0, weight: .bold)
        return label
    }()
    
    private let detailContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14.0, weight: .light)
        return label
    }()
    
    private let paidNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.textColor = .label
        label.sizeToFit()
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private let paidByLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "paid by"
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "원"
        label.textAlignment = .right
        label.textColor = UIColor(named: "TitleColor")
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubivews()
        setLayoutConstraints()
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpendingDetailCollectionViewCell {
    private func addSubivews() {
        [
            spendingClassficationNameLabel,
            detailContentLabel,
            paidNameLabel,
            paidByLabel,
            expenseLabel,
            dateLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            spendingClassficationNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            spendingClassficationNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12.0),
            spendingClassficationNameLabel.widthAnchor.constraint(equalToConstant: 50.0),
            spendingClassficationNameLabel.heightAnchor.constraint(equalToConstant: 30.0),
            
            detailContentLabel.centerYAnchor.constraint(equalTo: spendingClassficationNameLabel.centerYAnchor),
            detailContentLabel.leadingAnchor.constraint(equalTo: spendingClassficationNameLabel.trailingAnchor, constant: 5.0),
            detailContentLabel.heightAnchor.constraint(equalTo: spendingClassficationNameLabel.heightAnchor),
            
            paidByLabel.topAnchor.constraint(equalTo: spendingClassficationNameLabel.bottomAnchor),
            paidByLabel.leadingAnchor.constraint(equalTo: spendingClassficationNameLabel.leadingAnchor),
            paidByLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            paidByLabel.widthAnchor.constraint(equalToConstant: 50.0),
            
            paidNameLabel.topAnchor.constraint(equalTo: paidByLabel.topAnchor),
            paidNameLabel.leadingAnchor.constraint(equalTo: paidByLabel.trailingAnchor),
            paidNameLabel.bottomAnchor.constraint(equalTo: paidByLabel.bottomAnchor),
            
            expenseLabel.topAnchor.constraint(equalTo: spendingClassficationNameLabel.topAnchor),
            expenseLabel.leadingAnchor.constraint(equalTo: detailContentLabel.trailingAnchor),
            expenseLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12.0),
            expenseLabel.heightAnchor.constraint(equalTo: spendingClassficationNameLabel.heightAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: paidByLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: expenseLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: paidByLabel.bottomAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 100.0),
        ])
    }
    
    private func configureCell() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
    
    func setSpendingDetailCollectionViewCellLabel(groupExpenseInfo: ExpenseInformations) {
        spendingClassficationNameLabel.text = groupExpenseInfo.expenseClassfication
        detailContentLabel.text = groupExpenseInfo.expenseDetails
        paidNameLabel.text = groupExpenseInfo.paidBy
        expenseLabel.text = "\(groupExpenseInfo.expenseAmount)원"
        dateLabel.text = groupExpenseInfo.expenseDate
    }
}
