//
//  DynamicCollectionViewLayout.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/08/14.
//  Copyright © 2018 Andrew Tantomo. All rights reserved.
//

import UIKit

class DynamicCollectionViewLayout<T: HeightCalculable>: UICollectionViewLayout {

    typealias TextCalculationModel = T.T
    typealias CellIndexRange = (minColumnIndex: Int, maxColumnIndex: Int, minRowIndex: Int, maxRowIndex: Int)
    
    var portraitColumnCount: Int = 2
    var landscapeColumnCount: Int = 4

    var verticalSeparatorWidth: CGFloat = 1
    var horizontalSeparatorHeight: CGFloat = 1

    let verticalSeparatorIdentifier: String = "verticalSeparator"
    let horizontalSeparatorIdentifier: String = "horizontalSeparator"
    let separatorZIndex: Int = -10

    var models: ChangeTracerArray<TextCalculationModel> = ChangeTracerArray<TextCalculationModel>() {
        didSet {
            updateHeights()
        }
    }

    var columnCount: Int = 0
    var cellWidth: CGFloat = 0

    var cellHeights: [CGFloat] = [CGFloat]()
    var rowHeights: [CGFloat] = [CGFloat]()

    var associatedCollectionView: UICollectionView?
    var measurementCell: T?

    var needsCompleteCalculation: Bool = true

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
        return cellWidth + verticalSeparatorWidth
    }

    override init() {
        super.init()
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: verticalSeparatorIdentifier)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: verticalSeparatorIdentifier)
        register(UINib(nibName: "PillarCollectionReusableView", bundle: nil), forDecorationViewOfKind: horizontalSeparatorIdentifier)
    }

    override var collectionViewContentSize: CGSize {
        let contentWidth = associatedCollectionView?.bounds.size.width ?? 0
        let contentHeight = horizontalSeparatorHeight * CGFloat(rowHeights.count - 1) + rowHeights.reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let contentSize = CGSize(width: contentWidth, height: contentHeight);
        return contentSize
    }

    override func prepare() {
        super.prepare()
        if needsCompleteCalculation {
            needsCompleteCalculation = false

            columnCount = calculateColumnCount()
            cellWidth = calculateCellWidth()
            cellHeights = calculateCellHeights()
            rowHeights = calculateRowHeights()
        }
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        invalidateLayout()
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
            if let attributes = layoutAttributesForDecorationView(ofKind: verticalSeparatorIdentifier, at: verticalSeparatorIndexPath) {
                layoutAttributes.append(attributes)
            }
        }

        let horizontalSeparatorIndexPaths = indexPathsOfHorizontalSeparator(in: range)
        for horizontalSeparatorIndexPath in horizontalSeparatorIndexPaths {
            if let attributes = layoutAttributesForDecorationView(ofKind: horizontalSeparatorIdentifier, at: horizontalSeparatorIndexPath) {
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
        attributes.zIndex = separatorZIndex

        switch elementKind {
        case verticalSeparatorIdentifier:
            attributes.frame = frameForVerticalSeparator(at: indexPath)
            return attributes
        case horizontalSeparatorIdentifier:
            attributes.frame = frameForHorizontalSeparator(at: indexPath)
            return attributes
        default:
            return nil
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = associatedCollectionView?.bounds
        let areBoundsChanged = newBounds.width != oldBounds?.width
        if areBoundsChanged {
            needsCompleteCalculation = true
        }
        return areBoundsChanged
    }

    override func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        needsCompleteCalculation = true
    }

    private func calculateColumnCount() -> Int {
        let width = associatedCollectionView?.bounds.size.width ?? 0
        let height = associatedCollectionView?.bounds.size.height ?? 0
        if width < height {
            return portraitColumnCount
        } else {
            return landscapeColumnCount
        }
    }

    private func calculateCellWidth() -> CGFloat {
        let totalWidth = associatedCollectionView?.bounds.size.width ?? 0.0
        let separatorCount = columnCount - 1

        let contentWidth = totalWidth - verticalSeparatorWidth * CGFloat(separatorCount)
        let width = contentWidth / CGFloat(columnCount)
        return width
    }

    private func calculateCellHeights() -> [CGFloat] {
        let cellHeights = models.map { model -> CGFloat in
            let height = measurementCell?.heightForWidth(width: cellWidth, model: model) ?? 0
            return height
        }
        return cellHeights
    }

    private func calculateRowHeights() -> [CGFloat] {
        var rowHeights = [CGFloat]()
        for i in stride(from: 0, to: cellCount, by: columnCount) {

            let leftmostCellIndex = i
            let rightmostCellIndex = i + columnCount - 1

            let height = getMaxHeight(leftmostCellIndex: leftmostCellIndex, tentativeRightmostCellIndex: rightmostCellIndex, cellHeights: cellHeights)
            rowHeights.append(height)
        }
        return rowHeights
    }

    private func calculateCellIndexRange(in rect: CGRect) -> CellIndexRange {
        let minColumnIndex = columnIndexFromXCoordinate(xPosition: rect.minX)
        let maxColumnIndex = columnIndexFromXCoordinate(xPosition: rect.maxX)

        let minRowIndex = rowIndexFromYCoordinate(yPosition: rect.minY)
        let maxRowIndex = rowIndexFromYCoordinate(yPosition: rect.maxY)

        let range = (minColumnIndex: minColumnIndex, maxColumnIndex: maxColumnIndex, minRowIndex: minRowIndex, maxRowIndex: maxRowIndex)
        return range
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
            yPositionMutable -= (rowHeight + horizontalSeparatorHeight)
            if yPositionMutable <= 0 {
                return rowIndex
            }
        }
        let lastRowIndex = rowHeights.count - 1
        return lastRowIndex
    }

    private func updateHeights() {
        guard !needsCompleteCalculation else {
            return
        }
        switch models.latestChange {
        case .insert(let indexes):
            appendHeights(at: indexes)
        case .delete(let indexes):
            removeHeights(at: indexes)
        case .set:
            break
        }
    }

    private func appendHeights(at indexes: [Int])  {
        let newMinCellIndex = indexes.min() ?? 0
        let newMaxCellIndex = indexes.max() ?? 0

        for index in indexes {
            let height = measurementCell?.heightForWidth(width: cellWidth, model: models[index]) ?? 0
            cellHeights.insert(height, at: index)
        }

        let currentLastRowIndex = newMinCellIndex / columnCount
        let currentLastRowRemainderCellsCount = newMinCellIndex % columnCount

        var currentLastRowHeight: CGFloat = 0.0
        if currentLastRowIndex < self.rowHeights.count {
            currentLastRowHeight = self.rowHeights[currentLastRowIndex]
        }

        let newFirstRowLeftmostCellIndex = newMinCellIndex
        let newFirstRowRightmostCelIndex = newMinCellIndex + (columnCount - 1) - currentLastRowRemainderCellsCount

        let newFirstRowHeight = getMaxHeight(leftmostCellIndex: newFirstRowLeftmostCellIndex, tentativeRightmostCellIndex: newFirstRowRightmostCelIndex, cellHeights: cellHeights, extraComparisonHeight: currentLastRowHeight)

        var newSecondRowOnwardHeights = [CGFloat]()
        let newSecondRowLeftmostCellIndex = newFirstRowRightmostCelIndex + 1
        for i in stride(from: newSecondRowLeftmostCellIndex, to: newMaxCellIndex + 1, by: columnCount) {

            let leftmostCellIndex = i
            let rightmostCellIndex = (columnCount - 1) + i

            let height = getMaxHeight(leftmostCellIndex: leftmostCellIndex, tentativeRightmostCellIndex: rightmostCellIndex, cellHeights: cellHeights)
            newSecondRowOnwardHeights.append(height)
        }

        let heights = Array(self.rowHeights[0..<currentLastRowIndex]) + [newFirstRowHeight] + newSecondRowOnwardHeights
        self.rowHeights = heights
    }

    private func removeHeights(at indexes: [Int]) {
        for index in indexes {
            self.cellHeights.remove(at: index)
        }

        let newMinCellIndex = indexes.min() ?? 0
        let deletionTopmostRowIndex = newMinCellIndex / columnCount

        var recalculatedRowHeights = [CGFloat]()
        let deletionTopmostLeftmostCellIndex = deletionTopmostRowIndex * columnCount
        for i in stride(from: deletionTopmostLeftmostCellIndex, to: cellHeights.count, by: columnCount) {

            let leftmostCellIndex = i
            let rightmostCellIndex = (columnCount - 1) + i

            let height = getMaxHeight(leftmostCellIndex: leftmostCellIndex, tentativeRightmostCellIndex: rightmostCellIndex, cellHeights: cellHeights)
            recalculatedRowHeights.append(height)
        }
        let heights = Array(self.rowHeights[0..<deletionTopmostRowIndex]) + recalculatedRowHeights
        self.rowHeights = heights
    }

    private func getMaxHeight(leftmostCellIndex: Int, tentativeRightmostCellIndex: Int, cellHeights: [CGFloat], extraComparisonHeight: CGFloat = 0.0) -> CGFloat {

        var rightmostCellIndex = tentativeRightmostCellIndex
        let modelLastIndex = cellHeights.count - 1

        let cellExistsAtRightmostIndex = rightmostCellIndex <= modelLastIndex
        if !cellExistsAtRightmostIndex {
            rightmostCellIndex = modelLastIndex
        }
        let maxCellHeight = ([extraComparisonHeight] + cellHeights[leftmostCellIndex...rightmostCellIndex]).max() ?? 0
        return maxCellHeight
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

    private func frameForCell(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndexCGFloat * cellAndVerticalSeparatorWidth

        let rowIndex = index / columnCount
        let y = horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        let cellHeight = rowHeights[rowIndex]

        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        return frame
    }

    private func frameForVerticalSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount - 1))
        let interimCountOffset = columnIndexCGFloat + 1
        let x = interimCountOffset * cellAndVerticalSeparatorWidth - verticalSeparatorWidth

        let rowIndex = index / (columnCount - 1)
        if rowIndex >= rowHeights.count {
            return CGRect.zero
        }
        let y = horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0..<rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }
        var separatorHeight: CGFloat = 0
        if index < verticalSeparatorCount {
            separatorHeight = rowHeights[rowIndex]
        }

        let frame = CGRect(x: x, y: y, width: verticalSeparatorWidth, height: separatorHeight)
        return frame
    }

    private func frameForHorizontalSeparator(at indexPath: IndexPath) -> CGRect {
        let index = indexPath.row

        let columnIndexCGFloat = CGFloat(index).truncatingRemainder(dividingBy: CGFloat(columnCount))
        let x = columnIndexCGFloat * cellAndVerticalSeparatorWidth

        let rowIndex = index / columnCount
        if rowIndex >= rowHeights.count {
            return CGRect.zero
        }
        let y = horizontalSeparatorHeight * CGFloat(rowIndex) + rowHeights[0...rowIndex].reduce(0) { lhs, rhs in
            return lhs + rhs
        }

        let frame = CGRect(x: x, y: y, width: cellWidth, height: horizontalSeparatorHeight)
        return frame
    }
    
}
