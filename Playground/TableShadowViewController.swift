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

//    override var dataSource: UITableViewDataSource? {
//        didSet {
//            linkedTableView?.dataSource = dataSource
//        }
//    }

    var linkedTableView: UITableView?

}

class ShadowSeparableTableContainerView: UIView {
    var tableView: LinkableTableView!
    var shadowTableView: UITableView!
    private var noShadowTableView: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        tableView = LinkableTableView(frame: frame)
        shadowTableView = UITableView(frame: frame)
        noShadowTableView = UITableView(frame: frame)

//        tableView.isHidden = true
        shadowTableView.backgroundColor = UIColor.clear
        noShadowTableView.backgroundColor = UIColor.clear
        shadowTableView.backgroundView = UIView()
        noShadowTableView.backgroundView = UIView()

        tableView.linkedTableView = noShadowTableView
        shadowTableView.dataSource = self
        noShadowTableView.dataSource = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        shadowTableView.translatesAutoresizingMaskIntoConstraints = false
        noShadowTableView.translatesAutoresizingMaskIntoConstraints = false
        shadowTableView.isUserInteractionEnabled = true
        noShadowTableView.isUserInteractionEnabled = false

        addSubview(tableView)
        addSubview(shadowTableView)
//        addSubview(noShadowTableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            shadowTableView.topAnchor.constraint(equalTo: topAnchor),
            shadowTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadowTableView.trailingAnchor.constraint(equalTo: trailingAnchor),

//            noShadowTableView.topAnchor.constraint(equalTo: topAnchor),
//            noShadowTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            noShadowTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            noShadowTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
        let dupCell = self.tableView.dequeueReusableCell(withIdentifier: cell.reuseIdentifier!, for: indexPath)
        if tableView == shadowTableView && dupCell.reuseIdentifier == "leaf" {
            cell.contentView.alpha = 0
        } else if tableView == shadowTableView && dupCell.reuseIdentifier != "leaf" {
            cell.contentView.alpha = 1
        } else if tableView == noShadowTableView && dupCell.reuseIdentifier == "leaf" {
            cell.contentView.alpha = 1
        } else if tableView == noShadowTableView && dupCell.reuseIdentifier != "leaf" {
            cell.contentView.alpha = 0
        }
        return dupCell
    }
}

class TableShadowViewController: UIViewController {

    @IBOutlet var shadowSeparableTableContainer: ShadowSeparableTableContainerView!
    @IBOutlet var shadowTableView: UITableView!
    @IBOutlet var plainTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let shadowNib = UINib(nibName: "ShadowAllowedTableViewCell", bundle: nil)
        let noShadowNib = UINib(nibName: "ShadowProhibitedTableViewCell", bundle: nil)

        shadowTableView.layer.masksToBounds = false
        shadowTableView.layer.shadowRadius = 2.0
        shadowTableView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowTableView.layer.shadowOffset = CGSize(width: 2, height: 2)
        shadowTableView.layer.shadowOpacity = 0.8

        if #available(iOS 10.0, *) {
            plainTableView.refreshControl = UIRefreshControl()
            let ref = UIRefreshControl()
            ref.alpha = 0
            ref.addTarget(self, action: #selector(refreshControlValueChanged), for: UIControlEvents.valueChanged)
            shadowTableView.refreshControl = ref
        } else {
            // Fallback on earlier versions
        }

        shadowTableView.delegate = self
        plainTableView.delegate = self

        shadowTableView.register(shadowNib, forCellReuseIdentifier: "shadow")
        shadowTableView.register(noShadowNib, forCellReuseIdentifier: "noShadow")
        plainTableView.register(shadowNib, forCellReuseIdentifier: "shadow")
        plainTableView.register(noShadowNib, forCellReuseIdentifier: "noShadow")

        shadowTableView.dataSource = self
        plainTableView.dataSource = self

//        plainTableView.allowsSelection = false
//        shadowTableView.allowsSelection = false

//        print(plainTableView.layer.shadowRadius)
//        print(plainTableView.layer.shadowColor)
//        print(plainTableView.layer.shadowOffset)
//        print(plainTableView.layer.shadowOpacity)
//
//        shadowSeparableTableContainer.tableView


//        shadowSeparableTableContainer.tableView.register(nib, forCellReuseIdentifier: "leaf")
//        shadowSeparableTableContainer.tableView.register(nib, forCellReuseIdentifier: "flower")
//        shadowSeparableTableContainer.tableView.dataSource = self
//
//        shadowSeparableTableContainer.shadowTableView.layer.masksToBounds = false
//        shadowSeparableTableContainer.shadowTableView.layer.shadowRadius = 2.0
//        shadowSeparableTableContainer.shadowTableView.layer.shadowColor = UIColor.lightGray.cgColor
//        shadowSeparableTableContainer.shadowTableView.layer.shadowOffset = CGSize(width: 2, height: 2)
//        shadowSeparableTableContainer.shadowTableView.layer.shadowOpacity = 0.8
    }


    @objc
    func refreshControlValueChanged(_ sender: Any) {
        if #available(iOS 10.0, *) {
            plainTableView.refreshControl?.beginRefreshing()
        } else {
            // Fallback on earlier versions
        }
    }

}


class FlowerTableViewCell: UITableViewCell {
//    @IBOutlet var titleLabel: UILabel!
}

class LeafTableViewCell: UITableViewCell {
    //    @IBOutlet var titleLabel: UILabel!
}

class ShadowAllowedTableViewCell: UITableViewCell { }

class ShadowProhibitedTableViewCell: UITableViewCell, ShadowErasable { }

extension TableShadowViewController: UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        plainTableView.contentOffset = scrollView.contentOffset

//        if #available(iOS 10.0, *) {
//            if plainTableView.contentOffset.y <= -(shadowTableView.refreshControl?.frame.height ?? 0) {
//                plainTableView.refreshControl?.beginRefreshing()
//            }
////            print(shadowTableView.refreshControl?.frame)
//        } else {
//            // Fallback on earlier versions
//        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row % 3 != 0 {
            return 88.0
//        } else {
//            return 132.0
//        }
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        let isShadowAppliedToTable = tableView.layer.shadowOpacity != 0
//        if !isShadowAppliedToTable {
//            shadowTableView.highli
//        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let isShadowAppliedToTable = tableView.layer.shadowOpacity != 0
//        if !isShadowAppliedToTable {
//            shadowTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
//        }
    }
}

extension TableShadowViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let isShadowAppliedToTable = tableView.layer.shadowOpacity != 0

        if indexPath.row % 3 != 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "shadow", for: indexPath) as! ShadowAllowedTableViewCell
            if !isShadowAppliedToTable {
                cell.contentView.alpha = 0
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "noShadow", for: indexPath) as! ShadowProhibitedTableViewCell
            if isShadowAppliedToTable {
                cell.contentView.alpha = 0
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
}
