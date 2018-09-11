//
//  TextHeightCalculator.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/09/11.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

struct VariableHeightText {
    let text: String
    let font: UIFont
    let width: CGFloat
}

struct TextHeightCalculator {

    static func getHeight(for heightCalculableText: VariableHeightText) -> CGFloat {
        let text = heightCalculableText.text
        let widthConstrainedSize = CGSize(width: heightCalculableText.width, height: CGFloat.greatestFiniteMagnitude)
        let font = heightCalculableText.font

        let rect = text.boundingRect(with: widthConstrainedSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
        let ceilHeight = ceil(rect.size.height)
        return ceilHeight
    }

    static func getMaxHeight(for heightCalculableTexts: [VariableHeightText]) -> CGFloat {
        let heights = heightCalculableTexts.map { heightCalculableText in
            return getHeight(for: heightCalculableText)
        }
        let maxHeight = heights.max() ?? 0.0
        return maxHeight
    }

}
