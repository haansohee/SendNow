//
//  PaddingTextField.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import UIKit

final class PaddingTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
