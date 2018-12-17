//
//  TableShadowViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/10/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

protocol ShadowErasable { }
protocol ShadowSeparable {
    func showShadow(at indexPath: IndexPath) -> Bool
}

class LinkableTableView: UITableView {

    override var contentOffset: CGPoint {
        didSet {
            linkedTableView?.contentOffset = contentOffset
        }
    }

    override var dataSource: UITableViewDataSource? {
        didSet {
            linkedTableView?.dataSource = dataSource
        }
    }

    var linkedTableView: UITableView?

}

class ShadowSeparableTableContainerView: UITableView {
    var tableView: LinkableTableView!
    private var shadowTableView: UITableView!
    private var noShadowTableView: UITableView!

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        tableView.isHidden = true
        tableView.linkedTableView = noShadowTableView
        shadowTableView.dataSource = self
        noShadowTableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        shadowTableView.translatesAutoresizingMaskIntoConstraints = false
        noShadowTableView.translatesAutoresizingMaskIntoConstraints = false
        shadowTableView.isUserInteractionEnabled = false
        noShadowTableView.isUserInteractionEnabled = false

        addSubview(tableView)
        addSubview(shadowTableView)
        addSubview(noShadowTableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            shadowTableView.topAnchor.constraint(equalTo: topAnchor),
            shadowTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowTableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            noShadowTableView.topAnchor.constraint(equalTo: topAnchor),
            noShadowTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noShadowTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            noShadowTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

}

extension ShadowSeparableTableContainerView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.numberOfRows(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.cellForRow(at: indexPath) else {
            fatalError()
        }
        if tableView == shadowTableView && cell is ShadowErasable {
            cell.contentView.alpha = 0
        } else if tableView == shadowTableView && !(cell is ShadowErasable) {
            cell.contentView.alpha = 1
        } else if tableView == noShadowTableView && cell is ShadowErasable {
            cell.contentView.alpha = 1
        } else if tableView == noShadowTableView && !(cell is ShadowErasable) {
            cell.contentView.alpha = 0
        }
        return cell
    }
}

class TableShadowViewController: UIViewController {

    @IBOutlet var shadowSeparableTableContainer: ShadowSeparableTableContainerView!
    @IBOutlet var shadowTableView: UITableView!
    @IBOutlet var plainTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

//        shadowTableView.layer.masksToBounds = false
//        shadowTableView.layer.shadowRadius = 2.0
//        shadowTableView.layer.shadowColor = UIColor.lightGray.cgColor
//        shadowTableView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        shadowTableView.layer.shadowOpacity = 0.8
//
//        shadowTableView.delegate = self
//        plainTableView.delegate = self
//
//        shadowTableView.dataSource = self
//        plainTableView.dataSource = self
//
//        shadowSeparableTableContainer.tableView

        

        shadowSeparableTableContainer.tableView.layer.masksToBounds = false
        shadowSeparableTableContainer.tableView.layer.shadowRadius = 2.0
        shadowSeparableTableContainer.tableView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowSeparableTableContainer.tableView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowSeparableTableContainer.tableView.layer.shadowOpacity = 0.8
    }



}


class FlowerTableViewCell: UITableViewCell {
//    @IBOutlet var titleLabel: UILabel!
}

class LeafTableViewCell: UITableViewCell {
    //    @IBOutlet var titleLabel: UILabel!
}

extension TableShadowViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        plainTableView.contentOffset = scrollView.contentOffset
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 3 != 0 {
            return 44.0
        } else {
            return 66.0
        }
    }
}

extension TableShadowViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row % 3 != 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "flower", for: indexPath) as! FlowerTableViewCell
//            if tableView == plainTableView {
//                cell.contentView.alpha = 0
//                cell.backgroundColor = .clear
//            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "leaf", for: indexPath) as! LeafTableViewCell
//            if tableView == shadowTableView {
//                cell.contentView.alpha = 0
////                cell.backgroundColor = .red
//            }
        }
        return cell
    }
}
