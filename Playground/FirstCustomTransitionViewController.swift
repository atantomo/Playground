//
//  FirstCustomTransitionViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

protocol CardDrawingTransitionPresenting {
    var topCardView: UIView { get }
    var rootView: UIView { get }
}

extension CardDrawingTransitionPresenting where Self: UIViewController {
    var rootView: UIView {
        return view
    }
}

protocol CardDrawingTransitionPresented {
    var topCardView: UIView { get }
    var bottomCardView: UIView { get }
    var rootView: UIView { get }
}

extension CardDrawingTransitionPresented where Self: UIViewController {
    var rootView: UIView {
        return view
    }
}

class FirstCustomTransitionViewController: UIViewController {

    @IBOutlet weak var productThumbnailView: UIView!
    @IBOutlet weak var productThumbnailImageView: UIImageView!

    @IBOutlet weak var eventThumbnailView: UIView!

    @IBOutlet var productViewTapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var eventViewTapGestureRecognizer: UITapGestureRecognizer!

    var viewForTransition: UIView!

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let senderString = sender as? String,
            let itemVC = segue.destination as? SecondCustomTransitionViewController else {
                return
        }
        switch senderString {
        case "product":
            viewForTransition = productThumbnailView
            let _ = itemVC.view
            itemVC.productMainImageView.image = #imageLiteral(resourceName: "melon-s")
        case "event":
            viewForTransition = eventThumbnailView
            let _ = itemVC.view
            itemVC.productMainImageView.image = #imageLiteral(resourceName: "forest_house")
        default:
            break
        }
    }

    @IBAction func productImageTapped(_ sender: Any) {
        performSegue(withIdentifier: "ListItemTransition", sender: "product")
    }

    @IBAction func eventImageTapped(_ sender: Any) {
        performSegue(withIdentifier: "ListItemTransition", sender: "event")
    }
}

extension FirstCustomTransitionViewController: CardDrawingTransitionPresenting {

    var topCardView: UIView {
        return viewForTransition
    }
}

class CardDrawingTransition: NSObject {
    let transitionDuration: TimeInterval = 0.8
    let expandGap: CGFloat = 32.0
    let presenting: Bool

    init(presenting: Bool) {
        self.presenting = presenting
    }
}

extension CardDrawingTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else {
                return
        }

        let container = transitionContext.containerView
        if presenting {
            container.addSubview(toView)
            toView.alpha = 0.0
        } else {
            container.insertSubview(toView, belowSubview: fromView)
        }

        if presenting {

            guard let presentingVC = transitionContext.viewController(forKey:.from) as? CardDrawingTransitionPresenting,
                let presentedVC = transitionContext.viewController(forKey:.to) as? CardDrawingTransitionPresented else {
                    return
            }

            presentingVC.topCardView.superview?.bringSubview(toFront: presentingVC.topCardView)

            presentedVC.rootView.setNeedsLayout()
            presentedVC.rootView.layoutIfNeeded()

            let originalBounds = presentingVC.topCardView.bounds
            let destinationBounds = presentedVC.topCardView.bounds

            let originTopCardTransformationScale = (destinationBounds.width - expandGap * 2) / originalBounds.width
            let destinationTopCardInitialScale = (destinationBounds.width - expandGap * 2) / destinationBounds.width

            let scale = CGAffineTransform(scaleX: destinationTopCardInitialScale, y: destinationTopCardInitialScale)
            presentedVC.rootView.transform = scale

            presentedVC.bottomCardView.transform = CGAffineTransform(translationX: 0, y: -(presentedVC.bottomCardView.bounds.height))
            presentedVC.rootView.backgroundColor = UIColor.clear

            UIView.animateKeyframes(
                withDuration: transitionDuration,
                delay: 0,
                options: .calculationModeLinear,
                animations: {

                    var start: Double = 0
                    var duration: Double = 6 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {

                        let scale = CGAffineTransform(scaleX: originTopCardTransformationScale, y: originTopCardTransformationScale)

                        let convertedPresentedTopCardCenter = presentedVC.topCardView.superview!.convert(presentedVC.topCardView.center, to: presentedVC.rootView)

                        let convertedPresentedTopCardCenterA = presentedVC.topCardView.superview!.convert(presentedVC.rootView.center, to: presentedVC.rootView)


                        let scaledY = convertedPresentedTopCardCenterA.y - ((convertedPresentedTopCardCenterA.y - convertedPresentedTopCardCenter.y) * destinationTopCardInitialScale)
                        
                        let translate = CGAffineTransform(translationX: convertedPresentedTopCardCenter.x - presentingVC.topCardView.center.x, y: scaledY - presentingVC.topCardView.center.y)

                        let transform = scale.concatenating(translate)

                        presentingVC.topCardView.transform = transform
                    }

                    start += duration
                    duration = 1 / 12


                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        presentedVC.rootView.alpha = 1
                    }

                    start += duration
                    duration = 5 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        presentedVC.rootView.transform = .identity
                        presentedVC.bottomCardView.transform = .identity
                    }
            },
                completion: { _ in
                    presentedVC.rootView.backgroundColor = UIColor.white
                    presentingVC.topCardView.transform = .identity
                    transitionContext.completeTransition(true)
            })

        } else {

            guard let presentingVC = transitionContext.viewController(forKey:.to) as? CardDrawingTransitionPresenting,
                let presentedVC = transitionContext.viewController(forKey:.from) as? CardDrawingTransitionPresented else {
                    return
            }

            let originalBounds = presentedVC.topCardView.bounds
            let destinationBounds = presentingVC.topCardView.bounds

            let originTopCardTransformationScale = (originalBounds.width - expandGap * 2) / destinationBounds.width
            let destinationTopCardInitialScale = (originalBounds.width - expandGap * 2) / originalBounds.width

            let scale = CGAffineTransform(scaleX: originTopCardTransformationScale, y: originTopCardTransformationScale)

            let convertedPresentedTopCardCenter = presentedVC.topCardView.superview!.convert(presentedVC.topCardView.center, to: presentedVC.rootView)

            let translate = CGAffineTransform(translationX: convertedPresentedTopCardCenter.x - presentingVC.topCardView.center.x, y: convertedPresentedTopCardCenter.y - presentingVC.topCardView.center.y + expandGap / 2)

            let transform = scale.concatenating(translate)

            presentingVC.topCardView.transform = transform

            presentedVC.rootView.backgroundColor = UIColor.clear

            UIView.animateKeyframes(
                withDuration: transitionDuration,
                delay: 0,
                options: .calculationModeLinear,
                animations: {

                    var start: Double = 0
                    var duration: Double = 4 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {

                        let scale = CGAffineTransform(scaleX: destinationTopCardInitialScale, y: destinationTopCardInitialScale)
                        presentedVC.rootView.transform = scale
                    }

                    start += duration
                    duration = 4 / 12


                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        presentedVC.bottomCardView.transform = CGAffineTransform(translationX: 0, y: -(presentedVC.bottomCardView.bounds.height))
                    }

                    start += duration
                    duration = 1 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        presentedVC.rootView.alpha = 0
                    }

                    start += duration
                    duration = 3 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        presentingVC.topCardView.transform = .identity
                    }
            },
                completion: { _ in
                    let success = !transitionContext.transitionWasCancelled
                    if !success {
                        presentedVC.rootView.alpha = 1
                        toView.removeFromSuperview()
                        presentedVC.rootView.backgroundColor = UIColor.white
                    }
                    transitionContext.completeTransition(success)
            })
        }

    }
}

class OpacityTransition: NSObject {
    let transitionDuration: TimeInterval = 0.8
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

            let destinationBounds = fromVC.productImageView.bounds
            let originalBounds = toVC.productThumbnailView.bounds
            let widthDiffScale = (destinationBounds.width - expandGap * 2) / originalBounds.width

            let widthDiffScalea = (destinationBounds.width - expandGap * 2) / destinationBounds.width

//            fromVC.productDescriptionTopConstraint.constant = -fromVC.productDescriptionView.bounds.height
//            fromVC.productDescriptionBottomConstraint.constant = fromVC.productDescriptionView.bounds.height

//            fromVC.expandableViewTopConstraint.constant = expandGap
//            fromVC.expandableViewLeadingConstraint.constant = expandGap
//            fromVC.expandableViewTrailingConstraint.constant = expandGap
//            fromVC.expandableViewBottomConstraint.constant = /*fromVC.productDescriptionView.bounds.height +*/ expandGap

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
                options: .calculationModeLinear,
                animations: {

                    var start: Double = 0
                    var duration: Double = 4 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
//                        fromVC.view.setNeedsLayout()
//                        fromVC.view.layoutIfNeeded()

                        let point = CGPoint(x: fromVC.view.center.x, y: fromVC.view.center.y - 16)

                        fromVC.view.center = point

                        fromVC.view.transform = CGAffineTransform(scaleX: widthDiffScalea, y: widthDiffScalea)
                    }

                    start += duration
                    duration = 4 / 12


                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
                        let point = CGPoint(x: fromVC.productDescriptionView.center.x, y: fromVC.productDescriptionView.center.y - fromVC.productDescriptionView.bounds.height)

                        fromVC.productDescriptionView.center = point
                    }

                    start += duration
                    duration = 1 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
//                        fromVC.expandableViewBottomConstraint.constant = fromVC.productDescriptionView.bounds.height + self.expandGap
                        fromVC.view.alpha = 0
                    }

                    start += duration
                    duration = 3 / 12

                    UIView.addKeyframe(withRelativeStartTime: start, relativeDuration: duration) {
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

        let widthDiffScalea = ((destinationBounds.width) / originalBounds.width) / widthDiffScale

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

                    fromVC.productThumbnailImageView.transform = CGAffineTransform(scaleX: widthDiffScalea, y: widthDiffScalea)

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
                fromVC.productThumbnailImageView.transform = .identity
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
            if percent > 0.4 {
                interactionController?.finish()
                interactionController = nil
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
            return CardDrawingTransition(presenting: true)
        } else {
            return CardDrawingTransition(presenting: false)
        }
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }

}
