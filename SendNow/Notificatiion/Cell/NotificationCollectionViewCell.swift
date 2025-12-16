//
//  NotificationView.swift
//  SendNow
//
//  Created by 한소희 on 9/2/24.
//

import UIKit
import RxSwift

final class NotificationCollectionViewCell: UICollectionViewCell, ReuseIdentifierProtocol { 
    var disposeBag = DisposeBag()
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 20.0)
    private let notificationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        imageView.isHidden = true
        return imageView
    }()
    
    private let notificationBodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "알림이 아직 없어요. 😲"
        label.textAlignment = .left
        label.textColor = .label
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        configureNotificationCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCollectionViewCell {
    private func addSubviews() {
        [
            notificationImage,
            notificationBodyLabel
        ].forEach { contentView.addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            notificationImage.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            notificationImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            notificationImage.widthAnchor.constraint(equalToConstant: 40.0),
            notificationImage.heightAnchor.constraint(equalTo: notificationImage.widthAnchor),
            
            notificationBodyLabel.topAnchor.constraint(equalTo: notificationImage.topAnchor),
            notificationBodyLabel.leadingAnchor.constraint(equalTo: notificationImage.trailingAnchor, constant: 5.0),
            notificationBodyLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            notificationBodyLabel.bottomAnchor.constraint(equalTo: notificationImage.bottomAnchor)
        ])
    }
    
    private func configureNotificationCollectionViewCell() {
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 24.0
        contentView.backgroundColor = .systemBackground
    }
    
    func setReadNotificationCollectionViewCell(notificationBody: String, isRead: Bool, subject: NotificationSubject) {
        notificationBodyLabel.text = notificationBody
        notificationImage.isHidden = false
        contentView.backgroundColor = isRead ? .systemBackground : .subTitleColor
        notificationBodyLabel.textColor = isRead ? .label : .black
        
        switch subject {
        case .friendRequest:
            notificationImage.image = UIImage(systemName: "person.fill.badge.plus", withConfiguration: imageConfig)
        case .groupInvited:
            notificationImage.image = UIImage(systemName: "rectangle.3.group.bubble.fill")
        case .remittance:
            notificationImage.image = UIImage(systemName: "wonsign.circle")
        default:
            notificationImage.image = UIImage(systemName: "exclamationmark.warninglight")
            return
        }
    }
    
    func setUnreadNotificationCollectionViewCell() {
        notificationBodyLabel.text = ""
        notificationImage.isHidden = true
    }
}
