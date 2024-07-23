//
//  SpendingDetailsClassficationView.swift
//  SendNow
//
//  Created by 한소희 on 5/14/24.
//

import UIKit

final class SpendingDetailsClassficationView: UIView {
    let switchTag: Int = 0
    
    let classficationImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.tintColor = .systemGray3
        return image
    }()
    
    let classficationLabel: UILabel = {
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

extension SpendingDetailsClassficationView {
    private func addSubviews() {
        [
            classficationImage,
            classficationLabel
        ].forEach { addSubview($0) }
    }
    
    private func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            classficationImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            classficationImage.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            classficationImage.heightAnchor.constraint(equalToConstant: 24.0),
            classficationImage.widthAnchor.constraint(equalToConstant: 24.0),
            
            classficationLabel.topAnchor.constraint(equalTo: classficationImage.bottomAnchor),
            classficationLabel.centerXAnchor.constraint(equalTo: classficationImage.centerXAnchor),
            classficationLabel.widthAnchor.constraint(equalToConstant: 24.0),
            classficationLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
