//
//  SingleDigitViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SingleDigitViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!

    var inputCompletionHandler: ((String) -> Void)?

    private var textFieldComponents: [(baseView:UIView, textField: UITextField, underline: UIView, underlineHeightConstraint: NSLayoutConstraint)] = []
    private var editingChangeHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupContent(fieldCount: 6)
    }

    func setupContent(fieldCount: Int) {
        for textFieldComponent in textFieldComponents {
            textFieldComponent.baseView.removeFromSuperview()
        }
        textFieldComponents = []
        for index in 0..<fieldCount {
            let baseView = UIView()
            baseView.backgroundColor = .white

            let textField = OTPTextField()
            textField.borderStyle = .none
            textField.tintColor = .systemBlue
            textField.font = .systemFont(ofSize: 22.0)
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
            if #available(iOS 12.0, *) {
                textField.textContentType = .oneTimeCode
            }
            textField.deleteEmptyHandler = { [weak self] in
                self?.textFieldComponents[safe: index - 1]?.textField.text = ""
                self?.textFieldComponents[safe: index - 1]?.textField.becomeFirstResponder()
            }
            textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false

            let underline = UIView()
            underline.backgroundColor = .lightGray
            underline.translatesAutoresizingMaskIntoConstraints = false

            baseView.addSubview(textField)
            baseView.addSubview(underline)

            let heightConstraint = underline.heightAnchor.constraint(equalToConstant: 1)

            textFieldComponents.append((baseView, textField, underline, heightConstraint))

            stackView.addArrangedSubview(baseView)

            NSLayoutConstraint.activate([
                baseView.widthAnchor.constraint(equalToConstant: 32),
                baseView.heightAnchor.constraint(equalToConstant: 44),

                textField.topAnchor.constraint(equalTo: baseView.topAnchor),
                textField.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
                textField.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
                textField.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),

                underline.leadingAnchor.constraint(equalTo: baseView.leadingAnchor),
                underline.bottomAnchor.constraint(equalTo: baseView.bottomAnchor),
                underline.trailingAnchor.constraint(equalTo: baseView.trailingAnchor),

                heightConstraint
            ])
        }

        let touchResponderView = OTPTouchResponderView(frame: .zero)
        touchResponderView.tapHandler = { [weak self] in
            self?.startInput()

            var isTextFieldFirstResponder = false
            let components = self?.textFieldComponents ?? []
            for textFieldComponent in components {
                if textFieldComponent.textField.isFirstResponder {
                    isTextFieldFirstResponder = true
                    break
                }
            }
            var nextRespondingTextField = components.last?.textField
            for textFieldComponent in components {
                if textFieldComponent.textField.text?.isEmpty ?? true {
                    nextRespondingTextField = textFieldComponent.textField
                    break
                }
            }

            if isTextFieldFirstResponder {
                touchResponderView.showMenu(sender: touchResponderView)

            } else {
                touchResponderView.hideMenu(sender: touchResponderView)
                nextRespondingTextField?.becomeFirstResponder()
            }
        }
        touchResponderView.pasteHandler = { [weak self] in
            let pasteString = UIPasteboard.general.string ?? ""
            self?.insertString(string: pasteString, startIndex: 0)
        }

        touchResponderView.isUserInteractionEnabled = true
        touchResponderView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(touchResponderView, aboveSubview: stackView)
        NSLayoutConstraint.activate([
            touchResponderView.topAnchor.constraint(equalTo: stackView.topAnchor),
            touchResponderView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            touchResponderView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            touchResponderView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }

    private func startInput() {
        for textFieldComponent in textFieldComponents {
            textFieldComponent.underline.backgroundColor = .systemBlue
            textFieldComponent.underlineHeightConstraint.constant = 2
        }
    }

    private func endInput() {
        let text = textFieldComponents.map { component in
            return component.textField.text
        }
        .reduce("", { x, y in
            return x + (y ?? "")
        })
        inputCompletionHandler?(text)
        for textFieldComponent in textFieldComponents {
            textFieldComponent.underline.backgroundColor = .lightGray
            textFieldComponent.underlineHeightConstraint.constant = 1
        }
        view.endEditing(true)
    }

    private func insertString(string: String, startIndex: Int) {
        let lastTextFieldIndex = textFieldComponents.count - 1
        var cleanPasteString = ""
        for character in string {
            let string = String(character)
            if let _ = Int(string), !character.isWhitespace {
                cleanPasteString += string
            }
        }

        for (index, pasteCharacter) in cleanPasteString.enumerated() {
            let textFieldIndex = startIndex + index
            textFieldComponents[safe: textFieldIndex]?.textField.text =  String(pasteCharacter)
            if textFieldIndex == lastTextFieldIndex {
                endInput()
                break
            }
            let isLastCharacter = index == string.count - 1
            if isLastCharacter {
                textFieldComponents[safe: textFieldIndex + 1]?.textField.becomeFirstResponder()
            }
        }
    }

    @objc
    private func editingChanged(_ sender: Any) {
        editingChangeHandler?()
    }

}

extension SingleDigitViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFields = textFieldComponents.map { component in
            return component.textField
        }
        print(("ANDREWO", textField, range, string))

        let isMultipleCharacterString = string.count > 1
        if let currentTextFieldindex = textFields.firstIndex(of: textField) {
            editingChangeHandler = { [weak self] in
                if isMultipleCharacterString {
                    self?.insertString(string: string, startIndex: 0)
                } else {
                    self?.insertString(string: string, startIndex: currentTextFieldindex)
                }
            }
        }
        return true
    }

}

class OTPTouchResponderView: UIView {

    var tapHandler: (() -> Void)?
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

    @objc
    func handleTap(sender: Any?) {
        tapHandler?()
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

    private func commonInit() {
        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(showMenu))
        addGestureRecognizer(longPress)
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
