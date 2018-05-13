//
//  LabelViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class LabelViewController: UIViewController {

    var containerWidth: CGFloat = 0.0
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var container: UIView!

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        container.layer.borderWidth = 1.0
        container.layer.borderColor = UIColor.lightGray.cgColor
        container.backgroundColor = UIColor.white

//        NotificationCenter.default.addObserver(self, selector: #selector(viewDidLayoutSubviews), name: Notification.Name.viewDidLayout, object: nil)
        containerWidth = containerWidthConstraint.constant

//        containerWidthConstraint.constant = containerWidth * 0.3
//        slider.value = 0.3

        leftTextField.text = leftLabel.text
        centerTextField.text = centerLabel.text
        rightTextField.text = rightLabel.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func sliderSlided(_ sender: UISlider) {
        containerWidthConstraint.constant = containerWidth * CGFloat(sender.value)
    }

    @IBAction func leftTextFieldTyped(_ sender: UITextField) {
        leftLabel.text = sender.text
    }

    @IBAction func centerTextFieldTyped(_ sender: UITextField) {
        centerLabel.text = sender.text
    }

    @IBAction func rightTextFieldTyped(_ sender: UITextField) {
        rightLabel.text = sender.text
    }
}

