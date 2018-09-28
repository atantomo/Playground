//
//  HighlightableSearchBar.swift
//  uq-customer-app-ios
//
//  Created by Tantomo Andrew on 24.07.18.
//  Copyright © 2018年 FAST RETAILING CO., LTD. All rights reserved.
//

import UIKit

final class HighlightableSearchBar: UIView {

    private struct Constants {
        static let clearButtonSideLength: CGFloat = 24.0
        static let activeBorderColor: UIColor = UIColor.purple
        static let inactiveBorderColor: UIColor = UIColor.lightGray
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldFrameView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cancelButtonContainerHideConstraint: NSLayoutConstraint!

    var textFieldClearButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupRightViewInitialLayout()
        textField.layoutIfNeeded()
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        hideCloseButton(animated: true)
        makeUnfocusAppearance()
    }

    func showCloseButton(animated: Bool = true) {
        cancelButtonContainerHideConstraint.priority = UILayoutPriority.defaultLow
        if animated {
            animateLayoutIfNeeded()
        } else {
            layoutIfNeeded()
        }
    }

    func hideCloseButton(animated: Bool = true) {
        cancelButtonContainerHideConstraint.priority = UILayoutPriority.defaultHigh
        if animated {
            animateLayoutIfNeeded()
        } else {
            layoutIfNeeded()
        }
    }

    func makeFocusAppearance() {
        textFieldFrameView.layer.borderColor = Constants.activeBorderColor.cgColor
    }

    func makeUnfocusAppearance() {
        textFieldFrameView.layer.borderColor = Constants.inactiveBorderColor.cgColor
    }

    func dummifySearchBar() {
        let dummyView = UIView()
        textField.inputView = dummyView
    }

    private func setup() {
        guard let nibView = Bundle.main.loadNibNamed("HighlightableSearchBar", owner: self, options: nil)?.first as? UIView else {
            return
        }
        nibView.frame = self.bounds
        addSubview(nibView)

        setupLayout()
        setupTextField()
        setupAccessories()
        setupTargets()
    }

    private func setupLayout() {
        cancelButtonContainerHideConstraint.priority = UILayoutPriority.defaultHigh
    }

    private func setupTextField() {
        textField.returnKeyType = UIReturnKeyType.search
    }

    private func setupAccessories() {
        let frame = CGRect(x: 0, y: 0, width: Constants.clearButtonSideLength, height: Constants.clearButtonSideLength)
        textFieldClearButton = UIButton(frame: frame)
        textFieldClearButton.setImage(#imageLiteral(resourceName: "icon-heart"), for: UIControlState.normal)

        textField.rightViewMode = UITextFieldViewMode.whileEditing
        textField.rightView = textFieldClearButton
    }

    private func setupTargets() {
        textField.addTarget(self, action: #selector(activateSearchBarAnimated), for: UIControlEvents.editingDidBegin)
        textField.addTarget(self, action: #selector(deactivateSearchBarAnimated), for: UIControlEvents.editingDidEnd)
        textFieldClearButton.addTarget(self, action: #selector(clearTextField), for: UIControlEvents.touchUpInside)
    }

    @objc
    private func activateSearchBarAnimated() {
        makeFocusAppearance()
        showCloseButton(animated: true)
    }

    @objc
    private func deactivateSearchBarAnimated() {
        makeUnfocusAppearance()
    }

    private func setupRightViewInitialLayout() {
        textField.rightView?.frame = textField.rightViewRect(forBounds: textField.bounds)
    }

    @objc
    private func clearTextField() {
        textField.text = ""
    }

    private func animateLayoutIfNeeded() {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

}
