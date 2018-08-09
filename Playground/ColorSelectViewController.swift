//
//  ColorSelectViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/14.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class ColorSelectViewController: UIViewController {

    @IBOutlet weak var colorPageView: UIView!
    @IBOutlet weak var labelContainer: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var emptyView: UIView!

    @IBOutlet weak var skyButton: UIButton!
    @IBOutlet weak var seaButton: UIButton!
    @IBOutlet weak var meadowButton: UIButton!
    @IBOutlet weak var sunButton: UIButton!
    
    @IBOutlet weak var skyButtonContainer: UIView!
    @IBOutlet weak var seaButtonContainer: UIView!
    @IBOutlet weak var meadowButtonContainer: UIView!
    @IBOutlet weak var sunButtonContainer: UIView!

    @IBOutlet weak var pageIndicatorView: UIView!
    @IBOutlet weak var pageIndicatorFirstLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageIndicatorFirstTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var pageIndicatorSecondLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageIndicatorSecondTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var pageIndicatorThirdLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageIndicatorThirdTrailingConstraint: NSLayoutConstraint!

    @IBOutlet weak var pageIndicatorFourthLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageIndicatorFourthTrailingConstraint: NSLayoutConstraint!

    var colorPageVC: ColorPageViewController!
    var parallaxVC: UIViewController!

    lazy var pageIndicatorSidewayConstraints: [NSLayoutConstraint] = {
        return [
            self.pageIndicatorFirstLeadingConstraint,
            self.pageIndicatorFirstTrailingConstraint,
            self.pageIndicatorSecondLeadingConstraint,
            self.pageIndicatorSecondTrailingConstraint,
            self.pageIndicatorThirdLeadingConstraint,
            self.pageIndicatorThirdTrailingConstraint,
            self.pageIndicatorFourthLeadingConstraint,
            self.pageIndicatorFourthTrailingConstraint
        ]}()

    override func viewDidLoad() {
        super.viewDidLoad()

        parallaxVC = storyboard!.instantiateViewController(withIdentifier: "ParallaxNav")

        colorPageVC = storyboard!.instantiateViewController(withIdentifier: "ColorPage") as! ColorPageViewController
        addChildViewController(colorPageVC)
        view.addSubview(colorPageVC.view)
        colorPageVC.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorPageVC.view.topAnchor.constraint(equalTo: colorPageView.topAnchor),
            colorPageVC.view.leadingAnchor.constraint(equalTo: colorPageView.leadingAnchor),
            colorPageVC.view.bottomAnchor.constraint(equalTo: colorPageView.bottomAnchor),
            colorPageVC.view.trailingAnchor.constraint(equalTo: colorPageView.trailingAnchor),
            ])

        colorPageVC.didMove(toParentViewController: self)

        colorPageVC.pageChangeHandler = { [weak self] (childVCs: [UIViewController]) in
            guard let vc = childVCs.first else {
                return
            }

            let index = self?.colorPageVC.childVCs.index(of: vc)
            switch index {
            case 0?:
                self?.skyButtonTapped(self!.skyButton)
            case 1?:
                self?.seaButtonTapped(self!.seaButton)
            case 2?:
                self?.meadowButtonTapped(self!.meadowButton)
            case 3?:
                self?.sunButtonTapped(self!.sunButton)
            default:
                break
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print(sizeLabel.intrinsicContentSize)
//        print(labelContainer.intrinsicContentSize)

//        print(sizeLabel.systemLayoutSizeFitting(UILayoutFittingCompressedSize))
//        print(labelContainer.systemLayoutSizeFitting(UILayoutFittingCompressedSize))
//        print(colorPageVC.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize))
        print(colorPageVC.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize))
        print("sizesize")
    }
    
    @IBAction func colorPageButtonTapped(_ sender: Any) {
        addChildViewController(colorPageVC)
        parallaxVC.willMove(toParentViewController: nil)


        self.transition(
            from: parallaxVC,
            to: colorPageVC,
            duration: 0.4,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.colorPageVC.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    self!.colorPageVC.view.topAnchor.constraint(equalTo: self!.colorPageView.topAnchor),
                    self!.colorPageVC.view.leadingAnchor.constraint(equalTo: self!.colorPageView.leadingAnchor),
                    self!.colorPageVC.view.bottomAnchor.constraint(equalTo: self!.colorPageView.bottomAnchor),
                    self!.colorPageVC.view.trailingAnchor.constraint(equalTo: self!.colorPageView.trailingAnchor),
                    ])
        }) { [weak self] _ in
            self?.colorPageVC.didMove(toParentViewController: self)
            self?.parallaxVC.removeFromParentViewController()
        }
    }

    @IBAction func parallaxButtonTapped(_ sender: Any) {

        addChildViewController(parallaxVC)
        colorPageVC.willMove(toParentViewController: nil)


        self.transition(
            from: colorPageVC,
            to: parallaxVC,
            duration: 0.4,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.parallaxVC.view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    self!.parallaxVC.view.topAnchor.constraint(equalTo: self!.colorPageView.topAnchor),
                    self!.parallaxVC.view.leadingAnchor.constraint(equalTo: self!.colorPageView.leadingAnchor),
                    self!.parallaxVC.view.bottomAnchor.constraint(equalTo: self!.colorPageView.bottomAnchor),
                    self!.parallaxVC.view.trailingAnchor.constraint(equalTo: self!.colorPageView.trailingAnchor),
                    ])
        }) { [weak self] _ in
                self?.parallaxVC.didMove(toParentViewController: self)
                self?.colorPageVC.removeFromParentViewController()
        }
    }

    @IBAction func skyButtonTapped(_ sender: Any) {
        resetPriority()
        pageIndicatorFirstLeadingConstraint.priority = UILayoutPriorityDefaultHigh
        pageIndicatorFirstTrailingConstraint.priority = UILayoutPriorityDefaultHigh

        animateIfNeeded()

        colorPageVC.setViewControllers([colorPageVC.childVCs[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: true)
    }

    @IBAction func seaButtonTapped(_ sender: Any) {
        resetPriority()
        pageIndicatorSecondLeadingConstraint.priority = UILayoutPriorityDefaultHigh
        pageIndicatorSecondTrailingConstraint.priority = UILayoutPriorityDefaultHigh

        animateIfNeeded()

        colorPageVC.setViewControllers([colorPageVC.childVCs[1]], direction: UIPageViewControllerNavigationDirection.forward, animated: true)
    }

    @IBAction func meadowButtonTapped(_ sender: Any) {
        resetPriority()
        pageIndicatorThirdLeadingConstraint.priority = UILayoutPriorityDefaultHigh
        pageIndicatorThirdTrailingConstraint.priority = UILayoutPriorityDefaultHigh

        animateIfNeeded()

        colorPageVC.setViewControllers([colorPageVC.childVCs[2]], direction: UIPageViewControllerNavigationDirection.forward, animated: true)
    }

    @IBAction func sunButtonTapped(_ sender: Any) {
        resetPriority()
        pageIndicatorFourthLeadingConstraint.priority = UILayoutPriorityDefaultHigh
        pageIndicatorFourthTrailingConstraint.priority = UILayoutPriorityDefaultHigh

        animateIfNeeded()

        colorPageVC.setViewControllers([colorPageVC.childVCs[3]], direction: UIPageViewControllerNavigationDirection.forward, animated: true)
    }

    func resetPriority() {
        for c in pageIndicatorSidewayConstraints {
            c.priority = UILayoutPriorityDefaultLow
        }
    }

    func animateIfNeeded() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIViewAnimationOptions.curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
            }, completion: nil)
    }


}

//class IntrinsicSizedPageViewController: UIPageViewController {
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if __CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
//            invalidateIntrinsicContentSize()
//        }
//    }
//
//    override var intrinsicContentSize: CGSize {
//
//        return collectionViewLayout.collectionViewContentSize
//    }
//}
