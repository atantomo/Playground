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
    @IBOutlet weak var theLabel2: UILabel!
    @IBOutlet weak var theLabel3: UILabel!
    @IBOutlet weak var theButton: UIButton!

    @IBOutlet var imageAspectConstraint: NSLayoutConstraint!
    @IBOutlet var heightCalculationConstraints: [NSLayoutConstraint]!
    @IBOutlet var labelSideConstraints: [NSLayoutConstraint]!
    @IBOutlet var label2SideConstraints: [NSLayoutConstraint]!

    lazy var cellPaddingHeight: CGFloat = {
        return self.heightCalculationConstraints.getConstantsSum()
    }()

    lazy var labelSidePadding: CGFloat = {
        return self.labelSideConstraints.getConstantsSum()
    }()

    lazy var label2SidePadding: CGFloat = {
        return self.label2SideConstraints.getConstantsSum()
    }()

    func heightForWidth(width: CGFloat, model: DynamicCollectionCellModel) -> CGFloat {
        let imageHeight = width * imageAspectConstraint.multiplier

        let labelWidth = width - labelSidePadding
        let labelHeight = getTextHeight(text: model.firstText, font: theLabel.font, width: labelWidth)

        let label2Width = (width - label2SidePadding) / 2
        let label2Height = getTextHeight(text: model.secondText, font: theLabel2.font, width: label2Width)

        let label3Width = (width - label2SidePadding) / 2
        let label3Height = getTextHeight(text: model.thirdText, font: theLabel3.font, width: label3Width)

        let bottomLabelHeight = max(label2Height, label3Height)

        let sum = imageHeight + labelHeight + bottomLabelHeight + cellPaddingHeight
        return sum
    }

    func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin],
                                     attributes: [NSAttributedStringKey.font: font],
                                     context: nil).size
        let ceilHeight = ceil(size.height)
        return ceilHeight
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: theButton)
    }
}

extension Array where Element: NSLayoutConstraint {

    func getConstantsSum() -> CGFloat {
        let sum = map { constraint in
            return constraint.constant
            }
            .reduce(0) { lhs, rhs in
                return lhs + rhs
        }
        return sum
    }
}
