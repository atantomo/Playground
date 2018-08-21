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
        let labelHeight = TextHeightCalculator.getMaxHeight(for: [
            model.firstText.makeCalculableText(with: theLabel.font, width: labelWidth)
            ])

        let label2Width = (width - label2SidePadding) / 2
        let bottomLabelHeight = TextHeightCalculator.getMaxHeight(for: [
            model.secondText.makeCalculableText(with: theLabel2.font, width: label2Width),
            model.thirdText.makeCalculableText(with: theLabel3.font, width: label2Width)
            ])

        let sum = imageHeight + labelHeight + bottomLabelHeight + cellPaddingHeight
        return sum
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: theButton)
    }
}

struct HeightCalculableText {
    let text: String
    let font: UIFont
    let width: CGFloat
}

struct TextHeightCalculator {

    static func getMaxHeight(for models: [HeightCalculableText]) -> CGFloat {
        let heights = models.map { model in
            return getHeight(for: model)
        }
        let maxHeight = heights.max() ?? 0.0
        return maxHeight
    }

    private static func getHeight(for model: HeightCalculableText) -> CGFloat {
        let size = model.text.boundingRect(with: CGSize(width: model.width, height: CGFloat.greatestFiniteMagnitude),
                                           options: [.usesLineFragmentOrigin],
                                           attributes: [NSAttributedStringKey.font: model.font],
                                           context: nil).size
        let ceilHeight = ceil(size.height)
        return ceilHeight
    }
}

extension String {

    func makeCalculableText(with font: UIFont, width: CGFloat) -> HeightCalculableText {
        return HeightCalculableText(text: self, font: font, width: width)
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
