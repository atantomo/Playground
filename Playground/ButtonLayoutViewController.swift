//
//  ButtonLayoutViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

final class ButtonLayoutViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var permissionButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!

    @IBOutlet weak var buttonGroupContainer: UIView!
    @IBOutlet weak var rightButtonsContainerHideConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        completeButton.setTitle("lalalalala", for: UIControlState.normal)
        completeButton.isHidden = true
        permissionButton.isHidden = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func skipButtonTapped(_ sender: UIButton) {
//        closeMe()
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
//        moveToNextStep()
        rightButtonsContainerHideConstraint.priority = UILayoutPriority.defaultHigh

        completeButton.isHidden = false
        permissionButton.isHidden = false
        UIView.animate(withDuration: 2) { [weak self] in
            self?.buttonGroupContainer.layoutIfNeeded()
        }
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
//        closeMe()
    }

    @IBAction func pemissionButtonTapped(_ sender: UIButton) {
        let completionHandler: ((Bool) -> Void) = { [weak self] _ in
//            self?.closeMe()
        }
    }

//    private func syncButtons(step: OnboardingStepModel, animated: Bool) {
//        if step.shouldShowPermissionButton && viewModel.isPermissionGranted {
//            //            permissionButtonContainerHideConstraint.priority = UILayoutPriority.defaultLow
//            rightButtonsContainerHideConstraint.priority = UILayoutPriority.defaultHigh
//        } else {
//            //            permissionButtonContainerHideConstraint.priority = UILayoutPriority.defaultHigh
//            rightButtonsContainerHideConstraint.priority = UILayoutPriority.defaultLow
//        }
//        buttonGroupContainer.setNeedsLayout()
//
//        //        skipButton.isHidden = !step.shouldShowSkipButton
//        //        nextButton.isHidden = !step.shouldShowNextButton
//        //        completeButton.isHidden = !step.shouldShowCompleteButton
//        //        permissionButton.isHidden = !step.shouldShowPermissionButton
//
//        completeButton.isHidden = true
//        permissionButton.isHidden = true
//
//        //        if step.shouldShowCompleteButton {
//        //            completeButton.isHidden = false
//        //            nextButton.isHidden = true
//        //        } else {
//        //            completeButton.isHidden = true
//        //            nextButton.isHidden = false
//        //        }
//
//        //        if step.shouldShowSkipButton {
//        //            skipButton.isHidden = false
//        //        } else {
//        //            skipButton.isHidden = true
//        //        }
//
//        if animated {
//            UIView.animate(withDuration: UQ.Sizes.Duration.normal) { [weak self] in
//                self?.buttonGroupContainer.layoutIfNeeded()
//            }
//        }
//    }

}


public struct HighlightableButtonConstants {
    static public let highlightScale: CGFloat = 0.9

    static public let expandDistance: CGFloat = 4.0
    static public let animationDuration: Double = 0.5
    static public let animationDamping: CGFloat = 1
    static public let springVelocity: CGFloat = 0.5
}

open class HighlightableButton: UIButton {

    var defaultBackgroundColor: UIColor?
    var highlightedBackgroundColor: UIColor?

    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = highlightedBackgroundColor
            } else {
                backgroundColor = defaultBackgroundColor
            }
        }
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public convenience init(type buttonType: UIButtonType) {
        self.init(frame: .zero)
        commonInit()
    }

    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public func configureCornerRadius(radius: CGFloat = 4) {
        layer.cornerRadius = radius
    }

    public func configureBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    public func configureColor(defaultColor: UIColor?, highlightScale: CGFloat = HighlightableButtonConstants.highlightScale) {
        backgroundColor = defaultColor
        defaultBackgroundColor = defaultColor
        highlightedBackgroundColor = defaultColor?.scaled(scale: highlightScale)
    }

    func commonInit() {
        configureCornerRadius()
        configureColor(defaultColor: backgroundColor)
        addTarget(self, action: #selector(animateRecoil), for: UIControlEvents.touchUpInside)
        addTarget(self, action: #selector(simulatePress), for: UIControlEvents.touchDown)
        addTarget(self, action: #selector(resetTransform), for: UIControlEvents.touchDragOutside)
        addTarget(self, action: #selector(resetTransform), for: UIControlEvents.touchCancel)
    }

    @objc
    func animateRecoil() {
        let maxSide = max(bounds.width, bounds.height)
        let expandRatio = (maxSide - HighlightableButtonConstants.expandDistance) / maxSide

        transform = CGAffineTransform(scaleX: expandRatio, y: expandRatio)
        UIView.animate(withDuration: HighlightableButtonConstants.animationDuration,
                       delay: 0.1,
                       usingSpringWithDamping: HighlightableButtonConstants.animationDamping,
                       initialSpringVelocity: HighlightableButtonConstants.springVelocity,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: { () -> Void in
                        self.transform = .identity
        })
    }

    @objc
    func simulatePress() {
        let maxSide = max(bounds.width, bounds.height)
        let contractRatio = (maxSide - HighlightableButtonConstants.expandDistance) / maxSide

        transform = CGAffineTransform(scaleX: contractRatio, y: contractRatio)
    }

    @objc
    func resetTransform() {
        transform = .identity
    }
}

public extension UIColor {

    func scaled(scale: CGFloat) -> UIColor {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let scaledRed: CGFloat = red * scale
        let scaledGreen: CGFloat = green * scale
        let scaledBlue: CGFloat = blue * scale

        return UIColor(red: scaledRed, green: scaledGreen, blue: scaledBlue, alpha: alpha)
    }
}
