//
//  Reactive+.swift
//  SendNow
//
//  Created by 한소희 on 4/16/24.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: InvitedGroupCollectionViewCell {
    var didTapSelectedButton: ControlEvent<Void> { base.selectedButton.rx.tap }
}

extension Reactive where Base: FriendRequestListCollectionViewCell {
    var didTapRequestCancelButton: ControlEvent<Void> { base.requestCancelButton.rx.tap }
    var didTapRequestAcceptButton: ControlEvent<Void> { base.requesetAcceptButton.rx.tap }
}

extension Reactive where Base: IndividualRemmitDetailCollectionViewCell {
    var didTapKakaoPayUrlButton: ControlEvent<Void> { base.receiverKakaoPayButton.rx.tap }
    var didTapCopyButton: ControlEvent<Void> { base.accountNumberCopyButton.rx.tap }
}
