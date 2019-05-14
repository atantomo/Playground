//
//  CollectionIndexRangeViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/10/21.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class CollectionIndexRangeViewController: UIViewController {

    @IBOutlet var cellFrames: [UIView]!
    @IBOutlet var verticalSeparatorFrames: [UIView]!
    @IBOutlet var horizontalSeparatorFrames: [UIView]!
    @IBOutlet weak var randomRangeView: UIView!

    @IBOutlet weak var coralBox: UIView!
    @IBOutlet weak var pinkBox: UIView!
    @IBOutlet weak var tealBox: UIView!
    @IBOutlet weak var grayBox: UIView!

    var columnCount: Int = 3
    var columnWidth: CGFloat = 88.0
    var verticalSeparatorWidth: CGFloat = 10.0
    var horizontalSeparatorHeight: CGFloat = 10.0

    lazy var rowHeights: [CGFloat] = {
        Array(repeating: CGFloat(88.0), count: 8)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.bringSubview(toFront: randomRangeView)
        pinkBox.layer.zPosition = -10
        tealBox.layer.zPosition = 0
        grayBox.layer.zPosition = 1
        coralBox.layer.zPosition = -200
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        var loopXPosition: CGFloat = 0
//        var loopYPosition: CGFloat = 0
//        var cellIndexes = [Int]()
//        var verticalSeparatorIndexes = [Int]()
//        var horizontalSeparatorIndexes = [Int]()
//
//        let rect = randomRangeView.frame
//
//        let rowCount = Int(ceil(CGFloat(rowHeights.count) / CGFloat(columnCount)))
//
//        var isVerticalSeparatorOnlyColumn = false
//        for columnIndex in 0..<columnCount {
//
//            if columnIndex != 0 {
//                loopXPosition += verticalSeparatorWidth
////                print(rect.minX)
////                print(rect.maxX)
////                print(loopXPosition)
//                if rect.minX <= loopXPosition || rect.maxX <= loopXPosition {
//                    verticalSeparatorIndexes.append(columnIndex)
//                }
//                if rect.maxX <= loopXPosition {
//                    isVerticalSeparatorOnlyColumn = true
//                }
//            }
//            loopXPosition += columnWidth
////            if rect.minX <= loopXPosition || rect.maxX <= loopXPosition {
////                cellIndexes.append(columnIndex)
////            }
//
//
//            for rowIndex in 0..<rowCount {
//
//                let cellIndex = columnCount * rowIndex + columnIndex
//                if rowIndex != 0 {
//                    loopYPosition += horizontalSeparatorHeight
//                    if rect.minY <= loopYPosition || rect.maxY <= loopYPosition {
//                        horizontalSeparatorIndexes.append(cellIndex)
//                    }
//                }
//                loopYPosition += 88.0
//                if rect.minY <= loopYPosition || rect.maxY <= loopYPosition {
//                    cellIndexes.append(cellIndex)
//                }
//            }
//
//            if rect.maxX <= loopXPosition {
//                break
//            }
//        }
//
//        print(("verticalSeparatorIndexes", verticalSeparatorIndexes))
//        print(("horizontalSeparatorIndexes", horizontalSeparatorIndexes))
//        print(("cellIndexes", cellIndexes))
//    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let execute = {
            print("Love")
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5, execute: execute)
        
        var loopYPosition: CGFloat = 0
        var cellIndexes = [Int]()
        var verticalSeparatorIndexes = [Int]()
        var horizontalSeparatorIndexes = [Int]()

        let rect = randomRangeView.frame

        let rowCount = Int(ceil(CGFloat(rowHeights.count) / CGFloat(columnCount)))
        let separatorAndCellRowCount = rowCount * 2 - 1
        let separatorAndCellColumnCount = columnCount * 2 - 1

        var cellRowIndex = 0
        var cellColumnIndex = 0
        var separatorRowIndex = 1
        var separatorColumnIndex = 1


        var minRowVerticalSeparatorOrBlankIndexes = [Int]()
        var minRowHorizontalSeparatorOrCellIndexes = [Int]()

        var loopXPosition: CGFloat = 0

        for columnIndex in 0..<separatorAndCellColumnCount {
            let isSeparatorColumnIndex = (columnIndex % 2 != 0)

            if isSeparatorColumnIndex {
                loopXPosition += verticalSeparatorWidth
                if rect.minX <= loopXPosition || rect.maxX <= loopXPosition {
                    minRowVerticalSeparatorOrBlankIndexes.append(separatorColumnIndex)
                }
                separatorColumnIndex += 1
            } else {
//                print(rect.minX)
//                print(rect.maxX)
//                print(loopXPosition)
                loopXPosition += columnWidth
                if rect.minX <= loopXPosition || rect.maxX <= loopXPosition {
                    minRowHorizontalSeparatorOrCellIndexes.append(cellColumnIndex)
                }
                cellColumnIndex += 1
            }
            if rect.maxX <= loopXPosition {
                break
            }
        }

        for rowIndex in 0..<separatorAndCellRowCount {
            let isSeparatorRowIndex = (rowIndex % 2 != 0)
            if isSeparatorRowIndex {
//                print(rect.minY)
//                print(rect.maxY)
//                print(loopYPosition)
                loopYPosition += horizontalSeparatorHeight
                if rect.minY <= loopYPosition || rect.maxY <= loopYPosition {
                    for i in minRowHorizontalSeparatorOrCellIndexes {
                        let cellIndex = separatorRowIndex * columnCount + i
                        if cellIndex < rowHeights.count {
                            horizontalSeparatorIndexes.append(cellIndex)
                        }
                    }
                }
                separatorRowIndex += 1
            } else {
                loopYPosition += 88.0
                if rect.minY <= loopYPosition || rect.maxY <= loopYPosition {
                    for i in minRowVerticalSeparatorOrBlankIndexes {
                        let cellIndex = cellRowIndex * columnCount + i
                        if cellIndex < rowHeights.count {
                            verticalSeparatorIndexes.append(cellIndex)
                        }
                    }
                    for i in minRowHorizontalSeparatorOrCellIndexes {
                        let cellIndex = cellRowIndex * columnCount + i
                        if cellIndex < rowHeights.count {
                            cellIndexes.append(cellIndex)
                        }
                    }
                }
                cellRowIndex += 1
            }
            if rect.maxY <= loopYPosition {
                break
            }
        }

        print(("minRowVerticalSeparatorOrBlankIndexes", minRowVerticalSeparatorOrBlankIndexes))
        print(("minRowHorizontalSeparatorOrCellIndexes", minRowHorizontalSeparatorOrCellIndexes))
        print(("verticalSeparatorIndexes", verticalSeparatorIndexes))
        print(("horizontalSeparatorIndexes", horizontalSeparatorIndexes))
        print(("cellIndexes", cellIndexes))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
