//
//  PresenterViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/10/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class PresenterViewController: UIViewController {

    var presenter: UIViewController?
    var toPresent: UIViewController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter = presentingViewController
    }

    @IBAction func teleportButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "presenterReplacer") else {
            return
        }
        toPresent = vc

        let backButton = UIButton(frame: CGRect.zero)
        backButton.layer.cornerRadius = 4.0
        backButton.layer.borderColor = UIColor.lightGray.cgColor
        backButton.layer.borderWidth = 1.0
        backButton.backgroundColor = UIColor.white
        backButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        backButton.setTitle("Back", for: UIControlState.normal)
        backButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16.0),
            backButton.topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant: 64.0)
            ])

        let presenter = presentingViewController
        presentingViewController?.dismiss(animated: false, completion: {
            presenter?.present(vc, animated: false)
        })
    }

    @objc
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}


class PresenterReplacerViewController: UIViewController {

    @IBAction func teleportButtonTapped(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "presenter") else {
            return
        }

        let backButton = UIButton(frame: CGRect.zero)
        backButton.layer.cornerRadius = 4.0
        backButton.layer.borderColor = UIColor.lightGray.cgColor
        backButton.layer.borderWidth = 1.0
        backButton.backgroundColor = UIColor.white
        backButton.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        backButton.setTitle("Back", for: UIControlState.normal)
        backButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        vc.view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 16.0),
            backButton.topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant: 64.0)
            ])

        let presenter = presentingViewController
        presentingViewController?.dismiss(animated: false, completion: {
            presenter?.present(vc, animated: false)
        })
    }

    @objc
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
