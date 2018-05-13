//
//  ThirdNavViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/01/23.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

class ThirdNavViewController: UIViewController {

    var beginDraggingOffset: CGFloat = 0
    var prevDraggingOffset: CGFloat = 0
    var didDraggingOffset: CGFloat = 0

    var scrollDirection: Direction = .down
    var previousScrollDirection: Direction = .down

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "I'm the same"
        collectionView.dataSource = self
        collectionView.delegate = self
        extendedLayoutIncludesOpaqueBars = true
    }

//    override func viewWillAppear(_ animated: Bool) {
//        let navTransition = CATransition()
//        navTransition.duration = 1
//        navTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        navTransition.type = kCATransitionPush
//        navTransition.subtype = kCATransitionPush
//        self.navigationController?.navigationBar.layer.add(navTransition, forKey: nil)
//    }

    
    @IBAction func leaveMeButtonTapped(_ sender: Any) {
        guard let isHidden = navigationController?.isNavigationBarHidden else {
            return
        }

        if isHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension ThirdNavViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}

enum Direction {
    case up
    case down
}

extension ThirdNavViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let verticalOffset = scrollView.contentOffset.y

        guard verticalOffset > 0 && (verticalOffset + scrollView.frame.height) < scrollView.contentSize.height else {
            return
        }
        let currentAndPreviousDiff = verticalOffset - prevDraggingOffset
        if currentAndPreviousDiff > 0 {
            scrollDirection = .down
        } else {
            scrollDirection = .up
        }

        if previousScrollDirection != scrollDirection {
            beginDraggingOffset = scrollView.contentOffset.y
        }

        didDraggingOffset = verticalOffset

        if (didDraggingOffset - beginDraggingOffset) < -88 {
            navigationController?.setNavigationBarHidden(false, animated: true)

        } else if (didDraggingOffset - beginDraggingOffset) > 88 {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }

        prevDraggingOffset = scrollView.contentOffset.y
        previousScrollDirection = scrollDirection
    }
}
