//
//  AnimationButton.swift
//  SendNow
//
//  Created by 한소희 on 3/25/24.
//

import Foundation
import UIKit

final class AnimationButton: UIButton {
    private enum Animation {
        typealias Element = (
            duration: TimeInterval,
            delay: TimeInterval,
            options: UIView.AnimationOptions,
            scale: CGAffineTransform,
            alpha: CGFloat
        )
        case touchDown
        case touchUp
        
        var element: Element {
            switch self {
            case .touchDown:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .init(scaleX: 1.05, y: 1.05),
                    alpha: 0.8
                )
            case .touchUp:
                return Element(
                    duration: 0,
                    delay: 0,
                    options: .curveLinear,
                    scale: .identity,
                    alpha: 1
                )
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet { self.animationWhenHighlighted() }
    }
    
    private func animationWhenHighlighted() {
        let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
        UIView.animate(
            withDuration: animationElement.duration,
            delay: animationElement.delay,
            animations: {
                self.transform = animationElement.scale
                self.alpha = animationElement.alpha
            }
        )
    }
}
