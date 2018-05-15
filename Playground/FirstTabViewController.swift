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
        print(bottomLayoutGuide.length)
        print(tabBarController?.bottomLayoutGuide.length)
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

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 1088

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

        if #available(iOS 11.0, *) {
            additionalSafeAreaInsets = newSafeArea
        } else {
            // Fallback on earlier versions
        }

         let framea = CGRect(x: 0, y: 100, width: 375, height: h)
        for child in childViewControllers {
            child.view.frame = framea
        }
//        view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 39).isActive = true

        //print(bottomLayoutGuide.length)
        //tabBar.isHidden = true
    }
    

}



