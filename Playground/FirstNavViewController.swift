//
//  FirstNavViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class FirstNavViewController: UIViewController {
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sampleImageView: UIImageView!

    var transitionDelegate: UINavigationControllerDelegate?

    override var prefersStatusBarHidden: Bool {
        return false
    }

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        transitionDelegate = MagicBoxTransition()
        navigationController?.delegate = transitionDelegate

        title = "I'm unique"
        scrollView.delegate = self
//        navigationItem.title = "Love"
//        navigationItem.prompt = "Love is the greatest of all"

//        let melonButton = UIBarButtonItem(image: #imageLiteral(resourceName: "melon-s"), style: .plain, target: self, action: nil)
//        setToolbarItems([melonButton], animated: false)
//        navigationController?.setToolbarHidden(false, animated: false)
//        hidesBottomBarWhenPushed = true

       // navigationController?.hidesBarsOnSwipe = true

        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-heart"), style: .plain, target: self, action: nil)
        backButton.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        navigationItem.backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-heart"), style: .plain, target: self, action: nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()

        // BOOK: to display large title under normal nav bar
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//        }

        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "melon-s"), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.isTranslucent = false

        navigationController?.navigationBar.barTintColor = .white
        // BOOK: this will determine the style of status bar as well
//        navigationController?.navigationBar.barStyle = .blackTranslucent
//        navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "white-square"), for: .default)

        //navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "melon-s"), for: .default)

        extendedLayoutIncludesOpaqueBars = true

//        let whiteFrame = CGRect(x: 0, y: 0, width: 375, height: 44)
//        let white = UIView(frame: whiteFrame)
//        navigationController?.navigationBar.addSubview(white)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func viewDidAppear(_ animated: Bool) {
        print(view.center)
        // isTranslucent (187.5, 406.0)
        // isTranslucent (187.5, 450.0)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }

    @IBAction func leaveMeBeButtonTapped(_ sender: Any) {
        guard let isHidden = navigationController?.isNavigationBarHidden else {
            return
        }
        if isHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension FirstNavViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = scrollView.contentOffset.y

        print(verticalOffset)
        if verticalOffset > 0 {
            topConstraint.constant = -(verticalOffset / 2)
        }
    }
}

class MagicBoxTransition: NSObject {
    let transitionDuration: TimeInterval = 1.0
}

extension MagicBoxTransition: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using ctx: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    func animateTransition(using ctx: UIViewControllerContextTransitioning) {

        let vc1 = ctx.viewController(forKey:.from)
        let v1 = ctx.view(forKey:.from)!
        let r1initial = ctx.initialFrame(for:vc1!)

        let con = ctx.containerView

        let vc2 = ctx.viewController(forKey:.to)
        let v2 = ctx.view(forKey:.to)!
        //let r2end = ctx.finalFrame(for:vc2!)

        con.addSubview(v2)
//        vc2!.navigationController?.view.setNeedsLayout()
//        vc2!.navigationController?.view.layoutIfNeeded()
//
//        vc1!.navigationController?.view.setNeedsLayout()
//        vc1!.navigationController?.view.layoutIfNeeded()


        if let _ = vc1!.navigationController?.viewControllers.index(of: vc1!) { // presenting

            let fromVC = vc1 as! FirstNavViewController
            let toVC = vc2 as! SecondNavViewController

            fromVC.sampleImageView.transform = .identity

//            v2.frame = r2end
//            v2.frame.origin.x += v2.frame.width / 2
//            v2.alpha = 0

//            UIView.animate(withDuration: 1, delay: 0
//                , options: .curveEaseInOut, animations:  {
//                    fromVC.sampleImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//                    v1.alpha = 0
////                    v2.alpha = 1
////                    v2.frame.origin.x = 0
//
//            }, completion: { _ in
//                ctx.completeTransition(true)
//                fromVC.sampleImageView.transform = .identity
//            })

            let anim1 = { (anim: (() -> Void)?) -> Void in
                toVC.view.alpha = 0
                UIView.animate(withDuration: self.transitionDuration / 2, delay: 0
                    , options: .curveEaseInOut, animations:  {
//                        let oldFrame = fromVC.navigationController!.navigationBar.frame
//                        let newFrame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y - oldFrame.size.height - 20, width: oldFrame.size.width, height: oldFrame.size.height)
//                        fromVC.navigationController?.navigationBar.frame = newFrame
                        fromVC.sampleImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

                        let mapCenter = toVC.mapView.superview!.convert(toVC.mapView.center, to: toVC.view)
                        let centerToMove = fromVC.view.convert(mapCenter, to: fromVC.sampleImageView.superview)

                        fromVC.sampleImageView.center = centerToMove

                }, completion: { _ in
                    anim?()
                })
            }

            let anim2 = { () -> Void in

                //toVC.mapView.frame = fromVC.sampleImageView.frame
                //toVC.view.transform = fromVC.sampleImageView.transform
                UIView.animate(withDuration: self.transitionDuration / 2, delay: 0
                    , options: .curveEaseInOut, animations:  {
                        //fromVC.sampleImageView.alpha = 0
                        toVC.view.alpha = 1

                }, completion: { _ in
                    ctx.completeTransition(true)
                    fromVC.sampleImageView.transform = .identity
                })
            }

            anim1(anim2)

        } else { // dismissing

            v1.frame = r1initial
            v1.alpha = 1

            UIView.animate(withDuration: transitionDuration, delay: 0
                , options: .curveEaseInOut, animations:  {
                    v1.alpha = 0
                    v2.alpha = 1
                    v1.frame.origin.x += v1.frame.width / 2

            }, completion: { _ in
                ctx.completeTransition(true)
            })
        }
    }
}

extension MagicBoxTransition: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

}
