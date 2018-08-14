//
//  DynamicCollectionViewLayout.swift
//  Playground
//
//  Created by TANTOMO Andrew-Getty[FRJP:Digital Business Transformation Services](Tantomo Andrew) on 2018/08/14.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

public extension Array {
    subscript(safe idx: Int) -> Element? {
        return idx < endIndex ? self[idx] : nil
    }
}

class DynamicCollectionViewLayout: UICollectionViewLayout {

    lazy var measurementModel: CuteCollectionViewCell = {
        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
            fatalError()
        }
        return view
    }()

    lazy var rowHeights: [CGFloat] = {
        print(self.collectionView!.bounds.size.width)
        let rawHeights = DynamicCollectionViewControllerData.data.map { text -> CGFloat in
            let h = self.measurementModel.heightForWidth(width: self.collectionView!.bounds.size.width / 2, text: text)
            return h
        }

        var heights = [CGFloat]()
        for i in stride(from: 0, to: rawHeights.count, by: 2) {

            let lhs = rawHeights[i]
            let rhs = rawHeights[safe: (i + 1)] ?? 0.0
            let maxRowHeight = max(lhs, rhs)
            heights.append(maxRowHeight)
        }
        return heights
    }()

    override init() {
        super.init()
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "decoration")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "decoration")
    }

    override var collectionViewContentSize: CGSize {
        let contentWidth = collectionView!.bounds.size.width
        let contentHeight: CGFloat = rowHeights.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight);
        return contentSize;
    }

    override func prepare() {
//        DynamicCollectionViewControllerData.data.map

//        let h3 = measurementModel.heightForWidth(width: 137, text: DynamicCollectionViewControllerData.data[2])
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        let visibleIndexPaths = indexPathsOfItemsInRect(rect: rect)
        for indexPath in visibleIndexPaths {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let pillarIndexPaths = indexPathsOfPillarInRect(rect: rect)
        for pillarIndexPath in pillarIndexPaths {
            if let attributes = layoutAttributesForDecorationView(ofKind: "decoration", at: pillarIndexPath) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frameForItem(at: indexPath)
        return attributes;
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)

        let columnWidth = collectionViewContentSize.width / 2

        attributes.frame = CGRect(x: columnWidth, y: 0, width: 2, height: collectionViewContentSize.height)
        attributes.zIndex = 10
        return attributes;
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    private func indexPathsOfPillarInRect(rect: CGRect) -> [IndexPath] {
        return [IndexPath(row: 0, section: 0)]
    }

    private func indexPathsOfItemsInRect(rect: CGRect) -> [IndexPath] {
        let minVisibleColumn = columnIndexFromXCoordinate(xPosition: rect.minX)
        let maxVisibleColumn = columnIndexFromXCoordinate(xPosition: rect.maxX)

        let minVisibleRow = rowIndexFromYCoordinate(yPosition: rect.minY)
        let maxVisibleRow = rowIndexFromYCoordinate(yPosition: rect.maxY)

        var indexes = [Int]()
//        let startingIndex = 2 * minVisibleRow + minVisibleColumn
//        indexes.append(startingIndex)


        var firstColumnIndexes = [Int]()
        for i in minVisibleRow...maxVisibleRow {
            let firstColumnIndex = minVisibleColumn + i * 2
            firstColumnIndexes.append(firstColumnIndex)
        }

        for i in 0...(maxVisibleColumn - minVisibleColumn) {
            for j in firstColumnIndexes {
                let columnIndex = j + i
                if columnIndex < DynamicCollectionViewControllerData.data.count {
                    indexes.append(columnIndex)
                }
            }
        }
        return indexes.map { index in
            return IndexPath(row: index, section: 0)
        }
    }

    private func columnIndexFromXCoordinate(xPosition: CGFloat) -> Int {
        let contentWidth = collectionViewContentSize.width // - HourHeaderWidth;
        let widthPerColumn = (contentWidth + 1) / 2 // need to subtract separator;
        let columnIndex = max(0, Int(xPosition / widthPerColumn))
        return columnIndex
    }

    private func rowIndexFromYCoordinate(yPosition: CGFloat) -> Int {
//        let contentHeight = collectionViewContentSize.height // - HourHeaderWidth;
//        print(rowHeights)
        var yPositionMutable = yPosition
        for (index, rowHeight) in rowHeights.enumerated() {
            yPositionMutable -= rowHeight
            if yPositionMutable <= 0 {
                return index
            }
        }
        return rowHeights.count - 1
    }

    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        let columnWidth = collectionViewContentSize.width / 2
        let index = CGFloat(indexPath.row)

        let columnCount: CGFloat = 2
        let x = index.truncatingRemainder(dividingBy: columnCount) * columnWidth

        let rowIndex = Int(index / 2)
        let y = rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }

        let frame = CGRect(x: x, y: y, width: columnWidth, height: rowHeights[rowIndex])
        return frame
    }
    
}
