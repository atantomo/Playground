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

        static let verticalSeparatorWidth: CGFloat = 1
        static let horizontalSeparatorHeight: CGFloat = 1
        static let separatorZIndex: Int = -10
    }

    private struct CellIndexRange {
        let minColumnIndex: Int
        let maxColumnIndex: Int
        let minRowIndex: Int
        let maxRowIndex: Int
    }

    var columnCount: Int = 0
    var cellWidth: CGFloat = 0

    var cellHeights: [CGFloat] = [CGFloat]()
    var rowHeights: [CGFloat] = [CGFloat]()

//    private var models: [DynamicCollectionCellModel] = [DynamicCollectionCellModel]()

    var cellCount: Int {
        return cellHeights.count
    }

    var verticalSeparatorCount: Int {
        let fullRowSeparatorCount = cellCount / columnCount * (columnCount - 1)

        let lastRowRemainderCellsCount = cellCount % columnCount
        if lastRowRemainderCellsCount != 0 {
            let lastRowSeparatorCount = lastRowRemainderCellsCount - 1
            return fullRowSeparatorCount + lastRowSeparatorCount
        } else {
            return fullRowSeparatorCount
        }
    }

    var horizontalSeparatorCount: Int {
        let excludingMultiLineLastRowCount = cellCount - columnCount
        if excludingMultiLineLastRowCount < 0 {
            return 0
        } else {
            return excludingMultiLineLastRowCount
        }
    }

    var cellAndVerticalSeparatorWidth: CGFloat {
        return cellWidth + Constants.verticalSeparatorWidth
    }

    var associatedCollectionView: UICollectionView?
    var measurementCell: HeightCalculable?

    override init() {
        super.init()
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "verticalDecoration")
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "horizontalDecoration")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "verticalDecoration")
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: "horizontalDecoration")
    }

    override var collectionViewContentSize: CGSize {
        let contentWidth = associatedCollectionView?.bounds.size.width ?? 0
        let contentHeight = Constants.horizontalSeparatorHeight * CGFloat(rowHeights.count - 1) + rowHeights.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight);
        return contentSize
    }

    func prepareNecessary() {
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

    func appendHeights(with newModels: [DynamicCollectionCellModel])  {

//        print(cellWidth)

        let cellHeights = newModels.map { model -> CGFloat in
            let height = measurementCell?.heightForWidth(width: cellWidth, model: model) ?? 0
            return height
        }

//        print(cellCount)
//        print(columnCount)

        var currentLastRowHeight: CGFloat = 0.0
        let currentLastRowRemainderCellsCount = cellCount % columnCount

        if currentLastRowRemainderCellsCount != 0 {
            currentLastRowHeight = self.rowHeights.popLast() ?? 0.0
        }

//        print(currentLastRowRemainderCellsCount)
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

        self.cellHeights.append(contentsOf: cellHeights)
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

    func removeHeight(at index: Int) {
        self.cellHeights.remove(at: index)

        let rowIndex = index / columnCount

        var rowHeights = [CGFloat]()
        let leftmostModelIndex = rowIndex * columnCount
        for i in stride(from: leftmostModelIndex, to: cellHeights.count, by: columnCount) {

            let leftmostCellIndex = i
            let rightmostCellIndex = (columnCount - 1) + i

            let height = getMaxHeight(leftmostCellIndex: leftmostCellIndex, tentativeRightmostCellIndex: rightmostCellIndex, cellHeights: cellHeights)
            rowHeights.append(height)
        }
        let heights = Array(self.rowHeights[0..<rowIndex]) + rowHeights
        self.rowHeights = heights
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

        let verticalSeparatorIndexPaths = indexPathsOfVerticalSeparator(in: range)
        for verticalSeparatorIndexPath in verticalSeparatorIndexPaths {
            if let attributes = layoutAttributesForDecorationView(ofKind: "verticalDecoration", at: verticalSeparatorIndexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let horizontalSeparatorIndexPaths = indexPathsOfHorizontalSeparator(in: range)
        for horizontalSeparatorIndexPath in horizontalSeparatorIndexPaths {
            if let attributes = layoutAttributesForDecorationView(ofKind: "horizontalDecoration", at: horizontalSeparatorIndexPath) {
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
        if elementKind == "verticalDecoration" {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            attributes.frame = frameForVerticalSeparator(at: indexPath)
            attributes.zIndex = Constants.separatorZIndex
            return attributes
        } else {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
            attributes.frame = frameForHorizontalSeparator(at: indexPath)
            attributes.zIndex = Constants.separatorZIndex
            return attributes
        }
    }

    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        if elementKind == "verticalDecoration" {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: decorationIndexPath)
            attributes.frame = frameForVerticalSeparator(at: decorationIndexPath)
            attributes.zIndex = -10
            return attributes
        } else {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: decorationIndexPath)
            attributes.frame = frameForHorizontalSeparator(at: decorationIndexPath)
            attributes.zIndex = -10
            return attributes
        }
    }

    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if elementKind == "verticalDecoration" {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: decorationIndexPath)
            attributes.frame = frameForVerticalSeparator(at: decorationIndexPath)
            attributes.zIndex = -10
            return attributes
        } else {
            let attributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: decorationIndexPath)
            attributes.frame = frameForHorizontalSeparator(at: decorationIndexPath)
            attributes.zIndex = -10
            return attributes
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = associatedCollectionView?.bounds
        let areBoundsChanged = newBounds.width != oldBounds?.width
        return areBoundsChanged
    }

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
        let totalWidth = associatedCollectionView?.bounds.size.width ?? 0.0
        let separatorCount = columnCount - 1

        let contentWidth = totalWidth - Constants.verticalSeparatorWidth * CGFloat(separatorCount)
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

    private func indexPathsOfVerticalSeparator(in range: CellIndexRange) -> [IndexPath] {

        var firstColumnIndexes = [Int]()
        for i in range.minRowIndex...range.maxRowIndex {
            let firstColumnIndex = range.minColumnIndex + i * (columnCount - 1)
            if firstColumnIndex < verticalSeparatorCount {
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

    private func indexPathsOfHorizontalSeparator(in range: CellIndexRange) -> [IndexPath] {

        var firstColumnIndexes = [Int]()
        for i in range.minRowIndex...range.maxRowIndex {
            let firstColumnIndex = range.minColumnIndex + i * columnCount
            firstColumnIndexes.append(firstColumnIndex)
        }

        var indexes = [Int]()
        for i in 0...(range.maxColumnIndex - range.minColumnIndex) {
            for firstColumnIndex in firstColumnIndexes {
                let columnIndex = firstColumnIndex + i
                if columnIndex < cellCount - columnCount {
                    indexes.append(columnIndex)
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

        let columnIndex = Int(xPositionWithOffset / cellAndVerticalSeparatorWidth)
        return columnIndex
    }

    private func rowIndexFromYCoordinate(yPosition: CGFloat) -> Int {
        guard !rowHeights.isEmpty else {
            return 0
        }
        var yPositionMutable = yPosition
        for (rowIndex, rowHeight) in rowHeights.enumerated() {
            yPositionMutable -= (rowHeight + Constants.horizontalSeparatorHeight)
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
        let x = columnIndexCGFloat * cellAndVerticalSeparatorWidth

        let rowIndex = index / columnCount
        let y = Constants.horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let cellHeight = rowHeights[rowIndex]

        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
//        print(frame)
        return frame
    }

    private func frameForVerticalSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount - 1))
        let interimMultiplier = columnIndexCGFloat + 1
        let x = interimMultiplier * cellAndVerticalSeparatorWidth - Constants.verticalSeparatorWidth

        let rowIndex = index / (columnCount - 1)
        if rowIndex >= rowHeights.count {
            return CGRect.zero
        }
        let y = Constants.horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        var separatorHeight: CGFloat = 0
        if index < verticalSeparatorCount {
            separatorHeight = rowHeights[rowIndex]
        }

        let frame = CGRect(x: x, y: y, width: Constants.verticalSeparatorWidth, height: separatorHeight)
        return frame
    }

    private func frameForHorizontalSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndexCGFloat * cellAndVerticalSeparatorWidth

        let rowIndex = index / columnCount
        let y = Constants.horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0...rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }

        let frame = CGRect(x: x, y: y, width: cellWidth, height: Constants.horizontalSeparatorHeight)
        return frame
    }
    
}
