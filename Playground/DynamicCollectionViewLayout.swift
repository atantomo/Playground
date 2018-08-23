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

    private struct Constants {
        static let portraitColumnCount: Int = 2
        static let landscapeColumnCount: Int = 4

        static let separatorWidth: CGFloat = 1
        static let separatorZIndex: Int = 10
    }

    var columnCount: Int = 0
    var cellWidth: CGFloat = 0
    var rowHeights: [CGFloat] = [CGFloat]()

    var models: [DynamicCollectionCellModel] {
        return DynamicCollectionViewControllerData.data
    }

    var cellCount: Int {
        return models.count
    }

    var cellAndSeparatorWidth: CGFloat {
        return cellWidth + Constants.separatorWidth
    }

    var maxSeparatorIndex: Int {
        return cellCount - ((cellCount - 1) / columnCount)
    }
    
    lazy var measurementCell: CuteCollectionViewCell = {
        let nib = UINib(nibName: "CuteCollectionViewCell", bundle: nil)
        guard let cell = nib.instantiate(withOwner: self, options: nil).first as? CuteCollectionViewCell else {
            fatalError()
        }
        return cell
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

    override func prepare() {
        columnCount = calculateColumnCount()
        cellWidth = calculateCellWidth()
        rowHeights = calculateRowHeights(models: models)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()

        let cellIndexPaths = indexPathsOfCellsInRect(rect: rect)
        for cellIndexPath in cellIndexPaths {
            if let attributes = layoutAttributesForItem(at: cellIndexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let separatorIndexPaths = indexPathsOfSeparatorInRect(rect: rect)
        for separatorIndexPath in separatorIndexPaths {
            if let attributes = layoutAttributesForDecorationView(ofKind: "decoration", at: separatorIndexPath) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frameForCell(at: indexPath)
        return attributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        attributes.frame = frameForSeparator(at: indexPath)
        attributes.zIndex = Constants.separatorZIndex
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds
        let areBoundsChanged = newBounds.width != oldBounds?.width
        return areBoundsChanged
    }

    private func calculateColumnCount() -> Int {
        let width = collectionView?.bounds.size.width ?? 0
        let height = collectionView?.bounds.size.height ?? 0
        if width < height {
            return Constants.portraitColumnCount
        } else {
            return Constants.landscapeColumnCount
        }
    }

    private func calculateCellWidth() -> CGFloat {
        let totalWidth = collectionView?.bounds.size.width ?? 0.0
        let separatorCount = columnCount - 1

        let contentWidth = totalWidth - Constants.separatorWidth * CGFloat(separatorCount)
        let width = contentWidth / CGFloat(columnCount)
        return width
    }

    private func calculateRowHeights(models: [DynamicCollectionCellModel]) -> [CGFloat] {
        let cellHeights = models.map { model -> CGFloat in
            let height = measurementCell.heightForWidth(width: cellWidth, model: model)
            return height
        }

        let lastCellIndex = cellCount - 1
        var rowHeights = [CGFloat]()
        for i in stride(from: 0, to: cellCount, by: columnCount) {

            let leftmostCellIndex = i
            var rightmostCellIndex = i + columnCount - 1

            let cellExistsAtRightmostIndex = rightmostCellIndex <= lastCellIndex
            if !cellExistsAtRightmostIndex {
                rightmostCellIndex = lastCellIndex
            }
            let maxCellHeight = cellHeights[leftmostCellIndex...rightmostCellIndex].max() ?? 0
            rowHeights.append(maxCellHeight)
        }
        return rowHeights
    }

    private func indexPathsOfCellsInRect(rect: CGRect) -> [IndexPath] {
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

        let minRowIndex = rowIndexFromYCoordinate(yPosition: rect.minY)
        let maxRowIndex = rowIndexFromYCoordinate(yPosition: rect.maxY)

        var firstColumnIndexes = [Int]()
        for i in minRowIndex...maxRowIndex {
            let firstColumnIndex = minColumnIndex + i * (columnCount - 1)
//            print(String(firstColumnIndex) + " " + String(firstColumnIndex * (columnCount - 1)) + " " + String((cellCount - (cellCount / columnCount))))
            if (firstColumnIndex) < maxSeparatorIndex {
                firstColumnIndexes.append(firstColumnIndex)
            }
        }

//        print(firstColumnIndexes)
        var indexes = [Int]()
        for i in 0...(maxColumnIndex - minColumnIndex - 1) {
            for firstColumnIndex in firstColumnIndexes {
                let columnCellIndex = firstColumnIndex + i
                if columnCellIndex < cellCount {
                    indexes.append(columnCellIndex)
                }
            }
        }
        let indexPaths = indexes.map { index in
            return IndexPath(row: index, section: 0)
        }
//        print(indexPaths)
//        print(indexPaths)
        return indexPaths

//        var indexes = [Int]()
//        for i in minColumnIndex..<maxColumnIndex {
//            indexes.append(i)
//        }
//        let indexPaths = indexes.map { index in
//            return IndexPath(row: index, section: 0)
//        }
//        return indexPaths
    }

    private func columnIndexFromXCoordinate(xPosition: CGFloat) -> Int {
        let xPositionWithOffset = xPosition - 1

        let columnIndex = Int(xPositionWithOffset / cellAndSeparatorWidth)
        return columnIndex
    }

    private func rowIndexFromYCoordinate(yPosition: CGFloat) -> Int {
        guard !rowHeights.isEmpty else {
            return 0
        }
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

    private func frameForCell(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndex = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndex * cellAndSeparatorWidth

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

        let columnIndex = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount - 1))
        let interimMultiplier = columnIndex + 1
        
        let x = CGFloat(interimMultiplier) * cellAndSeparatorWidth - Constants.separatorWidth

        let rowIndex = index / (columnCount - 1)
//        print(rowHeights)
        if rowHeights[safe: rowIndex] == nil {
            return CGRect.zero
        }

        let y = rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        var separatorHeight = rowHeights[rowIndex]
//        print(String(index + 1) + " " + String(cellCount) + " " + String(columnCount) + " " + String(cellCount / columnCount) + " " + String((cellCount - 1) - (cellCount / columnCount)))
//        let maxPossibleIndex = cellCount - ((cellCount - 1) / columnCount)
        let nextIndex = index + 1
        if nextIndex >= maxSeparatorIndex {
            separatorHeight = 0
        }

        let frame = CGRect(x: x, y: y, width: Constants.separatorWidth, height: separatorHeight)
        return frame

//        let index = indexPath.row
//        let interimMultiplier = index + 1
//
//        var lastRowCellCount = CGFloat(cellCount).truncatingRemainder(dividingBy: CGFloat(columnCount))
//        if lastRowCellCount == 0 {
//            lastRowCellCount = CGFloat(columnCount)
//        }
//        let lastCellColumnIndex = Int(lastRowCellCount - 1)
//
//        var separatorHeight = collectionViewContentSize.height
//        let hasCellsOnBothSides = index < lastCellColumnIndex
//        if !hasCellsOnBothSides {
//            separatorHeight -= rowHeights.last ?? 0
//        }
//
//        let x = CGFloat(interimMultiplier) * cellAndSeparatorWidth - Constants.separatorWidth
//        let frame = CGRect(x: x, y: 0, width: Constants.separatorWidth, height: separatorHeight)
//        return frame
    }
    
}
