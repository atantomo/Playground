//
//  SkeletonView.swift
//  uq-customer-app-ios
//
//  Created by Tantomo Andrew on 19.03.18.
//  Copyright © 2018年 FAST RETAILING CO., LTD. All rights reserved.
//

import UIKit

final class SkeletonView: UIView {

    private struct Constant {
        static let roundedSkeletonCornerRadius: CGFloat = 4.0
        static let defaultBackgroundColor: UIColor = UIColor.darkGray
        static let highlightedBackgroundColor: UIColor = UIColor.lightGray
    }

    private let roundedCornerTypes: [UIView.Type] = [
        UILabel.self
    ]

    private var viewParts: [(reference: UIView, skeleton: UIView)] = [(UIView, UIView)]()

    init(referenceParent: UIView, referenceParts: [UIView]) {
        super.init(frame: referenceParent.frame)

        backgroundColor = UIColor.white
        for referencePart in referenceParts {

            let skeletonPart = UIView(frame: referencePart.frame)
            skeletonPart.backgroundColor = Constant.defaultBackgroundColor

            for thisType in roundedCornerTypes {
                if type(of: referencePart) === thisType {
                    skeletonPart.layer.cornerRadius = Constant.roundedSkeletonCornerRadius
                }
            }
            addSubview(skeletonPart)
            viewParts.append((referencePart, skeletonPart))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func didMoveToSuperview() {
        blinkSkeletonParts()
    }

    func show() {
        layer.removeAllAnimations()
        alpha = 1.0
        isHidden = false
    }

    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { completed in
            if completed {
                self.alpha = 0.0
                self.isHidden = true
            }
        })
    }

    private func blinkSkeletonParts() {
        UIView.animate(withDuration: 2.0,
                       delay: 1,
                       options: [.repeat, .autoreverse, .curveEaseInOut, .allowUserInteraction],
                       animations: {
                        for viewPart in self.viewParts {
                            viewPart.skeleton.backgroundColor = Constant.highlightedBackgroundColor
                        }
        })
    }
}

extension Double {
    private static let arc4randomMax = Double(UInt32.max)

    static func random0to1() -> Double {
        return Double(arc4random()) / arc4randomMax
    }
}

