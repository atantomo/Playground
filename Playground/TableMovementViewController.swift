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
        return a + a + a
    }()

    lazy var dataSource: [String] = {
        return self.dataSourceBackup
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(deleteCell(sender:)), name: NotificationName.DeleteCell, object: nil)
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

    func deleteCell(sender: Notification) {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "mowz", for: indexPath) as! MowzTableViewCell
        cell.mowzLabel.text = dataSource[indexPath.row]
        return cell
    }
}

class MowzTableViewCell: UITableViewCell {

    @IBOutlet weak var mowzLabel: UILabel!
    @IBOutlet weak var smoochButton: UIButton!

    @IBAction func smoochButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: NotificationName.DeleteCell, object: smoochButton)
    }
}

struct NotificationName {

    static let DeleteCell = NSNotification.Name(rawValue: "DeleteCell")
}
