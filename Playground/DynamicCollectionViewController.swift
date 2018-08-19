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
//        "Love Love Love Love Love Love Love"
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
        //        "Faith Faith Faith Faith Faith Faith Faith"
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
        //        "Hope Hope Hope Hope Hope Hope Hope"
    ]

    static var data: [DynamicCollectionCellModel] = {
        var d = [DynamicCollectionCellModel]()
        for i in 0..<DynamicCollectionViewControllerData.seed.count {
            let model = DynamicCollectionCellModel(firstText: DynamicCollectionViewControllerData.seed[i], secondText: DynamicCollectionViewControllerData.seed2[i], thirdText: DynamicCollectionViewControllerData.seed3[i])
            d  .append(model)
        }
        return d
    }()
}

class DynamicCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: DynamicCollectionViewLayout!

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "CuteCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "heart")

//        collectionView.register(PillarCollectionReusableView.self, forSupplementaryViewOfKind: "decoration", withReuseIdentifier: "pillar")

//        let n = UINib(nibName: "PillarCollectionReusableView", bundle: nil).instantiate(withOwner: self, options: nil).first
//        print(n)
        collectionView.dataSource = self

        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell(sender:)), name: NotificationName.DeleteCell, object: nil)

//        let heights = DynamicCollectionViewControllerData.data.map { d in
//            self.getTextHeight(text: d, font: UIFont.systemFont(ofSize: 17.0), width: 155)
//
//        }
//        print(heights)
//        print(heights)


//        for i in stride(from: 0, to: 5, by: 2) {
//            print(i)
//        }
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

//    lazy var measurementModel: CuteCollectionViewCell = {
//        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
//        guard let view = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
//            fatalError()
//        }
//        return view
//    }()

    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.DeleteCell, object: nil)
    }

    func getTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let size = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin],
                                     attributes: [NSFontAttributeName: font],
                                     context: nil).size
        return size.height
    }

    func deleteCell(sender: Notification) {

        let button = sender.object as! UIButton
        let position = button.superview!.convert(button.center, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: position) {

            DynamicCollectionViewControllerData.data.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
//            collectionViewLayout.invalidateLayout()
        }
    }
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
        cell.theLabel.text = DynamicCollectionViewControllerData.data[indexPath.row].firstText
        cell.theLabel2.text = DynamicCollectionViewControllerData.data[indexPath.row].secondText
        cell.theLabel3.text = DynamicCollectionViewControllerData.data[indexPath.row].thirdText
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let dequeuedView = collectionView.dequeueReusableSupplementaryView(ofKind: "decoration", withReuseIdentifier: "pillar", for: indexPath)
//        return dequeuedView
//    }
}
