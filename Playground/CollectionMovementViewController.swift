//
//  CollectionMovementViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/24.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class CollectionMovementViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    lazy var dataSourceBackup: [String] = {
        let a = [
            "Created by Andrew Tantomo on 2018/04/24",
            "Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24",
            "Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24",
            "Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24 Created by Andrew Tantomo on 2018/04/24",
        ]
        return a //+ a + a
    }()

    lazy var dataSourceBackupB: [String] = {
        let a = [
            "2018/04/24",
            ]
        return a
    }()

    lazy var dataSource: [String] = {
        return self.dataSourceBackup
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell(sender:)), name: NotificationName.DeleteCell, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        print("A")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationName.DeleteCell, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func replenishButtonTapped(_ sender: Any) {
        dataSource = dataSourceBackup
        collectionView.reloadData()
    }

    @IBAction func resetTextButtonTapped(_ sender: Any) {
        dataSource = dataSourceBackupB
        collectionView.reloadData()
    }

    func deleteCell(sender: Notification) {

        let button = sender.object as! UIButton
        let position = button.superview!.convert(button.center, to: collectionView)
        if let indexPath = collectionView.indexPathForItem(at: position) {

            dataSource.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }
    }

}

extension CollectionMovementViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mowz", for: indexPath) as! MowzCollectionViewCell
        cell.mowzLabel.text = dataSource[indexPath.row]

        cell.mowzHideConstraint.priority = UILayoutPriorityDefaultHigh
        cell.mowzHideConstraint.priority = UILayoutPriorityDefaultLow
        cell.mowzHideConstraint.priority = UILayoutPriorityRequired
//        cell.updateConstraintsIfNeeded()
//        cell.mowzLeading.priority = UILayoutPriorityRequired
        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
        return cell
    }

}

class MowzCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mowzHideConstraint: NSLayoutConstraint!
    @IBOutlet weak var mowzLeading: NSLayoutConstraint!
    @IBOutlet weak var mowzLabel: UILabel!
    @IBOutlet weak var smoochButton: UIButton!

//    override func updateConstraints() {
//        mowzHideConstraint.isActive = true
//        super.updateConstraints()
//    }
//    override func awakeFromNib() {
//        mowzLeading.priority = UILayoutPriorityDefaultHigh
//        setNeedsLayout()
//        layoutIfNeeded()
//        mowzLeading.priority = UILayoutPriorityRequired
//        setNeedsLayout()
//        layoutIfNeeded()
//    }

    @IBAction func smoochButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: smoochButton)
    }
}
