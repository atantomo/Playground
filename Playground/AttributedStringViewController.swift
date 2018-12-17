//
//  AttributedStringViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/10/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class AttributedStringViewController: UIViewController {

    @IBOutlet var attributedStringLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabel()
    }
    override func viewDidLayoutSubviews() {
        print(attributedStringLabel.constraints)
        super.viewDidLayoutSubviews()
    }

    private func setupLabel() {
        let redAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.red
        ]
        let orangeAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.orange
        ]
        let yellowAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.yellow
        ]
        let greenAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.green
        ]
        let grayAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.lightGray
        ]

        let title = NSMutableAttributedString(string: "pow", attributes: redAttribute)
        let title2 = NSAttributedString(string: "int", attributes: orangeAttribute)
        let title3 = NSAttributedString(string: "def", attributes: yellowAttribute)
        let title4 = NSAttributedString(string: "spd", attributes: greenAttribute)
        let separator = NSAttributedString(string: "・", attributes: grayAttribute)

        let attributedString = joinAttributedString(elements: [title, title2, title3, title4], separator: separator)

        title.append(title2)
//         ([title] + [title]).jo

//        ["a"].joined(separator: <#T##Sequence#>)

        attributedStringLabel.attributedText = attributedString
    }

    private func joinAttributedString(elements: [NSAttributedString], separator: NSAttributedString) -> NSAttributedString {
        let concatAttributedString = NSMutableAttributedString()
        for (index, element) in elements.enumerated() {
            if index > 0 {
                concatAttributedString.append(separator)
            }
            concatAttributedString.append(element)
        }
        return concatAttributedString
    }

    private func trySwift() {

        let s = "Taylor Swift"
        if case Pattern("Swift") = s {
            print("\(String(reflecting: s)) contains \"Swift\"")
        }
        //
    }

}

struct Pattern {
    let s: String
    init(_ s: String) { self.s = s }
}

func ~=(pattern: Pattern, value: String) -> Bool {
    return value.range(of: pattern.s) != nil
}
