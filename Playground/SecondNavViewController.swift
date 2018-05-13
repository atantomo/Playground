//
//  SecondNavViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit
import MapKit

class SecondNavViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet var equalConstraint: NSLayoutConstraint!
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "I'm the same"

        automaticallyAdjustsScrollViewInsets = false

        scrollView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableViewHeightConstraint.constant = 8 * 44 + 7
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
}

extension SecondNavViewController: UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "rainbow in my heart"
        return cell
    }
}

extension SecondNavViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(tableView.contentSize)
    }
}

class IntrinsicSizedTableView: UITableView {

    override func layoutSubviews() {
        super.layoutSubviews()

        if __CGSizeEqualToSize(bounds.size, intrinsicContentSize) {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {

        let num = CGFloat(dataSource!.tableView(self, numberOfRowsInSection: 0))
        return CGSize(width: contentSize.width, height: contentSize.height + (num - 1))
    }

}


extension SecondNavViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalOffset = scrollView.contentOffset.y

        if verticalOffset > 0 {
            bottomConstraint.isActive = false
            equalConstraint.isActive = true
            topConstraint.constant = -(verticalOffset / 2)
        } else {
            equalConstraint.isActive = false
            bottomConstraint.isActive = true
        }
    }
}
