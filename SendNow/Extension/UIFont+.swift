//
//  UIFont+.swift
//  SendNow
//
//  Created by 한소희 on 12/16/25.
//

import UIKit

extension UIFont {
    static func customFont(_ font: FontName, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: font.fallbackWeight)
    }
}
