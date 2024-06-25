//
//  IndividualRemmitDetailCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 5/21/24.
//

import UIKit
import RxSwift

final class IndividualRemmitDetailCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private(set) var disposeBag = DisposeBag()
    
    private let senderNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "arrow.right")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    private let receiverNicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 13.0, weight: .bold)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    private let receiverAccountNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12.0, weight: .light)
        return label
    }()
    
    let accountNumberCopyButton: AnimationButton = {
        let button = AnimationButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.doc",  withConfiguration: imageConfig), for: .normal)
        button.tintColor = .secondaryLabel
        return button
    }()
    
    let receiverKakaoPayButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "kakaopay"), for: .normal)
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
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureIndividualRemmitDetailCollectionViewCell(information: SettlementDetailsDomain) {
        senderNicknameLabel.text = information.fromNickname
        receiverNicknameLabel.text = information.toNickname
        amountLabel.text = "\(information.amount)원 송금해 주세요."
        
        guard let bankName = information.bankName,
              let accountNumber = information.accountNumber,
              !bankName.isEmpty,
              !accountNumber.isEmpty else {
            receiverAccountNumberLabel.text = "\(information.toNickname) 님은 계좌를 등록하지 않았어요."
            accountNumberCopyButton.isHidden = true
            return
        }
        receiverAccountNumberLabel.text = "\(bankName) \(accountNumber)"
        accountNumberCopyButton.isHidden = false
    }
}

extension IndividualRemmitDetailCollectionViewCell {
    private func addSubviews() {
        [
            senderNicknameLabel,
            arrowImageView,
            receiverNicknameLabel,
            amountLabel,
            receiverAccountNumberLabel,
            accountNumberCopyButton,
            receiverKakaoPayButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            arrowImageView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            arrowImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 12.0),
            arrowImageView.widthAnchor.constraint(equalToConstant: 30.0),
            arrowImageView.heightAnchor.constraint(equalTo: arrowImageView.widthAnchor),
            
            senderNicknameLabel.centerYAnchor.constraint(equalTo: arrowImageView.centerYAnchor),
            senderNicknameLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -12.0),
            senderNicknameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            senderNicknameLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            receiverNicknameLabel.centerYAnchor.constraint(equalTo: arrowImageView.centerYAnchor),
            receiverNicknameLabel.leadingAnchor.constraint(equalTo: arrowImageView.trailingAnchor, constant: 12.0),
            receiverNicknameLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            receiverNicknameLabel.heightAnchor.constraint(equalTo: senderNicknameLabel.heightAnchor),
            
            amountLabel.topAnchor.constraint(equalTo: senderNicknameLabel.bottomAnchor, constant: 8.0),
            amountLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24.0),
            amountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24.0),
            amountLabel.heightAnchor.constraint(equalToConstant: 35.0),
            
            receiverKakaoPayButton.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8.0),
            receiverKakaoPayButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            receiverKakaoPayButton.widthAnchor.constraint(equalToConstant: 75.0),
            receiverKakaoPayButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            accountNumberCopyButton.centerYAnchor.constraint(equalTo: receiverKakaoPayButton.centerYAnchor),
            accountNumberCopyButton.leadingAnchor.constraint(equalTo: receiverAccountNumberLabel.trailingAnchor),
            accountNumberCopyButton.trailingAnchor.constraint(equalTo: receiverKakaoPayButton.leadingAnchor, constant: -52.0),
            accountNumberCopyButton.heightAnchor.constraint(equalToConstant: 30.0),
            
            receiverAccountNumberLabel.centerYAnchor.constraint(equalTo: accountNumberCopyButton.centerYAnchor),
            receiverAccountNumberLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            receiverAccountNumberLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    private func configureCell() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
}
