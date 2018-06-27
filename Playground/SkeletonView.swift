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

    private var viewParts: [(reference: UIView, skeleton: UIView)] = [(UIView, UIView)]()

    init(parentFrame: CGRect, roundedCornerParts: [UIView] = [], sharpCornerParts: [UIView] = []) {
        super.init(frame: parentFrame)
        translatesAutoresizingMaskIntoConstraints = false

        isUserInteractionEnabled = false
        backgroundColor = UIColor.white

        setupParts(referenceParts: roundedCornerParts, isRounded: true)
        setupParts(referenceParts: sharpCornerParts, isRounded: false)
        setupObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didMoveToSuperview() {
        guard let superview = self.superview else {
            return
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
    }

    override func layoutSubviews() {
        syncSkeletonFrames()
        super.layoutSubviews()
    }

    func show() {
        syncSkeletonFrames()
        blinkSkeletonParts()

        alpha = 1.0
        isHidden = false
    }

    func hide(animated: Bool = true) {
        let hideHandler = {
            self.stopBlinkingSkeletonParts()
            self.alpha = 0.0
            self.isHidden = true
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
            }, completion: { _ in
                hideHandler()
            })
        } else {
            hideHandler()
        }
    }

    private func setupParts(referenceParts: [UIView], isRounded: Bool) {
        for referencePart in referenceParts {

            let skeletonPart = UIView(frame: referencePart.frame)
            skeletonPart.backgroundColor = Constant.defaultBackgroundColor
            if isRounded {
                skeletonPart.layer.cornerRadius = Constant.roundedSkeletonCornerRadius
            }
            addSubview(skeletonPart)
            viewParts.append((referencePart, skeletonPart))
        }
    }

    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeAnimation),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resumeAnimation),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }

    private func blinkSkeletonParts() {
        for viewPart in self.viewParts {
            viewPart.skeleton.backgroundColor = Constant.defaultBackgroundColor
        }
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut, .allowUserInteraction],
                       animations: {
                        for viewPart in self.viewParts {
                            viewPart.skeleton.backgroundColor = Constant.highlightedBackgroundColor
                        }
        })
    }

    private func stopBlinkingSkeletonParts() {
        for viewPart in self.viewParts {
            viewPart.skeleton.layer.removeAllAnimations()
        }
    }

    private func syncSkeletonFrames() {
        print("")
        print("before")
        print(superview?.frame)


        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()

        print("")
        print("after")
        print(superview?.frame)

        for part in viewParts {
            guard let partSuperview = part.reference.superview else {
                continue
            }
            part.reference.setNeedsUpdateConstraints()
            part.reference.updateConstraintsIfNeeded()

            part.skeleton.frame = partSuperview.convert(part.reference.frame, to: superview)

            print("")
            print("converted")
            print(partSuperview.convert(part.reference.frame, to: superview))
        }
    }

    @objc
    private func removeAnimation() {
        stopBlinkingSkeletonParts()
    }

    @objc
    private func resumeAnimation() {
        blinkSkeletonParts()
    }

}
