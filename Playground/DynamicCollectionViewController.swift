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
//        "Love Love Love Love Love Love Love",
//        "Love Love Love Love Love Love Love Love Love",
//        "Love",
//        "Love Love Love",
//        "Love Love Love Love Love",
//        "Love Love Love Love Love Love Love",
//        "Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love",
//        "Love",
//        "Love Love Love",
//        "Love Love Love Love Love",
//        "Love Love Love Love Love Love Love",
//        "Love Love Love Love Love Love Love Love Love",
//        "Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love Love",
//        "Love Love Love",
//        "Love Love Love Love Love",
//        "Love Love Love Love Love Love Love"
        ]

    static var seed2: [String] = [
        "Faith",
        "Faith Faith Faith",
        "Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith Faith Faith",
//        "Faith",
//        "Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith",
//        "Faith Faith Faith",
//        "Faith Faith Faith Faith Faith",
//        "Faith",
//        "Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith Faith Faith",
//        "Faith Faith Faith",
//        "Faith Faith Faith Faith Faith",
//        "Faith Faith Faith Faith Faith Faith Faith"
    ]

    static var seed3: [String] = [
        "Hope",
        "Hope Hope Hope",
        "Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope Hope Hope",
//        "Hope",
//        "Hope Hope Hope",
//        "Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope",
//        "Hope",
//        "Hope Hope Hope",
//        "Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope Hope",
//        "Hope Hope Hope",
//        "Hope Hope Hope Hope Hope",
//        "Hope Hope Hope Hope Hope Hope Hope"
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

    @IBOutlet weak var buttonGroupContainer: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    lazy var collectionViewGridLayout: DynamicCollectionViewLayout<CuteCollectionViewCell> = {
        let layout = DynamicCollectionViewLayout<CuteCollectionViewCell>()
        layout.measurementCell = cuteMeasurementCell
        layout.portraitColumnCount = 2
        layout.landscapeColumnCount = 4
        layout.horizontalSeparatorHeight = 0
        return layout
    }()

    lazy var collectionViewListLayout: DynamicCollectionViewLayout<AdorableCollectionViewCell> = {
        let layout = DynamicCollectionViewLayout<AdorableCollectionViewCell>()
        layout.measurementCell = adorableMeasurementCell
        layout.portraitColumnCount = 1
        layout.landscapeColumnCount = 2
        return layout
    }()

    var identifier: String = "cute"

    var collectionData: ChangeTracerArray<DynamicCollectionCellModel> = ChangeTracerArray() {
        didSet {
            collectionViewGridLayout.models = collectionData
            collectionViewListLayout.models = collectionData
        }
    }

    lazy var cuteMeasurementCell: CuteCollectionViewCell = {
        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
        guard let cell = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
            fatalError()
        }
        return cell
    }()

    lazy var adorableMeasurementCell: AdorableCollectionViewCell = {
        let nib = UINib(nibName: "AdorableCollectionViewCell", bundle: nil)
        guard let cell = nib.instantiate(withOwner: self, options: nil).first as? AdorableCollectionViewCell else {
            fatalError()
        }
        return cell
    }()


    override func viewDidLoad() {
        collectionData = ChangeTracerArray(DynamicCollectionViewControllerData.data)
        collectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        collectionView.allowsMultipleSelection = true

        collectionView.setCollectionViewLayout(collectionViewGridLayout, animated: false)

        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowRadius = 2.0
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        collectionView.layer.shadowOpacity = 0.3

        collectionView.register(UINib(nibName: "CuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cute")
        collectionView.register(UINib(nibName: "AdorableCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "adorable")

        collectionView.dataSource = self

        buttonGroupContainer.layer.masksToBounds = false
        buttonGroupContainer.layer.shadowRadius = 2.0
        buttonGroupContainer.layer.shadowColor = UIColor.lightGray.cgColor
        buttonGroupContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
        buttonGroupContainer.layer.shadowOpacity = 0.3

        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell(sender:)), name: NotificationName.DeleteCell, object: nil)

        //        let now = Date()
        //
        //        let formatter = DateFormatter()
        //        formatter.locale = Locale(identifier: "JP")
        //        formatter.timeZone = TimeZone(identifier: "Japan/Tokyo")
        //        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        //        let sevenDaysAgo = now.addingTimeInterval(-7*24*60*60)
        //
        //        let str = formatter.string(from: sevenDaysAgo)
        //        print(str)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.DeleteCell, object: nil)
    }

    @IBAction func gridButtonTapped(_ sender: UIButton) {
        identifier = "cute"
        UIView.performWithoutAnimation {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
        collectionView.setCollectionViewLayout(collectionViewGridLayout, animated: true)
    }

    @IBAction func listButtonTapped(_ sender: UIButton) {
        identifier = "adorable"
        UIView.performWithoutAnimation {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }    
        collectionView.setCollectionViewLayout(collectionViewListLayout, animated: true)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        let newData = DynamicCollectionViewControllerData.data
        collectionData.append(contentsOf: newData)

        guard case let .insert(indexes) = collectionData.latestChange else {
            return
        }
        let indexPaths = indexes.map { index in
            return IndexPath(item: index, section: 0)
        }
        collectionView.insertItems(at: indexPaths)
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        guard let indexPaths = collectionView.indexPathsForSelectedItems else {
            return
        }
        let indexes = indexPaths.map { indexPath in
            return indexPath.item
        }
        collectionData.removeMulti(at: indexes)
        collectionView.deleteItems(at: indexPaths)
    }

    @objc func deleteCell(sender: Notification) {
        guard let button = sender.object as? UIButton,
            let position = button.superview?.convert(button.center, to: collectionView),
            let indexPath = collectionView.indexPathForItem(at: position) else {
                return
        }
        collectionData.removeMulti(at: [indexPath.item])
        collectionView.deleteItems(at: [indexPath])
    }
}

extension DynamicCollectionViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        if let cell = dequeuedCell as? CuteCollectionViewCell {
            cell.theLabel.text = collectionData[indexPath.row].firstText
            cell.theLabel2.text = collectionData[indexPath.row].secondText
            cell.theLabel3.text = collectionData[indexPath.row].thirdText

            return cell
        }
        if let cell = dequeuedCell as? AdorableCollectionViewCell {
            cell.theLabel.text = collectionData[indexPath.row].firstText
            cell.theLabel2.text = collectionData[indexPath.row].secondText
            cell.theLabel3.text = collectionData[indexPath.row].thirdText

            return cell
        }
        return dequeuedCell
    }

}
