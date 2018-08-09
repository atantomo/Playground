//
//  SearchBarViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class SearchBarViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

//        searchBar.backgroundImage = UIImage()
        searchBar.setImage(#imageLiteral(resourceName: "melon-s"), for: UISearchBarIcon.search, state: UIControlState.normal)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 88, vertical: 0), for: UISearchBarIcon.search)

    }

}
