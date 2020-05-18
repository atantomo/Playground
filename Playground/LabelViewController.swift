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
//    @IBOutlet weak var atMentionLabel: UILabel!
    @IBOutlet weak var atMentionTextView: LinkInteractiveTextView!

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

//        atMentionTextView.text = "privacy policy andooo here's Namie style terms and condition"

        atMentionTextView.delegate = self
        atMentionTextView.isScrollEnabled = false
        atMentionTextView.tintColor = .lightGray

        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center

        let eulaString = "By joining, you agree to our Terms & Conditions & Privacy Policy. *Bonus Terms apply."
        let eulaAttributedString = NSMutableAttributedString(string: eulaString, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let termsConditionsRange = eulaAttributedString.mutableString.range(of: "Terms & Conditions")
        let privacyPolicyRange = eulaAttributedString.mutableString.range(of: "Privacy Policy")
        let bonusTermsRange = eulaAttributedString.mutableString.range(of: "Bonus Terms")

        eulaAttributedString.addAttribute(NSAttributedStringKey.link, value: "account://terms-conditions", range: termsConditionsRange)
        eulaAttributedString.addAttribute(NSAttributedStringKey.link, value: "account://privacy-policy", range: privacyPolicyRange)
        eulaAttributedString.addAttribute(NSAttributedStringKey.link, value: "account://bonus-terms", range: bonusTermsRange)

        eulaAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: termsConditionsRange)
        eulaAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: privacyPolicyRange)
        eulaAttributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: bonusTermsRange)


        atMentionTextView.attributedText = eulaAttributedString



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

extension LabelViewController: UITextViewDelegate {

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if (URL.scheme?.hasPrefix("ContactUs://"))! {

            return false //interaction not allowed
        }

        //*** Set storyboard id same as VC name
        print(URL.absoluteString)

        return false
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        view.endEditing(true)
    }

}


class LinkInteractiveTextView: UITextView {

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {

        guard let pos = closestPosition(to: point),
            let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: UITextLayoutDirection.left.rawValue) else {
                return false
        }

        let startIndex = offset(from: beginningOfDocument, to: range.start)
        let linkAttribute = attributedText.attribute(.link, at: startIndex, effectiveRange: nil)
        return linkAttribute != nil
    }

}
