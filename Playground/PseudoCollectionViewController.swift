//
//  PseudoCollectionViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/09/25.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

struct PseudoCollectionViewControllerData {
    static var data: [(String?, String?)] = [
        (nil, "Cell 1"),
        ("Header 2", "Cell 2"),
        ("Header 3", "Cell 3"),
        ]
}

class PseudoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var collectionData: [(String?, String?)] = PseudoCollectionViewControllerData.data

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "SmallPseudoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "small")
        collectionView.register(UINib(nibName: "LargePseudoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "large")
//        collectionView.register(UINib(nibName: "DividerPseudoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "divider")

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowRadius = 2.0
        collectionView.layer.shadowColor = UIColor.lightGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 2, height: 2)
        collectionView.layer.shadowOpacity = 0.3

        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 48)
            flowLayout.minimumLineSpacing = 1
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
//            flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 64)
        }
    }

}


class ShortPseudoCollectionViewCell: HighlightableCollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!

}

class LargePseudoCollectionReusableView: HighlightableCollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!

}

class DividerPseudoCollectionReusableView: UICollectionReusableView {

}

extension PseudoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.width, height: 64)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.bounds.width, height: 16)
//    }

}


extension PseudoCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = collectionData.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "small", for: indexPath)
        if let cell = dequeuedCell as? ShortPseudoCollectionViewCell {
            cell.textLabel.text = collectionData[indexPath.section].1
            cell.backgroundView = UIView()
            return cell
        }
        return dequeuedCell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let dequeuedCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "large", for: indexPath)
            if let cell = dequeuedCell as? LargePseudoCollectionReusableView {
                cell.textLabel.text = collectionData[indexPath.section].0
                return cell
            }
            return dequeuedCell
        }
//        if kind == UICollectionElementKindSectionFooter {
//            let dequeuedCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "divider", for: indexPath)
//            return dequeuedCell
//        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if (elementKind == UICollectionElementKindSectionHeader) {
            view.layer.zPosition = 0
        }
    }

}

struct SeparatorAdjustableLayout {

}

class SeparatorAdjustableCollectionViewLayout: UICollectionViewFlowLayout {

    private let horizontalSeparatorIdentifier: String = "horizontalSeparator"

    override init() {
        super.init()
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    var decorationViewFrameForIndexPath: [IndexPath: CGRect] = [IndexPath: CGRect]()

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)!

        var cellLayoutAttributes: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()

        for layoutAttribute in layoutAttributes {
            if layoutAttribute.representedElementKind == nil {
                cellLayoutAttributes.append(layoutAttribute)
            }
        }

        for cellLayoutAttribute in cellLayoutAttributes {
            let cellBottomY = (cellLayoutAttribute.frame.origin.y + cellLayoutAttribute.frame.height)
            let collectionWidth = collectionView?.bounds.width ?? 0
            let decorationFrame = CGRect(x: 0, y: cellBottomY, width: collectionWidth, height: 1)
            decorationViewFrameForIndexPath[cellLayoutAttribute.indexPath] = decorationFrame
        }

        for key in decorationViewFrameForIndexPath.keys {
            if let attributes = layoutAttributesForDecorationView(ofKind: horizontalSeparatorIdentifier, at: key) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)

        guard let numberOfItemInSection = collectionView?.numberOfItems(inSection: indexPath.section),
            let frame = decorationViewFrameForIndexPath[indexPath],
            indexPath.item < (numberOfItemInSection - 1) else {
                return nil
        }
        attributes.frame = frame
        return attributes
    }

}

enum TableRowHeight: CGFloat {
    case none = 0
    case small = 48
    case medium = 56
    case large = 64
}

struct FlexibleTableSectionLayout {
    var headerHeightType: TableRowHeight
    var cellHeightType: TableRowHeight
    var cellCount: Int
    var isFooterHidden: Bool

    var totalHeight: CGFloat {
        let headerHeight = headerHeightType.rawValue
        let cellsHeight = cellHeightType.rawValue * CGFloat(cellCount)
        let footerHeight: CGFloat = isFooterHidden ? 0.0 : 16.0

        let totalHeight = headerHeight + cellsHeight + footerHeight
        return totalHeight
    }
}


class HighlightableCollectionViewCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundView?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            } else {
                backgroundView?.backgroundColor = UIColor.white
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundView?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            } else {
                backgroundView?.backgroundColor = UIColor.white
            }
        }
    }
}
