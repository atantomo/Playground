//
//  ColorPageViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/14.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class ButtonedViewController: UIViewController {

    var pageVC: ColorPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let buttonFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let button = UIButton(frame: buttonFrame)
        button.backgroundColor = UIColor(red: 255/255, green: 208/255, blue: 242/255, alpha: 1)
        button.layer.cornerRadius = 8.0
        view.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 100),
            button.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 50),
            button.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -50),
            button.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 50),
            button.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -50)
        ])
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)


//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view.widthAnchor.constraint(equalToConstant: 300),
//            view.heightAnchor.constraint(equalToConstant: 300)
//            ])

//        let leftTapViewFrame = CGRect(x: 0, y: 0, width: 100, height: view.bounds.height)
//        let leftTapView = UIView(frame: leftTapViewFrame)
//        leftTapView.tag = 0
//        view.addSubview(leftTapView)
//
//        leftTapView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            leftTapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            leftTapView.topAnchor.constraint(equalTo: view.topAnchor),
//            leftTapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            leftTapView.widthAnchor.constraint(equalToConstant: 100)
//            ])
//
//        let leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(transparentViewTapped))
//        leftTapView.addGestureRecognizer(leftTapGesture)
//
//        let rightTapViewFrame = CGRect(x: 0, y: 0, width: 100, height: view.bounds.height)
//        let rightTapView = UIView(frame: rightTapViewFrame)
//        rightTapView.tag = 1
//        view.addSubview(rightTapView)
//
//        rightTapView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            rightTapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            rightTapView.topAnchor.constraint(equalTo: view.topAnchor),
//            rightTapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            rightTapView.widthAnchor.constraint(equalToConstant: 100)
//            ])
//
//        let rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(transparentViewTapped))
//        rightTapView.addGestureRecognizer(rightTapGesture)
    }

    override func didMove(toParentViewController parent: UIViewController?) {

        if let parent = parent {
            pageVC = parent as! ColorPageViewController
        }
    }


    func buttonTapped(button: UIButton) {
        pageVC.setViewControllers([pageVC.childVCs.last!], direction: UIPageViewControllerNavigationDirection.reverse, animated: true) { (completed) in
            if !completed {
                return
            }
        }
        guard let vcs = self.pageVC.viewControllers else {
            return
        }
        pageVC.pageChangeHandler?(vcs)
    }

    func transparentViewTapped(gestureRecognizer: UIGestureRecognizer) {
        NotificationCenter.default.post(name: .tap, object: gestureRecognizer)
    }
}

class ColorPageViewController: UIPageViewController {

    lazy var childVCs: [UIViewController] = {
        let babyBlueVc = ButtonedViewController()
        babyBlueVc.view.backgroundColor = UIColor(red: 190/255, green: 192/255, blue: 232/255, alpha: 1)

        let seaBlueVc = ButtonedViewController()
        seaBlueVc.view.backgroundColor = UIColor(red: 221/255, green: 255/255, blue: 248/255, alpha: 1)

        let meadowGreenVC = ButtonedViewController()
        meadowGreenVC.view.backgroundColor = UIColor(red: 214/255, green: 232/255, blue: 190/255, alpha: 1)

        let sunYellowVc = ButtonedViewController()
        sunYellowVc.view.backgroundColor = UIColor(red: 255/255, green: 247/255, blue: 229/255, alpha: 1)

        return [
            babyBlueVc,
            seaBlueVc,
            meadowGreenVC,
            sunYellowVc
        ]
    }()

    var pageChangeHandler: (([UIViewController]) -> (Void))?

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllers([childVCs.first!], direction: UIPageViewControllerNavigationDirection.forward, animated: true) { (completed) in
            
        }

        // change tap gesture recognizer for pageCurl transition to 2
//        for g in gestureRecognizers {
//            if let g = g as? UITapGestureRecognizer {
//                g.numberOfTapsRequired = 2
//            }
//        }

        // Do any additional setup after loading the view.

        NotificationCenter.default.addObserver(
        forName:.tap, object: nil, queue: .main) { n in
            let g = n.object as! UIGestureRecognizer
            let which = g.view!.tag
            let vc0 = self.viewControllers![0]
            
            guard let vc = (which == 0 ?
                self.pageViewController(self, viewControllerBefore: vc0) :
                self.pageViewController(self, viewControllerAfter: vc0))
                else {
                    return
            }
            let dir : UIPageViewControllerNavigationDirection =
                which == 0 ? .reverse : .forward
            UIApplication.shared.beginIgnoringInteractionEvents()
            self.setViewControllers([vc], direction: dir, animated: true) {
                _ in
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ColorPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        let index = childVCs.index(of: viewController)! - 1
        if index < 0 {
            return nil
        }
        return childVCs[index]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        let index = childVCs.index(of: viewController)! + 1
        if index >= childVCs.count {
            return nil
        }
        return childVCs[index]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return childVCs.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let vc = pageViewController.viewControllers?.first else {
            return 0
        }
        return childVCs.index(of:vc)!
    }
}

extension NSNotification.Name {

    static let tap = NSNotification.Name(rawValue: "tap")
}
extension ColorPageViewController: UIPageViewControllerDelegate {

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            return
        }
        pageChangeHandler?(pageViewController.viewControllers!)
    }
    
    
}

