//
//  SingleDigitViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SingleDigitViewController: UIViewController {

    @IBOutlet weak var firstTextField: OTPTextField!
    @IBOutlet weak var secondTextField: OTPTextField!
    @IBOutlet weak var thirdTextField: OTPTextField!
    @IBOutlet weak var fourthTextField: OTPTextField!
    @IBOutlet weak var fifthTextField: OTPTextField!
    @IBOutlet weak var sixthTextField: OTPTextField!
    @IBOutlet weak var touchResponderView: OTPButton!

    @IBOutlet weak var firstTextFieldUnderline: UIView!
    @IBOutlet weak var secondTextFieldUnderline: UIView!
    @IBOutlet weak var thirdTextFieldUnderline: UIView!
    @IBOutlet weak var fourthTextFieldUnderline: UIView!
    @IBOutlet weak var fifthTextFieldUnderline: UIView!
    @IBOutlet weak var sixthTextFieldUnderline: UIView!

    @IBOutlet weak var firstUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fifthUnderlineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sixthUnderlineHeightConstraint: NSLayoutConstraint!

    lazy var orderedTextFields: [UITextField] = [
        firstTextField,
        secondTextField,
        thirdTextField,
        fourthTextField,
        fifthTextField,
        sixthTextField
    ]

    var editingChangeHandler: (() -> Void)?
    lazy var inputCompletionHandler: (() -> Void)? = { [weak self] in
        self?.firstUnderlineHeightConstraint.constant = 1
        self?.secondUnderlineHeightConstraint.constant = 1
        self?.thirdUnderlineHeightConstraint.constant = 1
        self?.fourthUnderlineHeightConstraint.constant = 1
        self?.fifthUnderlineHeightConstraint.constant = 1
        self?.sixthUnderlineHeightConstraint.constant = 1

        self?.firstTextFieldUnderline.backgroundColor = .lightGray
        self?.secondTextFieldUnderline.backgroundColor = .lightGray
        self?.thirdTextFieldUnderline.backgroundColor = .lightGray
        self?.fourthTextFieldUnderline.backgroundColor = .lightGray
        self?.fifthTextFieldUnderline.backgroundColor = .lightGray
        self?.sixthTextFieldUnderline.backgroundColor = .lightGray
        self?.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstTextField.delegate = self
        secondTextField.delegate = self
        thirdTextField.delegate = self
        fourthTextField.delegate = self
        fifthTextField.delegate = self
        sixthTextField.delegate = self

        secondTextField.deleteEmptyHandler = { [weak self] in
            self?.firstTextField.text = ""
            self?.firstTextField.becomeFirstResponder()
        }
        thirdTextField.deleteEmptyHandler = { [weak self] in
            self?.secondTextField.text = ""
            self?.secondTextField.becomeFirstResponder()
        }
        fourthTextField.deleteEmptyHandler = { [weak self] in
            self?.thirdTextField.text = ""
            self?.thirdTextField.becomeFirstResponder()
        }
        fifthTextField.deleteEmptyHandler = { [weak self] in
            self?.fourthTextField.text = ""
            self?.fourthTextField.becomeFirstResponder()
        }
        sixthTextField.deleteEmptyHandler = { [weak self] in
            self?.fifthTextField.text = ""
            self?.fifthTextField.becomeFirstResponder()
        }

        touchResponderView.pasteHandler = { [weak self] in
            guard let vc = self else {
                return
            }
            let pasteString = UIPasteboard.general.string ?? ""
            let lastTextFieldIndex = vc.orderedTextFields.count - 1

            var cleanPasteString = ""
            for pasteCharacter in pasteString {
                let string = String(pasteCharacter)
                if let _ = Int(string) {
                    cleanPasteString += string
                }
            }

            for (index, pasteCharacter) in cleanPasteString.enumerated() {
                self?.orderedTextFields[safe: index]?.text =  String(pasteCharacter)
                if index == lastTextFieldIndex {
                    self?.inputCompletionHandler?()
                    break
                }
                let isLastCharacter = index == pasteString.count - 1
                if isLastCharacter {
                    self?.orderedTextFields[safe: index + 1]?.becomeFirstResponder()
                }
            }
        }
    }

    @IBAction func fieldButtonTapped(_ sender: Any) {
        firstUnderlineHeightConstraint.constant = 2
        secondUnderlineHeightConstraint.constant = 2
        thirdUnderlineHeightConstraint.constant = 2
        fourthUnderlineHeightConstraint.constant = 2
        fifthUnderlineHeightConstraint.constant = 2
        sixthUnderlineHeightConstraint.constant = 2

        firstTextFieldUnderline.backgroundColor = .purple
        secondTextFieldUnderline.backgroundColor = .purple
        thirdTextFieldUnderline.backgroundColor = .purple
        fourthTextFieldUnderline.backgroundColor = .purple
        fifthTextFieldUnderline.backgroundColor = .purple
        sixthTextFieldUnderline.backgroundColor = .purple

        if firstTextField.isFirstResponder ||
            secondTextField.isFirstResponder ||
            thirdTextField.isFirstResponder ||
            fourthTextField.isFirstResponder ||
            fifthTextField.isFirstResponder ||
            sixthTextField.isFirstResponder {
            touchResponderView.showMenu(sender: touchResponderView)
            return
        }

        touchResponderView.hideMenu(sender: touchResponderView)
        let firstText = firstTextField.text ?? ""
        let secondText = secondTextField.text ?? ""
        let thirdText = thirdTextField.text ?? ""
        let fourthText = fourthTextField.text ?? ""
        let fifthText = fifthTextField.text ?? ""

        if firstText == "" {
            firstTextField.becomeFirstResponder()

        } else if secondText == "" {
            secondTextField.becomeFirstResponder()

        } else if thirdText == "" {
            thirdTextField.becomeFirstResponder()

        } else if fourthText == "" {
            fourthTextField.becomeFirstResponder()

        } else if fifthText == "" {
            fifthTextField.becomeFirstResponder()

        } else {
            sixthTextField.becomeFirstResponder()
        }
    }

    @IBAction func editingChangeHandler(_ sender: Any) {
        editingChangeHandler?()
    }

}

extension SingleDigitViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        var isDeleting = string.isEmpty
        // add range: (location: index, length: 0)
        // delete range: (location: index (after delete), length: 1)

        var movement = string.count
        let totalTextFieldCount = orderedTextFields.count
        var nextIndex = 0
        if let index = orderedTextFields.firstIndex(of: textField) {
            nextIndex = index + movement
            //            print(nextIndex)
            //            print(nextIndex)
            editingChangeHandler = { [weak self] in
                if !isDeleting && index == totalTextFieldCount - 1 {
                    self?.inputCompletionHandler?()
                } else {
                    self?.orderedTextFields[safe: nextIndex]?.becomeFirstResponder()
                }
            }
            //            textField.text = string
            //            orderedTextFields[nextIndex].becomeFirstResponder()
            //            return false
        }
        //        switch textField {
        //        case firstTextField:
        //            if
        //
        //        case secondTextField:
        //            <#code#>
        //
        //        case thirdTextField:
        //
        //        case fourthTextField:
        //
        //        case fifthTextField:
        //
        //        case sixthTextField:
        //
        //        default:
        //            break
        //        }
        return true
    }

}

class OTPButton: UIButton {

    var pasteHandler: (() -> Void)?

    override public var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func paste(_ sender: Any?) {
        pasteHandler?()
        UIMenuController.shared.setMenuVisible(false, animated: true)
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(paste(_:)))
    }

    private func commonInit() {
        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showMenu(sender:)))
        addGestureRecognizer(longPress)
    }

    @objc
    func showMenu(sender: Any?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }

    @objc
    func hideMenu(sender: Any?) {
        let menu = UIMenuController.shared
        if menu.isMenuVisible {
            menu.setMenuVisible(false, animated: true)
        }
    }

}

class OTPTextField: UITextField {

    var deleteEmptyHandler: (() -> Void)?

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func deleteBackward() {
        let preDeleteText = text

        super.deleteBackward()

        let postDeleteText = text
        let isDeletingEmpty = (preDeleteText?.isEmpty ?? true) && (postDeleteText?.isEmpty ?? true)
        if isDeletingEmpty {
            deleteEmptyHandler?()
        }
    }

}
