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
        (nil, "Cell 1"),
        ("Header 2", "Cell 2"),
        ("Header 3", "Cell 3"),
        (nil, "Cell 1"),
        ("Header 2", "Cell 2"),
        ("Header 3", "Cell 3"),
        (nil, "Cell 1"),
        ("Header 2", "Cell 2"),
        ("Header 3", "Cell 3")
        ]
}

class PseudoCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var collectionData: [(String?, String?)] = PseudoCollectionViewControllerData.data
    var isLoading: Bool = false
    var isEndOfData: Bool = false

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "SmallPseudoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "small")
        collectionView.register(UINib(nibName: "LargePseudoCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "large")
        collectionView.register(UINib(nibName: "LoaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loader")

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
//            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
//            flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 64)
        }
    }

    func updateLoadingState(isLoading: Bool) {
//        if isLoading {
//            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        } else {
//            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
//        }
        self.isLoading = isLoading
        collectionView.collectionViewLayout.invalidateLayout()
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

class LoaderCollectionReusableView: UICollectionReusableView {

}

extension PseudoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !isEndOfData else {
            return
        }
        let willAppearIndex = indexPath.item
        let currentBatchLastIndex = collectionData.count - 1
        if willAppearIndex >= currentBatchLastIndex {
            updateLoadingState(isLoading: true)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
//                guard let vc = self else {
//                    return
//                }
//                vc.updateLoadingState(isLoading: false)
//                vc.collectionData = vc.collectionData + PseudoCollectionViewControllerData.data
//                if vc.collectionData.count >= 50 {
//                    vc.isEndOfData = true
//                }
//                vc.collectionView.reloadData()
//            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.width, height: 64)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize(width: collectionView.bounds.width, height: 64)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 16)
        }
    }

}


extension PseudoCollectionViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = collectionData.count
        return 1//count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "small", for: indexPath)
        if let cell = dequeuedCell as? ShortPseudoCollectionViewCell {
            cell.textLabel.text = collectionData[indexPath.section].1
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
        if kind == UICollectionElementKindSectionFooter {
            let dequeuedCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "loader", for: indexPath)
            return dequeuedCell
        }
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

    var decorationViewFrameForIndexPath: [IndexPath: CGRect] = [IndexPath: CGRect]()
    private let horizontalSeparatorIdentifier: String = "horizontalSeparator"

    override init() {
        super.init()
        register(UINib(nibName: "InsetSeparatorReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "InsetSeparatorReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)!

        let cellLayoutAttributes = layoutAttributes.filter { layoutAttribute in
            return layoutAttribute.representedElementKind == nil
        }

        for cellLayoutAttribute in cellLayoutAttributes {
            let cellBottomY = (cellLayoutAttribute.frame.origin.y + cellLayoutAttribute.frame.height)
            let collectionWidth = collectionView?.bounds.width ?? 0
            let decorationFrame = CGRect(x: 0, y: cellBottomY, width: collectionWidth, height: 1)
            decorationViewFrameForIndexPath[cellLayoutAttribute.indexPath] = decorationFrame
        }

        for indexPath in decorationViewFrameForIndexPath.keys {
            if let attributes = layoutAttributesForDecorationView(ofKind: horizontalSeparatorIdentifier, at: indexPath) {
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
        attributes.zIndex = -10
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        let isBoundsWidthChanged = (newBounds.width != oldBounds?.width)

        let collectionWidth = newBounds.width
        itemSize = CGSize(width: collectionWidth, height: itemSize.height)
        if isBoundsWidthChanged {
            decorationViewFrameForIndexPath.removeAll()
        }
        return isBoundsWidthChanged
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        clipsToBounds = false
        backgroundView = UIView()

        //        print(backgroundView?.frame)

        let bv = backgroundView!
//        bv.frame = CGRect(x: bv.frame.origin.x - 1,
//                          y: bv.frame.origin.y - 1,
//                          width: bv.frame.width + 2,
//                          height: bv.frame.height + 2)

        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bv.topAnchor.constraint(equalTo: topAnchor, constant: -1),
            bv.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -1),
            bv.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 1),
            bv.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1)
            ])
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundView?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            } else {
                backgroundView?.backgroundColor = UIColor.clear
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundView?.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            } else {
                backgroundView?.backgroundColor = UIColor.clear
            }
        }
    }
}

// TODO: [COLLECTION_LAYOUT_REFACTOR] This is a temporary class to adjust the collection view offset between layout transitions.
// We may need to migrate this logic into a new UICollectionViewLayout subclass when we want to do manual layout calculation in the future.
class TransitionOffsetRatioFlowLayout: UICollectionViewFlowLayout {

    private var previousOffsetRatio: CGFloat?

    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        guard let collectionView = collectionView else {
            return
        }
        let topInset = collectionView.contentInset.top
        let topOffset = collectionView.contentOffset.y + topInset
        previousOffsetRatio = topOffset / oldLayout.collectionViewContentSize.height
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        guard let collectionView = collectionView,
            let offsetRatio = previousOffsetRatio else {
                return proposedContentOffset
        }
        previousOffsetRatio = nil
        let topInset = collectionView.contentInset.top
        let topOffset = (offsetRatio * collectionViewContentSize.height) - topInset

        let forecastedContentHeight = topOffset + collectionView.bounds.height
        if forecastedContentHeight > collectionViewContentSize.height {
            let maxTopOffet = collectionViewContentSize.height - collectionView.bounds.height
            return CGPoint(x: proposedContentOffset.x, y: maxTopOffet)

        } else {
            return CGPoint(x: proposedContentOffset.x, y: topOffset)
        }
    }

}
