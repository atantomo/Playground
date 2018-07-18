//
//  AutoLayoutCollectionViewCell.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/06/13.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class AutoLayoutCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        containerWidthConstraint.constant = (screenWidth - 64) / 2
    }
}


class TopFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForItem(at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
            var atts = super.layoutAttributesForItem(at:indexPath)!
            if indexPath.item == 0 {
                return atts // degenerate case 1
            }
            if atts.frame.origin.x - 1 <= self.sectionInset.left {
                return atts // degenerate case 2
            }
            let ipPv = IndexPath(item:indexPath.row-1, section:indexPath.section)
            print("aaaaaa")
            print(ipPv)
            let firstPositionVar =
                self.layoutAttributesForItem(at:ipPv)!.frame
            let rightPositionVar =
                firstPositionVar.origin.x + firstPositionVar.size.width + self.minimumInteritemSpacing
            atts = atts.copy() as! UICollectionViewLayoutAttributes
            atts.frame.origin.x = rightPositionVar
            return atts
    }

    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            let arr = super.layoutAttributesForElements(in: rect)!
            return arr.map { atts in
                var atts = atts
                if atts.representedElementCategory == .cell {
                    let ip = atts.indexPath
                    atts = self.layoutAttributesForItem(at:ip)!
                }
                return atts
            }
    }
}
