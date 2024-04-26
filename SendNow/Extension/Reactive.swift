//
//  Reactive.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: InvitedGroupCollectionViewCell {
    var didTapSelectedButton: ControlEvent<Void> { base.selectedButton.rx.tap }
}
