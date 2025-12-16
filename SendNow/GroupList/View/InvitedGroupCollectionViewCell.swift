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
        label.font = .customFont(.pretendardRegular, size: 15.0)
        return label
    }()
    
    let selectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .titleColor
        imageView.tag = 0
        return imageView
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
            selectedImage.image = self.isSelected ? image : emptyImage
        }
    }
}

extension InvitedGroupCollectionViewCell {
    private func addSubviews() {
        [
            friendNicknameLabel,
            selectedImage
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            friendNicknameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            friendNicknameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 18.0),
            friendNicknameLabel.trailingAnchor.constraint(equalTo: selectedImage.leadingAnchor, constant: -8.0),
            friendNicknameLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8.0),
            
            selectedImage.centerYAnchor.constraint(equalTo: friendNicknameLabel.centerYAnchor),
            selectedImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -18.0),
            selectedImage.widthAnchor.constraint(equalToConstant: 20.0),
            selectedImage.heightAnchor.constraint(equalTo: selectedImage.widthAnchor)
        ])
    }
    
    private func configureInvitedGroupCollectionViewCell() {
        contentView.layer.masksToBounds = false
        contentView.layer.cornerRadius = 12.0
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.backgroundColor = .systemBackground
    }
    
    func configureCollectionViewCellAttributes(isEmpty: Bool, nickname: String) {
        friendNicknameLabel.text = isEmpty ? "초대할 수 있는 친구가 없어요." : nickname
        selectedImage.isHidden = isEmpty
    }
    
    func configureCell(nickname: String) {
        friendNicknameLabel.text = nickname
        selectedImage.isHidden = false
    }
}
