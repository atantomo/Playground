//
//  BasicBarChartPresenter.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 22/5/19.
//  Copyright © 2019 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

class BasicBarChartPresenter {

    var barWidth: CGFloat = 40.0
    var space: CGFloat = 20.0

    var barDataEntries: [DataEntry] = []
    var pointDataEntries: [DataEntry] = []

    private let topSpace: CGFloat = 40.0
    private let bottomSpace: CGFloat = 40.0

    func computeContentWidth() -> CGFloat {
        if barDataEntries.isEmpty {
            return .zero
        }
        return (barWidth + space) * CGFloat(barDataEntries.count) + space
    }

    func computeBaseY(viewHeight: CGFloat) -> CGFloat {
        return viewHeight - bottomSpace
    }

    func computeBarEntries(viewHeight: CGFloat) -> [BarEntry] {
        var result: [BarEntry] = []

        for (index, entry) in barDataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * (viewHeight - bottomSpace - topSpace)
            let xPosition: CGFloat = space + CGFloat(index) * (barWidth + space)
            let yPosition = viewHeight - bottomSpace - entryHeight
            let origin = CGPoint(x: xPosition, y: yPosition)

            let barEntry = BarEntry(origin: origin, barWidth: barWidth, barHeight: entryHeight, space: space, data: entry)
            result.append(barEntry)
        }
        return result
    }

    func computePointEntries(viewHeight: CGFloat) -> [PointEntry] {
        var result: [PointEntry] = []

        for (index, entry) in pointDataEntries.enumerated() {
            let entryHeight = CGFloat(entry.height) * (viewHeight - bottomSpace - topSpace)
            let xPosition: CGFloat = space + CGFloat(index) * (barWidth + space) + barWidth / 2
            let yPosition = viewHeight - bottomSpace - entryHeight
            let origin = CGPoint(x: xPosition, y: yPosition)

            let pointEntry = PointEntry(origin: origin, data: entry)
            result.append(pointEntry)
        }
        if var initialEntry = result.first,
            var lastEntry = result.last {
            initialEntry.origin.x -= (barWidth + space) / 2
            lastEntry.origin.x += (barWidth + space) / 2
            return [initialEntry] + result + [lastEntry]
        }
        return result
    }

    func computeHorizontalLines(viewHeight: CGFloat) -> [HorizontalLine] {
        var result: [HorizontalLine] = []

        let horizontalLineInfos = [
            (value: CGFloat(0.0), isDashed: false),
            (value: CGFloat(0.25), isDashed: true),
            (value: CGFloat(0.5), isDashed: true),
            (value: CGFloat(0.75), isDashed: true),
            (value: CGFloat(1.0), isDashed: false)
        ]

        for lineInfo in horizontalLineInfos {
            let yPosition = viewHeight - bottomSpace -  lineInfo.value * (viewHeight - bottomSpace - topSpace)

            let length = self.computeContentWidth()
            let lineSegment = LineSegment(startPoint: CGPoint(x: 0, y: yPosition), endPoint: CGPoint(x: length, y: yPosition))
            let line = HorizontalLine(segment: lineSegment, isDashed: lineInfo.isDashed, width: 0.5)
            result.append(line)
        }
        return result
    }

}
