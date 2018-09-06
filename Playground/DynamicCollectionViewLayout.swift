//
//  DynamicCollectionViewLayout.swift
//  Playground
//
//  Created by TANTOMO Andrew-Getty[FRJP:Digital Business Transformation Services](Tantomo Andrew) on 2018/08/14.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

//public extension Array {
//    subscript(safe idx: Int) -> Element? {
//        return idx < endIndex ? self[idx] : nil
//    }
//}

class DynamicCollectionViewLayout: UICollectionViewLayout {

    var portraitColumnCount: Int = 2

    private struct Constants {
//        static let portraitColumnCount: Int = 1
        static let landscapeColumnCount: Int = 4

        static let separatorWidth: CGFloat = 1
        static let separatorZIndex: Int = 10
    }

    private struct CellIndexRange {
        let minColumnIndex: Int
        let maxColumnIndex: Int
        let minRowIndex: Int
        let maxRowIndex: Int
    }

    var columnCount: Int = 0
    var cellWidth: CGFloat = 0
    var rowHeights: [CGFloat] = [CGFloat]()

    private var models: [DynamicCollectionCellModel] = [DynamicCollectionCellModel]()

    var cellCount: Int {
        return models.count
    }

    var separatorCount: Int {
        let fullRowSeparatorCount = cellCount / columnCount * (columnCount - 1)

        let lastRowRemainderCellsCount = cellCount % columnCount
        if lastRowRemainderCellsCount != 0 {
            let lastRowSeparatorCount = lastRowRemainderCellsCount - 1
            return fullRowSeparatorCount + lastRowSeparatorCount
        } else {
            return fullRowSeparatorCount
        }
    }

    var cellAndSeparatorWidth: CGFloat {
        return cellWidth + Constants.separatorWidth
    }
    
    var measurementCell: HeightCalculable?

    override init() {
        super.init()
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "decoration")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "decoration")
    }

    override var collectionViewContentSize: CGSize {
        let contentWidth = associatedCollectionView?.bounds.size.width ?? 0
        let contentHeight = rowHeights.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight);
        return contentSize;
    }

    override func prepare() {
        columnCount = calculateColumnCount()
        cellWidth = calculateCellWidth()
//        updateRowHeights(models: models)
//        if rowHeights.isEmpty {
//            rowHeights = calculateRowHeights(models: models)
//        }
//
//        if needsInitialization {
//            needsInitialization = false
//            appendModels(newModels: models)
//        }
    }

//    var needsInitialization: Bool = false
//
//    func setupInitialModels(newModels: [DynamicCollectionCellModel])  {
//        models = newModels
//        needsInitialization = true
//    }

    func appendModels(newModels: [DynamicCollectionCellModel])  {

        prepare()

        let cellHeights = newModels.map { model -> CGFloat in
            let height = measurementCell?.heightForWidth(width: cellWidth, model: model) ?? 0
            return height
        }

        print(cellCount)
        print(columnCount)

        var currentLastRowHeight: CGFloat = 0.0
        let currentLastRowRemainderCellsCount = cellCount % columnCount

        if currentLastRowRemainderCellsCount != 0 {
            currentLastRowHeight = self.rowHeights.popLast() ?? 0.0
        }

        print(currentLastRowRemainderCellsCount)
        let newFirstRowLeftmostModelIndex = 0
        let newFirstRowRightmostModelIndex = (columnCount - 1) - currentLastRowRemainderCellsCount

        let height = getMaxHeight(leftmostCellIndex: newFirstRowLeftmostModelIndex, tentativeRightmostCellIndex: newFirstRowRightmostModelIndex, cellHeights: cellHeights, extraComparisonHeight: currentLastRowHeight)
        self.rowHeights.append(height)

        var rowHeights = [CGFloat]()
        let newSecondRowLeftmostModelIndex = newFirstRowRightmostModelIndex + 1
        for i in stride(from: newSecondRowLeftmostModelIndex, to: newModels.count, by: columnCount) {

            let leftmostCellIndex = i
            let rightmostCellIndex = (columnCount - 1) + i

            let height = getMaxHeight(leftmostCellIndex: leftmostCellIndex, tentativeRightmostCellIndex: rightmostCellIndex, cellHeights: cellHeights)
            rowHeights.append(height)
        }
        self.rowHeights.append(contentsOf: rowHeights)

        models.append(contentsOf: newModels)
    }

    func getMaxHeight(leftmostCellIndex: Int, tentativeRightmostCellIndex: Int, cellHeights: [CGFloat], extraComparisonHeight: CGFloat = 0.0) -> CGFloat {

        var rightmostCellIndex = tentativeRightmostCellIndex
        let modelLastIndex = cellHeights.count - 1

        let cellExistsAtRightmostIndex = rightmostCellIndex <= modelLastIndex
        if !cellExistsAtRightmostIndex {
            rightmostCellIndex = modelLastIndex
        }
        let maxCellHeight = ([extraComparisonHeight] + cellHeights[leftmostCellIndex...rightmostCellIndex]).max() ?? 0
        return maxCellHeight
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        let range = calculateCellIndexRange(in: rect)

        let cellIndexPaths = indexPathsOfCells(in: range)
        for cellIndexPath in cellIndexPaths {
            if let attributes = layoutAttributesForItem(at: cellIndexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let separatorIndexPaths = indexPathsOfSeparator(in: range)
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

    var associatedCollectionView: UICollectionView?

    private func calculateColumnCount() -> Int {
        let width = associatedCollectionView?.bounds.size.width ?? 0
        let height = associatedCollectionView?.bounds.size.height ?? 0
        if width < height {
            return portraitColumnCount
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
            let height = measurementCell?.heightForWidth(width: cellWidth, model: model) ?? 0
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

    private func calculateCellIndexRange(in rect: CGRect) -> CellIndexRange {
        let minColumnIndex = columnIndexFromXCoordinate(xPosition: rect.minX)
        let maxColumnIndex = columnIndexFromXCoordinate(xPosition: rect.maxX)

        let minRowIndex = rowIndexFromYCoordinate(yPosition: rect.minY)
        let maxRowIndex = rowIndexFromYCoordinate(yPosition: rect.maxY)

        let range = CellIndexRange(minColumnIndex: minColumnIndex, maxColumnIndex: maxColumnIndex, minRowIndex: minRowIndex, maxRowIndex: maxRowIndex)
        return range
    }

    private func indexPathsOfCells(in range: CellIndexRange) -> [IndexPath] {

        var firstColumnIndexes = [Int]()
        for i in range.minRowIndex...range.maxRowIndex {
            let firstColumnIndex = range.minColumnIndex + i * columnCount
            firstColumnIndexes.append(firstColumnIndex)
        }

        var indexes = [Int]()
        for i in 0...(range.maxColumnIndex - range.minColumnIndex) {
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

    private func indexPathsOfSeparator(in range: CellIndexRange) -> [IndexPath] {

        var firstColumnIndexes = [Int]()
        for i in range.minRowIndex...range.maxRowIndex {
            let firstColumnIndex = range.minColumnIndex + i * (columnCount - 1)
            if firstColumnIndex < separatorCount {
                firstColumnIndexes.append(firstColumnIndex)
            }
        }

        var indexes = [Int]()
        if (range.maxColumnIndex - range.minColumnIndex - 1) >= 0 {
            for i in 0...(range.maxColumnIndex - range.minColumnIndex - 1) {
                for firstColumnIndex in firstColumnIndexes {
                    let columnIndex = firstColumnIndex + i
                    if columnIndex < cellCount {
                        indexes.append(columnIndex)
                    }
                }
            }
        }
        let indexPaths = indexes.map { index in
            return IndexPath(row: index, section: 0)
        }
        return indexPaths
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

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndexCGFloat * cellAndSeparatorWidth

        let rowIndex = index / columnCount
        let y = rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let cellHeight = rowHeights[rowIndex]

        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
//        print(frame)
        return frame
    }

    private func frameForSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount - 1))
        let interimMultiplier = columnIndexCGFloat + 1
        let x = interimMultiplier * cellAndSeparatorWidth - Constants.separatorWidth

        let rowIndex = index / (columnCount - 1)
        if rowIndex >= rowHeights.count {
            return CGRect.zero
        }
        let y = rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        var separatorHeight: CGFloat = 0
        if index < separatorCount {
            separatorHeight = rowHeights[rowIndex]
        }

        let frame = CGRect(x: x, y: y, width: Constants.separatorWidth, height: separatorHeight)
        return frame
    }
    
}
