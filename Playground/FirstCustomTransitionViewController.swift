//
//  FirstCustomTransitionViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class FirstCustomTransitionViewController: UIViewController {

    @IBOutlet weak var productThumbnailView: UIView!

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class OpacityTransition: NSObject {
    let transitionDuration: TimeInterval = 0.7
    let expandGap: CGFloat = 32.0
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }
}

extension OpacityTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 4
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }

        // 5
        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
            toView.alpha = 0.0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }

//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            // 6
//            if self.presenting {
//                toView.alpha = 1.0
//            } else {
//                fromView.alpha = 0.0
//            }
//        }) { _ in
//            // 7
//            let success = !transitionContext.transitionWasCancelled
//            if !success {
//                toView.removeFromSuperview()
//            }
//            transitionContext.completeTransition(success)
//        }

        guard presenting else {
//            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//                // 6
//                if self.presenting {
//                    toView.alpha = 1.0
//                } else {
//                    fromView.alpha = 0.0
//                }
//            }) { _ in
//                // 7
//                let success = !transitionContext.transitionWasCancelled
//                if !success {
//                    toView.removeFromSuperview()
//                }
//                transitionContext.completeTransition(success)
//            }




            let fromVC = transitionContext.viewController(forKey:.from) as! SecondCustomTransitionViewController
            let toVC = transitionContext.viewController(forKey:.to) as! FirstCustomTransitionViewController

            toVC.productThumbnailView.transform = .identity
            let destinationBounds = fromVC.productImageView.bounds
            let originalBounds = toVC.productThumbnailView.bounds
            let widthDiffScale = (destinationBounds.width - expandGap * 2) / originalBounds.width

            fromVC.productDescriptionTopConstraint.constant = -fromVC.productDescriptionView.bounds.height
            fromVC.productDescriptionBottomConstraint.constant = fromVC.productDescriptionView.bounds.height

            fromVC.expandableViewTopConstraint.constant = expandGap
            fromVC.expandableViewLeadingConstraint.constant = expandGap
            fromVC.expandableViewTrailingConstraint.constant = expandGap
            fromVC.expandableViewBottomConstraint.constant = /*fromVC.productDescriptionView.bounds.height +*/ expandGap

            toVC.view.setNeedsLayout()
            toVC.view.layoutIfNeeded()

            let productImageViewCenter = fromVC.productImageView.superview!.convert(fromVC.productImageView.center, to: toVC.view)
            let centerToMove = toVC.view.convert(productImageViewCenter, to: toVC.productThumbnailView.superview)

            let originalCenter = toVC.productThumbnailView.center
            toVC.productThumbnailView.center = centerToMove

            toVC.productThumbnailView.transform = CGAffineTransform(scaleX: widthDiffScale, y: widthDiffScale)

            fromVC.view.backgroundColor = UIColor.clear
//            let anim1 = { (anim: (() -> Void)?) -> Void in
//
//                fromVC.view.backgroundColor = UIColor.clear
//
//                UIView.animate(withDuration: self.transitionDuration * 3 / 5, delay: 0
//                    , options: .curveEaseIn, animations:  {
//
//                        fromVC.view.setNeedsLayout()
//                        fromVC.view.layoutIfNeeded()
//
//                }, completion: { _ in
//                    anim?()
//                })
//            }
//
//            let anim2 = { () -> Void in
//
//                fromVC.view.alpha = 0
//                UIView.animate(withDuration: self.transitionDuration * 2 / 5, delay: 0
//                    , options: .curveEaseIn, animations:  {
//                        toVC.productThumbnailView.transform = .identity
//                        print(toVC.productThumbnailView.center)
//                        toVC.productThumbnailView.center = originalCenter
//                        print(toVC.productThumbnailView.center)
//                        //toVC.view.alpha = 1
////                        toVC.view.setNeedsLayout()
////                        toVC.view.layoutIfNeeded()
//
//                }, completion: { _ in
////                    toVC.view.backgroundColor = UIColor.white
////                    fromVC.productThumbnailView.transform = .identity
//
//                    let success = !transitionContext.transitionWasCancelled
//                    if !success {
//                        fromVC.view.alpha = 1
//                        toView.removeFromSuperview()
//                    }
//                    transitionContext.completeTransition(success)
//                    //transitionContext.completeTransition(true)
//                })
//            }
//
//            anim1(anim2)

            UIView.animateKeyframes(
                withDuration: transitionDuration,
                delay: 0,
                options: .calculationModeCubic,
                animations: {
                    // 2
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3 / 5) {
                        fromVC.view.setNeedsLayout()
                        fromVC.view.layoutIfNeeded()
                    }

                    UIView.addKeyframe(withRelativeStartTime: 3 / 5, relativeDuration: 1 / 100) {
                        fromVC.expandableViewBottomConstraint.constant = fromVC.productDescriptionView.bounds.height + self.expandGap
                        fromVC.view.alpha = 0
                        fromVC.view.setNeedsLayout()
                        fromVC.view.layoutIfNeeded()
                    }

                    // 3
                    UIView.addKeyframe(withRelativeStartTime: (3 / 5) + (1 / 100), relativeDuration: (2 / 5) - (1 / 100)) {
                        toVC.productThumbnailView.transform = .identity
                        toVC.productThumbnailView.center = originalCenter
                    }
            },
                // 5
                completion: { _ in
//                    toVC.view.isHidden = false
//                    snapshot.removeFromSuperview()
//                    fromVC.view.layer.transform = CATransform3DIdentity
//                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    let success = !transitionContext.transitionWasCancelled
                    if !success {
                        fromVC.view.alpha = 1
                        toView.removeFromSuperview()
                        fromVC.view.backgroundColor = UIColor.white
                    }
                    transitionContext.completeTransition(success)
            })



            return
        }

        let fromVC = transitionContext.viewController(forKey:.from) as! FirstCustomTransitionViewController
        let toVC = transitionContext.viewController(forKey:.to) as! SecondCustomTransitionViewController

        fromVC.productThumbnailView.transform = .identity
        let destinationBounds = toVC.productImageView.bounds
        let originalBounds = fromVC.productThumbnailView.bounds
        let widthDiffScale = (destinationBounds.width - expandGap * 2) / originalBounds.width

        toVC.productDescriptionTopConstraint.constant = -toVC.productDescriptionView.bounds.height
        toVC.productDescriptionBottomConstraint.constant = toVC.productDescriptionView.bounds.height

        toVC.expandableViewTopConstraint.constant = expandGap
        toVC.expandableViewLeadingConstraint.constant = expandGap
        toVC.expandableViewTrailingConstraint.constant = expandGap
        toVC.expandableViewBottomConstraint.constant = toVC.productDescriptionView.bounds.height + expandGap

        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()

        let anim1 = { (anim: (() -> Void)?) -> Void in
            toVC.view.alpha = 0
            UIView.animate(withDuration: self.transitionDuration * 2 / 5, delay: 0
                , options: .curveEaseIn, animations:  {
                    fromVC.productThumbnailView.transform = CGAffineTransform(scaleX: widthDiffScale, y: widthDiffScale)

                    let productImageViewCenter = toVC.productImageView.superview!.convert(toVC.productImageView.center, to: toVC.view)
                    let centerToMove = fromVC.view.convert(productImageViewCenter, to: fromVC.productThumbnailView.superview)

                    fromVC.productThumbnailView.center = centerToMove

            }, completion: { _ in
                anim?()
            })
        }

        let anim2 = { () -> Void in

            toVC.productDescriptionTopConstraint.constant = 0
            toVC.productDescriptionBottomConstraint.constant = 0

            toVC.expandableViewTopConstraint.constant = 0
            toVC.expandableViewLeadingConstraint.constant = 0
            toVC.expandableViewTrailingConstraint.constant = 0
            toVC.expandableViewBottomConstraint.constant = 0

            toVC.view.alpha = 1
            toVC.view.backgroundColor = UIColor.clear

            UIView.animate(withDuration: self.transitionDuration * 3 / 5, delay: 0
                , options: .curveEaseIn, animations:  {
                    //fromVC.sampleImageView.alpha = 0
                    //toVC.view.alpha = 1
                    toVC.view.setNeedsLayout()
                    toVC.view.layoutIfNeeded()

            }, completion: { _ in
                toVC.view.backgroundColor = UIColor.white
                fromVC.productThumbnailView.transform = .identity
                transitionContext.completeTransition(true)
            })
        }

        anim1(anim2)

    }
}

class CustomNavigationController: UINavigationController {

    var interactionController: UIPercentDrivenInteractiveTransition?
    private var edgeSwipeGestureRecognizer: UIScreenEdgePanGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // 2
        delegate = self

        edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        edgeSwipeGestureRecognizer!.edges = .left
        view.addGestureRecognizer(edgeSwipeGestureRecognizer!)
    }

    @objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        // 1
        let percent = gestureRecognizer.translation(in: gestureRecognizer.view!).x / gestureRecognizer.view!.bounds.size.width

        if gestureRecognizer.state == .began {
            // 2
            interactionController = UIPercentDrivenInteractiveTransition()
            popViewController(animated: true)
        } else if gestureRecognizer.state == .changed {
            if percent > 0.5 {
                interactionController?.finish()
            } else {
                interactionController?.update(percent)
            }
            // 3
        } else if gestureRecognizer.state == .ended {
            // 4
            if percent > 0.5 && gestureRecognizer.state != .cancelled {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
    }
}

extension CustomNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return OpacityTransition(presenting: true)
        } else {
            return OpacityTransition(presenting: false)
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

}
