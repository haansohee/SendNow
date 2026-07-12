//
//  BaseUIViewController.swift
//  SendNow
//
//  Created by 한소희 on 6/29/25.
//

import Foundation
import UIKit

class BaseUIViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarAppearance()
    }
}

extension BaseUIViewController {
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.standardAppearance = appearance
    }
}
