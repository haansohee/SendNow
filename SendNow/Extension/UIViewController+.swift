//
//  UIViewController.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification, _ view: UIScrollView) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardFrame.size.height), right: 0.0)
        view.contentInset = contentInset
        view.scrollIndicatorInsets = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification, _ view: UIScrollView) {
        let contentInset = UIEdgeInsets.zero
        view.contentInset = contentInset
        view.scrollIndicatorInsets = contentInset
    }
}
