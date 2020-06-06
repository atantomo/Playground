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
        [230, 76, 74],
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
        "chart",
        "web",
        "web",
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
        "customSearchBar",
        "skeleton",
        "buttonLayout",
        "pseudoCollection",
        "presenter",
        "attributedString",
        "tableShadow",
        "collectionIndexRange",
        "hitTest",
        "safeNav"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.

        printTests()
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

    private func printTests() {
//        let number = 1234.5678 // 🤔
//
//        let formatter3 = NumberFormatter()
//        formatter3.minimumFractionDigits = 0
//        formatter3.maximumFractionDigits = 2
//        formatter3.numberStyle = .currency
//
//        formatter3.locale = Locale(identifier: "en_US")
//        let aa = formatter3.string(for: number) // $1,234.57
//
//        formatter3.locale = Locale(identifier: "ja_JP")
//        let a = formatter3.string(for: number) // ￥ 1,235 😵
//
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 0
//        formatter.maximumFractionDigits = 2
//
//        // Avoid not getting a zero on numbers lower than 1
//        // Eg: .5, .67, etc...
//        formatter.numberStyle = .currency
//        formatter.currencyCode = "JPY"
//        formatter.locale = Locale(identifier: "ja_JP")
//
//        let nums = [3.0, 5.1, 7.21, 9.311, 607920.0, 0.5677, 0.6988]
//
//        for num in nums {
//            print(formatter.string(from: num as NSNumber) ?? "n/a")
//        }

        let current = Locale.current

        // Without JP localization: en_JP (current)
        // With JP localization: ja_JP (current)
        print(current)

        let localizedTestString = NSLocalizedString("test", comment: "")
        print(localizedTestString)
        print(localizedTestString)

        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none

        let initialDate = Date.init(timeIntervalSince1970: 0)

        let printDates = { (localeString: String) -> Void in
            print("-----" + localeString)

            dateFormatter.dateStyle = .full
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateStyle = .long
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateStyle = .medium
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateStyle = .short
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateStyle = .none
            print(dateFormatter.string(from: initialDate))

            print("-----")

            dateFormatter.timeStyle = .full
            print(dateFormatter.string(from: initialDate))

            dateFormatter.timeStyle = .long
            print(dateFormatter.string(from: initialDate))

            dateFormatter.timeStyle = .medium
            print(dateFormatter.string(from: initialDate))

            dateFormatter.timeStyle = .short
            print(dateFormatter.string(from: initialDate))

            dateFormatter.timeStyle = .none
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "d zzz"
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "yyyy.MM.dd G 'at' HH:mm:ss zzz"
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "EEE, MMM d, ''yy"
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "h:mm a"
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "hh 'o''clock' a, zzzz"
            print(dateFormatter.string(from: initialDate))

            dateFormatter.dateFormat = "K:mm a, z"
            print(dateFormatter.string(from: initialDate))
        }
        dateFormatter.timeZone = TimeZone(abbreviation: "JST")

        dateFormatter.locale = Locale(identifier: "ja_JP")
        printDates("ja_JP")

        dateFormatter.locale = Locale(identifier: "en_US")
        printDates("en_US")

        dateFormatter.locale = Locale(identifier: "ja")
        printDates("ja")

        dateFormatter.locale = Locale(identifier: "en")
        printDates("en")

        if #available(iOS 10.0, *) {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone(abbreviation: "JST")
            let isoDate = formatter.date(from: "2020-06-05T23:00:00+00:00")


            let hourAndMinuteArray = "2020-06-06T00:00:00+00:00".components(separatedBy: "+").last?.components(separatedBy: ":")
            let hour = Int(hourAndMinuteArray?.first ?? "0") ?? 0
            let minute = Int(hourAndMinuteArray?.last ?? "0") ?? 0
            let secondsFromGMT = hour * 3600 + minute * 60

            let timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
            print("----ISO Date")
            print(timeZone?.abbreviation())
            print(isoDate)

            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeStyle = .full
            print(dateFormatter.string(from: isoDate!))

//            print(serverToLocal(date: "2020-06-06T22:03:02+09:00"))
//            print(formatter.timeZone.abbreviation())
//            print(formatter.string(from: Date()))
        } else {
            // Fallback on earlier versions
        }
//        print(serverToLocal(date: "2020-06-06T22:03:02+09:00"))
//        print(serverToLocal(date: "2020-06-06T22:03:02+00:00"))

    }

    func generate(dateString: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let date = dateFormatter.date(from:dateString)
        return date
    }

    func serverToLocal(date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "JST")
        let localDate = dateFormatter.date(from: date)

        return localDate
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
        
        navigationController?.present(vc, animated: true)
    }

}
