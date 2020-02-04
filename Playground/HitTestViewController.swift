//
//  HitTestViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2019/01/04.
//  Copyright © 2019年 Andrew Tantomo. All rights reserved.
//

import UIKit

class HitTestViewController: UIViewController {

    @IBOutlet var intrinsicLabel: UILabel!
    @IBOutlet var greedyContainer: UIView!
    @IBOutlet var greedyView: GreedyView!
    @IBOutlet var pressConstraint: NSLayoutConstraint!
    @IBOutlet weak var frontScrollView: TouchSelectiveScrollView!
    @IBOutlet weak var backScrollView: UIScrollView!
    @IBOutlet weak var redView: UIView!

    @IBOutlet weak var selectiveView: TouchSelectiveView!
    @IBOutlet weak var touchPassThroughButton: UIButton!
    @IBOutlet weak var touchNoPassThroughButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectiveView.passThroughView = touchPassThroughButton

        frontScrollView.passThroughView = backScrollView
        frontScrollView.cell = redView

        frontScrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
        backScrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: [.new, .old], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print(backScrollView.contentOffset)
        let obj = object as? UIScrollView
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            if obj == frontScrollView {//} && frontScrollView.isTracking {
                if frontScrollView.contentOffset != backScrollView.contentOffset {
                    backScrollView.contentOffset = frontScrollView.contentOffset
                }
            }
            if obj == backScrollView {//}&& backScrollView.isTracking {
                if frontScrollView.contentOffset != backScrollView.contentOffset {
                    frontScrollView.contentOffset = backScrollView.contentOffset
                }
            }
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        print(frontScrollView.contentSize)
//    }

    @IBAction func buttonTapped(_ sender: Any) {
        greedyView.desiredSize = CGSize(width: 100, height: 100)
        pressConstraint.priority = .defaultHigh
        greedyView.setNeedsLayout()
        greedyView.layoutIfNeeded()
        print(intrinsicLabel.intrinsicContentSize)
        print(intrinsicLabel.intrinsicContentSize)
    }
}


class TouchSelectiveView: UIView {
    weak var passThroughView : UIView?

    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        if let pv = self.passThroughView {
            let pt = pv.convert(point, from: self)
            if pv.point(inside: pt, with: e) {
                return nil
            }
        }
        return super.hitTest(point, with: e)
    }
}

class TouchSelectiveScrollView: UIScrollView {
    weak var cell: UIView?
    weak var passThroughView : UIView?

    override func hitTest(_ point: CGPoint, with e: UIEvent?) -> UIView? {
        print(point)
//        if let cell = cell,
//            !cell.point(inside: point, with: e) {
//            return nil
//        }
        if let pv = self.passThroughView,
            let cell = cell {
            let pt = pv.convert(point, from: self)
            if pv.point(inside: pt, with: e) && !cell.point(inside: point, with: e) {
                return nil
            }
        }
        return super.hitTest(point, with: e)
    }
    
}


class GreedyView: UIView {

    //    override func sizeThatFits(_ size: CGSize) -> CGSize {
    //        return CGSize(width: 300, height: 300)
    //    }

    var desiredSize: CGSize = CGSize(width: 300, height: 300)

    //    override var bounds: CGRect {
    //        didSet {
    //            invalidateIntrinsicContentSize()
    //        }
    //    }

    //    override func updateConstraints() {
    //        super.updateConstraints()
    //        print("Called")
    //    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
        print("Called")
    }

    override var intrinsicContentSize: CGSize {
        print(bounds)
        return desiredSize
    }

}

class TimidView: UIView {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        print("AAAAa")
        return sizeThatFits(size)
    }

}
