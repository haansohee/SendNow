//
//  CompletedRemittanceCollectionViewCell.swift
//  SendNow
//
//  Created by 한소희 on 10/2/24.
//

import UIKit
import RxSwift

final class CompletedRemittanceCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol {
    private(set) var disposeBag = DisposeBag()
    
    private let remittanceInformationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "송금해야 할 내역이\n아직 없어요."
        label.numberOfLines = 0
        label.font = UIFont(name: FontName.pretendardSemiBold.rawValue, size: FontSize.extraSmall.rawValue)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    private let remittanceCheckLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "완료"
        label.font = UIFont(name: FontName.pretendardRegular.rawValue, size: FontSize.small.rawValue)
        label.textColor = .label
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    let completedButton: AnimationButton = {
        let button = AnimationButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .titleColor
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
}


extension CompletedRemittanceCollectionViewCell {
    private func addSubviews() {
        [
            remittanceInformationLabel,
            remittanceCheckLabel,
            completedButton
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            completedButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -6.0),
            completedButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -6.0),
            completedButton.widthAnchor.constraint(equalToConstant: 24.0),
            completedButton.heightAnchor.constraint(equalTo: completedButton.widthAnchor),
            
            remittanceCheckLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 6.0),
            remittanceCheckLabel.trailingAnchor.constraint(equalTo: completedButton.leadingAnchor, constant: -3.0),
            remittanceCheckLabel.bottomAnchor.constraint(equalTo: completedButton.bottomAnchor),
            remittanceCheckLabel.heightAnchor.constraint(equalTo: completedButton.heightAnchor),
            
            remittanceInformationLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 6.0),
            remittanceInformationLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 6.0),
            remittanceInformationLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -6.0),
            remittanceInformationLabel.bottomAnchor.constraint(equalTo: remittanceCheckLabel.topAnchor, constant: -6.0)
        ])
    }
    
    private func configureCell() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
    
    func configureLabel(with information: CompletionRemittanceInformation) {
        remittanceInformationLabel.text = "\(information.receiverNickname)에게\n\(information.amount)원 송금하기"
        remittanceCheckLabel.isHidden = false
        completedButton.isHidden = false
        completedButton.setImage(UIImage(systemName: information.isCompletedRemittance ? "checkmark.square.fill" : "square"), for: .normal)
    }
    
    func configureEmptyCell() {
        remittanceInformationLabel.text = "송금해야 할 내역이\n아직 없어요."
        remittanceCheckLabel.isHidden = true
        completedButton.isHidden = true
    }
}
