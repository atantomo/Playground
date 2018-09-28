//
//  FirstTabViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class FirstTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        print(bottomLayoutGuide.length)
//        print(tabBarController?.bottomLayoutGuide.length)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loveButtonTapped(_ sender: Any) {
        let item = tabBarItem

//        var v: UIImageView = self
//        repeat { v = v.superview! } while !(v is UITableView)

        item?.badgeValue = "2"
        if let view = tabBarController?.tabBar.subviews[2].subviews.first as? UIImageView {

            let image = UIImageView(image: view.image)
            image.bounds = view.bounds
            image.tintColor = UIColor(red: 210/255, green: 64/255, blue: 94/255, alpha: 1.0)

            view.addSubview(image)

            //print(view)
            UIView.animate(withDuration: 0.7, animations: {
                image.alpha = 0.0
                image.transform = CGAffineTransform(scaleX: 3, y: 3)
            }, completion: { completed in
                image.removeFromSuperview()
            })
        }
    }
}

extension FirstTabViewController: UIToolbarDelegate {

    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
}

class TabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        frame = CGRect(x: 0, y: 618, width: 375, height: 49)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 88

        return sizeThatFits
    }
}

class TallTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self

        let h: CGFloat = 88
        let frame = CGRect(x: 0, y: view.bounds.height - h, width: 375, height: h)
        let v = UIView(frame: frame)
        v.backgroundColor = UIColor.red
        v.alpha = 0.2

        view.insertSubview(v, belowSubview: tabBar)

        var newSafeArea = UIEdgeInsets()
        newSafeArea.bottom += 39


//        if #available(iOS 11.0, *) {
//            additionalSafeAreaInsets = newSafeArea
//        } else {
//            // Fallback on earlier versions
//        }
//
//         let framea = CGRect(x: 0, y: 100, width: 375, height: h)
//        for child in childViewControllers {
//            child.view.frame = framea
//        }
//        view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 39).isActive = true

        //print(bottomLayoutGuide.length)
        //tabBar.isHidden = true
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        guard let newSelectedIndex = viewControllers?.index(of: viewController),
            let navVC = viewController as? UINavigationController else {
                return true
        }

        let currentSelectedIndex = tabBarController.selectedIndex
        let isAttemptingPopToRoot = (newSelectedIndex == currentSelectedIndex)
        let shouldAnimatePopToRoot = navVC.viewControllers.last?.prefersPopToRootAnimated ?? true
        if isAttemptingPopToRoot && !shouldAnimatePopToRoot {

            navVC.popToRootViewController(animated: false)
            return false
        }
        return true
    }

//    var lastSelectedIndex = 0

//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//
//        if let selectedIndex = tabBar.items?.index(of: item),
//            let navVC = viewControllers?[selectedIndex] as? UINavigationController {
//
//            guard selectedIndex != lastSelectedIndex else {
//                return
//            }
//
//            lastSelectedIndex = selectedIndex
//
//            if navVC.viewControllers.last is TabPopWithoutAnimationViewController {
//                navVC.popToRootViewController(animated: false)
//            }
//        }
//    }

//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if let vc = viewController as? UINavigationController {
//            vc.popViewController(animated: false)
//        }
//    }


}

class TabPopWithAnimationViewController: UIViewController {

    override var prefersPopToRootAnimated: Bool {
        return true
    }

}

class TabPopWithoutAnimationViewController: UIViewController {

    override var prefersPopToRootAnimated: Bool {
        return false
    }

}

extension UIViewController {

    @objc var prefersPopToRootAnimated: Bool {
        return true
    }

}

//extension TabPopWithAnimationViewController: NavigationPopToRootControllable {
//    var shouldPopToRootAnimated: Bool {
//        return true
//    }
//}

//extension TabPopWithoutAnimationViewController: NavigationPopToRootControllable {
//    var shouldPopToRootAnimated: Bool {
//        return false
//    }
//}

//protocol NavigationPopToRootControllable { }
//
//extension NavigationPopToRootControllable {
//
//    var shouldPopToRootAnimated: Bool {
//        return true
//    }
//}

