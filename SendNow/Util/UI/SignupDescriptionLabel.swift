//
//  SignupDescriptionLabel.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit

final class SignupDescriptionLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.textAlignment = .center
        self.textColor = .secondaryLabel
        self.font = .customFont(.pretendardLight, size: 12.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
