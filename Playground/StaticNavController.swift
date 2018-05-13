//
//  StaticNavController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/02.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class StaticNavController: UINavigationController, StaticNavBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let navigationBar = self.navigationBar as! StaticNavBar
        navigationBar.itemDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var childViewControllerForStatusBarHidden: UIViewController? {
        return childViewControllers.last
    }


//    override func popViewController(animated: Bool) -> UIViewController? {
//        return super.popViewController(animated: false)
//    }

    func navigationItemShouldAnimatePop() -> Bool {
        let a = viewControllers.count <= 2
        print(a)
        return a
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
