//
//  FontCategory.swift
//  SendNow
//
//  Created by 한소희 on 12/16/25.
//

import Foundation
import UIKit

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardLight = "Pretendard-Light"
    case pretendardRegular = "Pretendard-Regular"
    
    var fallbackWeight: UIFont.Weight {
            switch self {
            case .pretendardBold:
                return .bold
            case .pretendardSemiBold:
                return .semibold
            case .pretendardLight:
                return .light
            case .pretendardRegular:
                return .regular
            }
        }
}
