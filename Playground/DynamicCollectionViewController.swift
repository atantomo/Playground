//
//  DynamicCollectionViewController.swift
//  Playground
//
//  Created by TANTOMO Andrew-Getty[FRJP:Digital Business Transformation Services](Tantomo Andrew) on 2018/08/14.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

struct DynamicCollectionCellModel {
    var firstText: String
    var secondText: String
    var thirdText: String
}

struct DynamicCollectionViewControllerData {
    static var seed: [String] = [
        "Love",
        "Love Love Love",
        "Love Love Love Love Love",
        "Love Love Love Love Love Love Love",
        "Love Love Love Love Love Love Love Love Love",
        "Love",
        "Love Love Love",
        "Love Love Love Love Love",
        "Love Love Love Love Love Love Love",
        "Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love",
        "Love",
        "Love Love Love",
        "Love Love Love Love Love",
        "Love Love Love Love Love Love Love",
        "Love Love Love Love Love Love Love Love Love",
        "Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love",
        "Love Love Love",
        "Love Love Love Love Love",
        "Love Love Love Love Love Love Love"
        ]

    static var seed2: [String] = [
        "Faith",
        "Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith Faith Faith",
        "Faith",
        "Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith",
        "Faith Faith Faith",
        "Faith Faith Faith Faith Faith",
        "Faith",
        "Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith Faith Faith",
        "Faith Faith Faith",
        "Faith Faith Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith"
    ]

    static var seed3: [String] = [
        "Hope",
        "Hope Hope Hope",
        "Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope Hope Hope",
        "Hope",
        "Hope Hope Hope",
        "Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope",
        "Hope",
        "Hope Hope Hope",
        "Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope",
        "Hope Hope Hope",
        "Hope Hope Hope Hope Hope",
        "Hope Hope Hope Hope Hope Hope Hope"
    ]

    static var data: [DynamicCollectionCellModel] = {
        var d = [DynamicCollectionCellModel]()
        for i in 0..<DynamicCollectionViewControllerData.seed.count {
            let model = DynamicCollectionCellModel(firstText: DynamicCollectionViewControllerData.seed[i], secondText: DynamicCollectionViewControllerData.seed2[i], thirdText: DynamicCollectionViewControllerData.seed3[i])
            d.append(model)
        }
        return d
    }()
}

class DynamicCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: DynamicCollectionViewLayout!

    var collectionData: [DynamicCollectionCellModel] = DynamicCollectionViewControllerData.data

    override func viewDidLoad() {
        collectionViewLayout.models = collectionData

        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowRadius = 2.0
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        collectionView.layer.shadowOpacity = 0.3

        collectionView.register(UINib(nibName: "CuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "heart")

        collectionView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell(sender:)), name: NotificationName.DeleteCell, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.DeleteCell, object: nil)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let startAddIndex = collectionData.count

        collectionData.append(contentsOf: DynamicCollectionViewControllerData.data)
        collectionViewLayout.models = collectionData

        let endAddIndex = collectionData.count - 1

        var indexes = [Int]()
        for i in startAddIndex...endAddIndex {
            indexes.append(i)
        }
        let indexPaths = indexes.map{ index in
            return IndexPath(item: index, section: 0)
        }
        collectionView.insertItems(at: indexPaths)
        collectionViewLayout.invalidateLayout()
    }

    func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin],
                                     attributes: [NSAttributedStringKey.font: font],
                                     context: nil).size
        return size.height
    }

    @objc func deleteCell(sender: Notification) {

        let button = sender.object as! UIButton
        let position = button.superview!.convert(button.center, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: position) {

            collectionData.remove(at: indexPath.row)
            collectionViewLayout.models = collectionData
            
            collectionView.deleteItems(at: [indexPath])
            collectionViewLayout.invalidateLayout()
        }
    }
}

extension DynamicCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "heart", for: indexPath)
        guard let cell = dequeuedCell as? CuteCollectionViewCell else {
            return dequeuedCell
        }
        cell.theLabel.text = collectionData[indexPath.row].firstText
        cell.theLabel2.text = collectionData[indexPath.row].secondText
        cell.theLabel3.text = collectionData[indexPath.row].thirdText
        cell.setNeedsLayout()
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let dequeuedView = collectionView.dequeueReusableSupplementaryView(ofKind: "decoration", withReuseIdentifier: "pillar", for: indexPath)
//        return dequeuedView
//    }
}
