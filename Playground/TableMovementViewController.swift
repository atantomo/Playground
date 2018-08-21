//
//  TableMovementViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/04/24.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class TableMovementViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

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
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        let nib = UINib(nibName: "AutoLayoutTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AutoLayout")

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
        tableView.reloadData()
    }

    @IBAction func resetTextButtonTapped(_ sender: Any) {
        dataSource = dataSourceBackupB
        tableView.reloadData()
    }

    @objc func deleteCell(sender: Notification) {

        let button = sender.object as! UIButton
        let position = button.superview!.convert(button.center, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: position) {

            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }

}

extension TableMovementViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "mowz", for: indexPath) as! MowzTableViewCell
//        cell.mowzLabel.text = dataSource[indexPath.row]
//        cell.skeletonView.show()
//        return cell

        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoLayout", for: indexPath) as! AutoLayoutTableViewCell
        cell.messageLabel.text = dataSource[indexPath.row]
        cell.skeletonView.show()
        return cell
    }
}

class MowzTableViewCell: UITableViewCell {

    @IBOutlet weak var mowzLabel: UILabel!
    @IBOutlet weak var smoochButton: UIButton!

    @IBOutlet var skeletonParts: [UIView]!
    lazy var skeletonView: SkeletonView = {
        let view = SkeletonView(parentFrame: self.frame, roundedCornerParts: self.skeletonParts)
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(skeletonView)
    }

    @IBAction func smoochButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: smoochButton)
    }
}

struct NotificationName {

    static let DeleteCell = NSNotification.Name(rawValue: "DeleteCell")
}
