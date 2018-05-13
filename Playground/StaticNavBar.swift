//
//  StaticNavBar.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/02.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

protocol StaticNavBarDelegate {
    func navigationItemShouldAnimatePop() -> Bool
}

class StaticNavBar: UINavigationBar {

    var itemDelegate: StaticNavBarDelegate!

    override func popItem(animated: Bool) -> UINavigationItem? {
        let shouldPop = itemDelegate.navigationItemShouldAnimatePop()
        return super.popItem(animated: shouldPop)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
