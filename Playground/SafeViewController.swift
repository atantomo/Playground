//
//  SafeViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SafeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            let v = UIView()
            let v2 = UIView()
            let miniVC = UIViewController()
            miniVC.loadView()
            let miniV = miniVC.view!

            navigationController?.addChildViewController(miniVC)

            v.translatesAutoresizingMaskIntoConstraints = false
            v2.translatesAutoresizingMaskIntoConstraints = false
            miniV.translatesAutoresizingMaskIntoConstraints = false

            v.backgroundColor = .purple
            v2.backgroundColor = .yellow
            miniV.backgroundColor = .orange
            view.addSubview(v)
//            view.addSubview(miniV)

//            let vi1 = v.safeAreaInsets
//            print(vi1)
//
//            NSLayoutConstraint.activate([
//                v.topAnchor.constraint(equalTo: view.topAnchor),
//                v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//                v.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//                v.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//            ])
//
//            let vi2 = v.safeAreaInsets
//            print(vi2)
//
//            v.removeFromSuperview()
//            miniV.removeFromSuperview()

            navigationController?.view.addSubview(v)
            navigationController?.view.addSubview(v2)
            navigationController?.view.addSubview(miniV)

            NSLayoutConstraint.activate([
                v.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                v.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                v.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                v2.topAnchor.constraint(equalTo: v.topAnchor),
                v2.leadingAnchor.constraint(equalTo: v.leadingAnchor),
                v2.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -10),
                v2.trailingAnchor.constraint(equalTo: v.trailingAnchor),

                miniV.topAnchor.constraint(equalTo: v2.safeAreaLayoutGuide.topAnchor),
                miniV.leadingAnchor.constraint(equalTo: v2.safeAreaLayoutGuide.leadingAnchor),
                miniV.bottomAnchor.constraint(equalTo: v2.safeAreaLayoutGuide.bottomAnchor),
                miniV.trailingAnchor.constraint(equalTo: v2.safeAreaLayoutGuide.trailingAnchor)
            ])
            
            miniVC.didMove(toParentViewController: navigationController!)



            let vi3 = v2.safeAreaInsets
            print(vi3)

            navigationController?.view.setNeedsLayout()
            navigationController?.view.layoutIfNeeded()

            let vi4 = v2.safeAreaInsets
            print(vi4)

//            print(view.safeAreaInsets)
        } else {
            // Fallback on earlier versions
        }
    }

}
