//
//  TextHeightCalculator.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/09/11.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

struct TextHeightCalculator {

    typealias VariableHeightText = (text: String, font: UIFont?, width: CGFloat)

    static func getHeight(for heightCalculableText: VariableHeightText) -> CGFloat {
        let text = heightCalculableText.text
        let widthConstrainedSize = CGSize(width: heightCalculableText.width, height: CGFloat.greatestFiniteMagnitude)
        var attributes: [NSAttributedStringKey: Any]? = nil
        if let font = heightCalculableText.font {
            attributes = [NSAttributedStringKey.font: font]
        }

        let rect = text.boundingRect(with: widthConstrainedSize, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil)
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
