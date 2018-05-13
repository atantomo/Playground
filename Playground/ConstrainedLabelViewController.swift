//
//  ConstrainedLabelViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/24.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class ConstrainedLabelViewController: UIViewController {

    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var constrainedLabel: UILabel!
    @IBOutlet weak var constrainedBottomBuffer: NSLayoutConstraint!
    @IBOutlet weak var fontSizeSlider: UISlider!

    var originalBuffer: CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        fontSizeSlider.value = Float(constrainedLabel.font.pointSize)

        originalBuffer = constrainedBottomBuffer.constant
        // Do any additional setup after loading the view.
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

    @IBAction func sliderSlided(_ sender: UISlider) {
        let newFontSize = CGFloat(sender.value)

        freeLabel.font = UIFont.systemFont(ofSize: newFontSize)
        constrainedLabel.font = UIFont.systemFont(ofSize: newFontSize)// sender.value

        if constrainedLabel.numberOfVisibleLines < 2 {
            constrainedBottomBuffer.constant = originalBuffer + constrainedLabel.intrinsicContentSize.height
        } else {
            constrainedBottomBuffer.constant = originalBuffer
        }

        print(constrainedLabel.numberOfVisibleLines)
    }

}

class DynamicIntrinsicLabel: UILabel {

    var heightMultiplier: CGFloat = 2.0

    override func layoutSubviews() {
        super.layoutSubviews()

        //if __CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        //}
    }

//    override var text: String? {
//        didSet {
//            invalidateIntrinsicContentSize()
//        }
//    }

    override var intrinsicContentSize: CGSize {

        let originalSize = super.intrinsicContentSize
        let size = CGSize(width: originalSize.width, height: originalSize.height / CGFloat(numberOfVisibleLines) * heightMultiplier)
        return size
    }
}


extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}
