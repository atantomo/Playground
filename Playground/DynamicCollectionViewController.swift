//
//  DynamicCollectionViewController.swift
//  Playground
//
//  Created by TANTOMO Andrew-Getty[FRJP:Digital Business Transformation Services](Tantomo Andrew) on 2018/08/14.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

struct DynamicCollectionViewControllerData {
    static let data: [String] = [
        "Love",
        "Love Love Love",
        "Love Love Love Love Love",
        "Love Love Love Love Love Love Love",
        "Love Love Love Love Love Love Love Love Love",
        ]
}

class DynamicCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        for i in stride(from: 0, to: 5, by: 2) {
            print(i)
        }
//        collectionView.removeFromSuperview()
////        let h1 = measurementModel.heightForWidth(width: 137, text: data[0])
////        let h2 = measurementModel.heightForWidth(width: 137, text: data[1])
//        let h3 = measurementModel.heightForWidth(width: 137, text: DynamicCollectionViewControllerData.data[2])
//
////        print(h1)
////        print(h2)
//        print(h3)
//
//        measurementModel.theLabel.text = DynamicCollectionViewControllerData.data[2]
////        measurementModel.translatesAutoresizingMaskIntoConstraints = false
//
//        let v = measurementModel.subviews[0]
//        v.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(v)
//
//        NSLayoutConstraint.activate([
//            v.widthAnchor.constraint(equalToConstant: 137),
//            v.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            v.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            ])
    }

    lazy var measurementModel: CuteCollectionViewCell = {
        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
            fatalError()
        }
        return view
    }()
}

extension DynamicCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DynamicCollectionViewControllerData.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "heart", for: indexPath)
        guard let cell = dequeuedCell as? CuteCollectionViewCell else {
            return dequeuedCell
        }
        cell.theLabel.text = DynamicCollectionViewControllerData.data[indexPath.row]
        return cell
    }
}
