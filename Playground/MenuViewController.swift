//
//  MenuViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let tintValues: [[Int]] = [
        // Rainbow
        [216, 61, 84],
        [234, 82, 78],
        [242, 101, 51],
        [242, 128, 15],
        [247, 155, 22],
        [249, 181, 11],
        [255, 220, 0],
        [245, 225, 15],
        [207, 216, 19],
        [116, 209, 44],
        [17, 183, 100],
        [29, 181, 138],
        [51, 188, 178],
        [91, 210, 216],
        [119, 214, 229],
        [81, 187, 229],
        [41, 150, 211],
        [44, 111, 191],
        [108, 104, 188],
        [132, 88, 175],
        [157, 82, 170],
        [204, 117, 200],
        [232, 114, 176],
        [226, 90, 136],
        ]

    let items: [String] = [
        "navResizer",
        "navHide",
        "navParallax",
        "dynamicCollection",
        "tabbedPage",
        "navTransition",
        "customLabel",
        "customTab",
        "tableEdit",
        "collectionEdit",
        "centerScroll",
        "customSearchBar"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func mapColorInts(red: Int, green: Int, blue: Int) -> UIColor {

        let cgFloatRed = CGFloat(red)
        let cgFloatGreen = CGFloat(green)
        let cgFloatBlue = CGFloat(blue)

        return UIColor(red: cgFloatRed / 255.0, green: cgFloatGreen / 255.0, blue: cgFloatBlue / 255.0, alpha: 1)
    }

    @objc
    func dismissVC() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }

}

extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.textLabel?.textColor = UIColor.white

        cell.backgroundColor = mapColorInts(red: tintValues[indexPath.row][0], green: tintValues[indexPath.row][1], blue: tintValues[indexPath.row][2])
        return cell
    }

}

extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: items[indexPath.row]) else {
            return
        }
        let backButton = UIButton(frame: CGRect(x: 20, y: 20, width: 44, height: 44))
        backButton.layer.cornerRadius = 4.0
        backButton.setTitle("Back", for: UIControlState.normal)
        backButton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(dismissVC), for: UIControlEvents.touchUpInside)

        vc.view.addSubview(backButton)
        navigationController?.present(vc, animated: true)
    }

}
