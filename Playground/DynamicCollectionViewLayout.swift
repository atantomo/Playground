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

    let columnCount: Int = 5
    let separatorWidth: CGFloat = 1
    let separatorZIndex: Int = 10

    var columnCountCGFloat: CGFloat {
        return CGFloat(columnCount)
    }

    var cellCount: Int {
        return DynamicCollectionViewControllerData.data.count
    }

    lazy var cellWidth: CGFloat = {
        let totalWidth = self.collectionView?.bounds.size.width ?? 0.0
//        let contentWidth = totalWidth - self.separatorWidth
//        let width = contentWidth / self.columnCountCGFloat
        let width = totalWidth / self.columnCountCGFloat
        return width
    }()
    
    lazy var measurementCell: CuteCollectionViewCell = {
        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
        guard let cell = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
            fatalError()
        }
        return cell
    }()

    lazy var rowHeights: [CGFloat] = {
        let cellHeights = DynamicCollectionViewControllerData.data.map { text -> CGFloat in
            let height = self.measurementCell.heightForWidth(width: self.cellWidth, text: text)
            return height
        }

        let lastCellIndex = self.cellCount - 1
        var rowHeights = [CGFloat]()
        for i in stride(from: 0, to: self.cellCount, by: self.columnCount) {

            let leftmostCellIndex = i
            var rightmostCellIndex = i + self.columnCount - 1

            let cellExistsAtRightmostIndex = rightmostCellIndex <= lastCellIndex
            if !cellExistsAtRightmostIndex {
                rightmostCellIndex = lastCellIndex
            }
            let maxCellHeight = cellHeights[leftmostCellIndex...rightmostCellIndex].max() ?? 0
            rowHeights.append(maxCellHeight)
        }
        return rowHeights
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
        let contentWidth = collectionView?.bounds.size.width ?? 0
        let contentHeight = rowHeights.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight);
        return contentSize;
    }

//    override func prepare() {
//    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        let visibleIndexPaths = indexPathsOfItemsInRect(rect: rect)
        for indexPath in visibleIndexPaths {
            if let attributes = layoutAttributesForItem(at: indexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let pillarIndexPaths = indexPathsOfSeparatorInRect(rect: rect)
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
        return attributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        attributes.frame = frameForSeparator(at: indexPath)
        attributes.zIndex = separatorZIndex
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        let areBoundsChanged = newBounds.width != oldBounds?.width
        return areBoundsChanged
    }

    private func indexPathsOfItemsInRect(rect: CGRect) -> [IndexPath] {
        let minColumnIndex = columnIndexFromXCoordinate(xPosition: rect.minX)
        let maxColumnIndex = columnIndexFromXCoordinate(xPosition: rect.maxX)

        let minRowIndex = rowIndexFromYCoordinate(yPosition: rect.minY)
        let maxRowIndex = rowIndexFromYCoordinate(yPosition: rect.maxY)

        var firstColumnIndexes = [Int]()
        for i in minRowIndex...maxRowIndex {
            let firstColumnIndex = minColumnIndex + i * columnCount
            firstColumnIndexes.append(firstColumnIndex)
        }

        var indexes = [Int]()
        for i in 0...(maxColumnIndex - minColumnIndex) {
            for firstColumnIndex in firstColumnIndexes {
                let columnIndex = firstColumnIndex + i
                if columnIndex < cellCount {
                    indexes.append(columnIndex)
                }
            }
        }
        let indexPaths = indexes.map { index in
            return IndexPath(row: index, section: 0)
        }
        return indexPaths
    }

    private func indexPathsOfSeparatorInRect(rect: CGRect) -> [IndexPath] {
        let minColumnIndex = columnIndexFromXCoordinate(xPosition: rect.minX)
        let maxColumnIndex = columnIndexFromXCoordinate(xPosition: rect.maxX)

        var indexes = [Int]()
        for i in minColumnIndex..<maxColumnIndex {
            indexes.append(i)
        }
        let indexPaths = indexes.map { index in
            return IndexPath(row: index, section: 0)
        }
        return indexPaths
    }

    private func columnIndexFromXCoordinate(xPosition: CGFloat) -> Int {
        let xPositionWithOffset = xPosition - 1

        let contentWidth = collectionViewContentSize.width
        let widthPerColumn = contentWidth / columnCountCGFloat
        let columnIndex = Int(xPositionWithOffset / widthPerColumn)
        return columnIndex
    }

    private func rowIndexFromYCoordinate(yPosition: CGFloat) -> Int {
        var yPositionMutable = yPosition
        for (rowIndex, rowHeight) in rowHeights.enumerated() {
            yPositionMutable -= rowHeight
            if yPositionMutable <= 0 {
                return rowIndex
            }
        }
        let lastRowIndex = rowHeights.count - 1
        return lastRowIndex
    }

    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndex = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndex * cellWidth

        let rowIndex = index / columnCount
        let y = rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let cellHeight = rowHeights[rowIndex]

        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        return frame
    }

    private func frameForSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row
        let interimMultiplier = index + 1

        let lastRowCellCount = CGFloat(cellCount).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let lastCellColumnIndex = Int(lastRowCellCount - 1)

        var separatorHeight = collectionViewContentSize.height
        if index >= lastCellColumnIndex {
            separatorHeight -= rowHeights.last ?? 0
        }

        let x = CGFloat(interimMultiplier) * cellWidth - (separatorWidth / 2)
        let frame = CGRect(x: x, y: 0, width: separatorWidth, height: separatorHeight)
        return frame
    }
    
}
