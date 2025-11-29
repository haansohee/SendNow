//
//  Collection+Safe.swift
//  SendNow
//
//  Created by 한소희 on 11/29/25.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil 
    }
}
