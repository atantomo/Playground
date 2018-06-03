//
//  SecondCustomTransitionViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SecondCustomTransitionViewController: UIViewController {

    @IBOutlet weak var expandableView: UIView!
    @IBOutlet weak var productImageView: UIView!
    @IBOutlet weak var productMainImageView: UIImageView!
    @IBOutlet weak var productDescriptionView: UIView!

    @IBOutlet weak var productDescriptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var productDescriptionBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var expandableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandableViewBottomConstraint: NSLayoutConstraint!

    var viewForTransition: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension SecondCustomTransitionViewController: CardDrawingTransitionPresented {

    var topCardView: UIView {
        return productImageView
    }

    var bottomCardView: UIView {
        return productDescriptionView
    }
}
