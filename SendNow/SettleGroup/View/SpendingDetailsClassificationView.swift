//
//  SpendingDetailsClassificationView.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

final class SpendingDetailsClassificationView: UIView {
    let switchTag: Int = 0
    
    let classificationImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemGray3
        return image
    }()
    
    let classificationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemGray3
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayoutConstraints()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpendingDetailsClassificationView {
    private func addSubviews() {
        [
            classificationImage,
            classificationLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            classificationImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            classificationImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            classificationImage.heightAnchor.constraint(equalToConstant: 24.0),
            classificationImage.widthAnchor.constraint(equalToConstant: 24.0),
            
            classificationLabel.topAnchor.constraint(equalTo: classificationImage.bottomAnchor),
            classificationLabel.centerXAnchor.constraint(equalTo: classificationImage.centerXAnchor),
            classificationLabel.widthAnchor.constraint(equalToConstant: 24.0),
            classificationLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
