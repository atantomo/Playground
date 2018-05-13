//
//  SkeletonTestViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/03/22.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SkeletonTestViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet var skeletonParts: [UIView]!
    private lazy var skeletonView: SkeletonView = {
        return SkeletonView(referenceParent: self.containerView, referenceParts: self.skeletonParts)
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        view.addSubview(skeletonView)
    }

    deinit {
        print("SkeletonTestViewController released!")
    }

    @IBAction func switchTapped(_ sender: UISwitch) {
        if sender.isOn {
            skeletonView.show()
        } else {
            skeletonView.hide()
        }
    }
}


