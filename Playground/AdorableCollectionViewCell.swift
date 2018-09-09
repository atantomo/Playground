//
//  AdorableCollectionViewCell.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/14.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

protocol HeightCalculable {
    func heightForWidth(width: CGFloat, model: DynamicCollectionCellModel) -> CGFloat
}

class AdorableCollectionViewCell: UICollectionViewCell, HeightCalculable {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var theLabel2: UILabel!
    @IBOutlet weak var theLabel3: UILabel!
    @IBOutlet weak var theButton: UIButton!

    @IBOutlet var imageAspectConstraint: NSLayoutConstraint!
    @IBOutlet var imageWidthConstraint: NSLayoutConstraint!

    @IBOutlet var imageVerticalConstraints: [NSLayoutConstraint]!
    @IBOutlet var heightCalculationConstraints: [NSLayoutConstraint]!
    @IBOutlet var imageSideConstraints: [NSLayoutConstraint]!
    @IBOutlet var labelSideConstraints: [NSLayoutConstraint]!
    @IBOutlet var label2SideConstraints: [NSLayoutConstraint]!

    lazy var imageWidth: CGFloat = {
        return self.imageWidthConstraint.constant
    }()

    lazy var imageSidePadding: CGFloat = {
        return self.imageSideConstraints.getConstantsSum()
    }()

    lazy var imageVerticalPadding: CGFloat = {
        return self.imageVerticalConstraints.getConstantsSum()
    }()

    lazy var cellPaddingHeight: CGFloat = {
        return self.heightCalculationConstraints.getConstantsSum()
    }()

    lazy var labelSidePadding: CGFloat = {
        return self.labelSideConstraints.getConstantsSum()
    }()

    lazy var label2SidePadding: CGFloat = {
        return self.label2SideConstraints.getConstantsSum()
    }()

    override var isHighlighted: Bool {

        didSet {
            if (isHighlighted) {
                container.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            }
            else {
                container.backgroundColor = UIColor.white
            }
        }
    }

    override var isSelected: Bool {

        didSet {
            if (isSelected) {
                container.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            }
            else {
                container.backgroundColor = UIColor.white
            }
        }
    }

    func heightForWidth(width: CGFloat, model: DynamicCollectionCellModel) -> CGFloat {
        let imageHeight = imageWidth * imageAspectConstraint.multiplier + imageVerticalPadding

        let leftSum = imageHeight

        let labelWidth = width - labelSidePadding - imageWidth - imageSidePadding
        let labelHeight = TextHeightCalculator.getMaxHeight(for: [
            model.firstText.makeCalculableText(with: theLabel.font, width: labelWidth)
            ])

        let label2Width = (width - label2SidePadding - imageWidth - imageSidePadding) / 2
        let bottomLabelHeight = TextHeightCalculator.getMaxHeight(for: [
            model.secondText.makeCalculableText(with: theLabel2.font, width: label2Width),
            model.thirdText.makeCalculableText(with: theLabel3.font, width: label2Width)
            ])

        let rightSum = labelHeight + bottomLabelHeight + cellPaddingHeight
        return max(leftSum, rightSum)
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: theButton)
    }
}
