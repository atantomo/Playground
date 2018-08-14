//
//  CuteCollectionViewCell.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/14.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class CuteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var theLabel: UILabel!

    @IBOutlet var heightCalculationConstraints: [NSLayoutConstraint]!
    @IBOutlet var labelSideConstraints: [NSLayoutConstraint]!

    lazy var cellPaddingHeight: CGFloat = {
        return self.getConstantsSum(constraints: self.heightCalculationConstraints)
    }()

    lazy var labelSidePadding: CGFloat = {
        return self.getConstantsSum(constraints: self.heightCalculationConstraints)
    }()

    func heightForWidth(width: CGFloat, text: String) -> CGFloat {
        let imageHeight = width

        let labelWidth = width - labelSidePadding
        let labelHeight = getTextHeight(text: text, font: theLabel.font, width: labelWidth)

        return imageHeight + labelHeight + cellPaddingHeight
    }

    func getConstantsSum(constraints: [NSLayoutConstraint]) -> CGFloat {
        let sum = constraints.map { constraint in
            return constraint.constant
            }.reduce(0) { lhs, rhs in
                return lhs + rhs
        }
        return sum
    }

    func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin],
                                     attributes: [NSFontAttributeName: font],
                                     context: nil).size
        return size.height
    }
}
