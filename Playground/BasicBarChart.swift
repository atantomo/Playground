//
//  BasicBarChart.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

extension Array {

    subscript(safe idx: Int) -> Element? {
        return idx < endIndex ? self[idx] : nil
    }

}

extension CALayer {

    func addCurvedLayer(path: CGPath, color: CGColor, animated: Bool, oldPath: CGPath?) {
        let layer = CAShapeLayer()
        layer.path = path
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        addSublayer(layer)

        if animated,
            let oldPath = oldPath,
            let newPath = layer.path {
            layer.animate(fromValue: oldPath, toValue: newPath, keyPath: "path")
        }
    }

    func addLineLayer(lineSegment: LineSegment, color: CGColor, width: CGFloat, isDashed: Bool, animated: Bool, oldLineSegment: LineSegment?) {
        let layer = CAShapeLayer()

        let bezierPath = UIBezierPath()
        bezierPath.move(to: lineSegment.startPoint)
        bezierPath.addLine(to: lineSegment.endPoint)
        layer.path = bezierPath.cgPath

        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = width
        if isDashed {
            layer.lineDashPattern = [4, 4]
        }
        addSublayer(layer)

        if animated,
            let oldLineSegment = oldLineSegment,
            let newPath = layer.path {

            let oldBezierPath = UIBezierPath()
            oldBezierPath.move(to: oldLineSegment.startPoint)
            oldBezierPath.addLine(to: oldLineSegment.endPoint)
            let oldPath = oldBezierPath.cgPath

            layer.animate(fromValue: oldPath, toValue: newPath, keyPath: "path")
        }
    }

    func addTextLayer(frame: CGRect, color: CGColor, fontSize: CGFloat, text: String, animated: Bool, oldFrame: CGRect?) {
        let textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.foregroundColor = color
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = kCAAlignmentCenter //CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = fontSize
        textLayer.string = text
        addSublayer(textLayer)

        if animated,
            let oldFrame = oldFrame {
            let oldPosition = CGPoint(x: oldFrame.midX, y: oldFrame.midY)
            textLayer.animate(fromValue: oldPosition, toValue: textLayer.position, keyPath: "position")
        }
    }

    func addTopRoundedRectangleLayer(frame: CGRect, color: CGColor, animated: Bool, oldFrame: CGRect?, cornerRadius: CGFloat = 4.0) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        if #available(iOS 11.0, *) {
            layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        layer.cornerRadius = cornerRadius
        addSublayer(layer)

        if animated, let oldFrame = oldFrame {
            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY), toValue: layer.position, keyPath: "position")
            layer.animate(fromValue: CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height), toValue: layer.bounds, keyPath: "bounds")
        }
    }

    func animate(fromValue: Any, toValue: Any, keyPath: String) {
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.fromValue = fromValue
        anim.toValue = toValue
        anim.duration = 0.6
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        add(anim, forKey: keyPath)
    }

}

class CurveAlgorithm {

    static let shared: CurveAlgorithm = CurveAlgorithm()

    private func controlPointsFrom(points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []

        let delta: CGFloat = 0.3 // The value that help to choose temporary control points.

        // Calculate temporary control points, these control points make Bezier segments look straight and not curving at all
        for i in 1..<points.count {
            let A = points[i - 1]
            let B = points[i]
            let controlPoint1 = CGPoint(x: A.x + delta * (B.x - A.x), y: A.y + delta * (B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta * (B.x - A.x), y: B.y - delta * (B.y - A.y))
            let curvedSegment = CurvedSegment(controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }

        // Calculate good control points
        for i in 1..<points.count - 1 {
            // Temporary control point
            let M = result[i - 1].controlPoint2

            // Temporary control point
            let N = result[i].controlPoint1

            // Central point
            let A = points[i]

            // Reflection of M over the point A
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)

            // Reflection of N over the point A
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)

            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x) / 2, y: (MM.y + N.y) / 2)
            result[i - 1].controlPoint2 = CGPoint(x: (NN.x + M.x) / 2, y: (NN.y + M.y) / 2)
        }

        return result
    }

    func createCurvedPath(_ dataPoints: [CGPoint]) -> UIBezierPath? {
        let path = UIBezierPath()
        guard let firstDataPoint = dataPoints.first else {
            return nil
        }
        path.move(to: firstDataPoint)

        var curveSegments: [CurvedSegment] = []
        curveSegments = controlPointsFrom(points: dataPoints)

        for i in 1..<dataPoints.count {
            path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i - 1].controlPoint1, controlPoint2: curveSegments[i - 1].controlPoint2)
        }
        return path
    }
}

class BarLineChart: UIView {

    private let presenter: BasicBarChartPresenter = BasicBarChartPresenter()

    private let mainLayer: CALayer = CALayer()
    private let barDataLayer: CALayer = CALayer()
    private let gridLayer: CALayer = CALayer()
    private let curveDataLayer: CALayer = CALayer()
    private let gradientLayer: CAGradientLayer = CAGradientLayer()

    private var barEntries: [BarEntry] = []
    private var pointEntries: [PointEntry] = []
    private var oldBarEntries: [BarEntry] = []
    private var oldPointEntries: [PointEntry] = []

    func loadBarDataEntries(dataEntries: [DataEntry]) {
        presenter.barDataEntries = dataEntries

        let barCountCGFloat = CGFloat(presenter.barDataEntries.count)
        let allSpacing = presenter.space * (barCountCGFloat + 1)
        let barWidth = (bounds.width - allSpacing) / barCountCGFloat
        presenter.barWidth = barWidth

        oldBarEntries = barEntries
        barEntries = presenter.computeBarEntries(viewHeight: frame.height)
    }

    func loadPointDataEntries(dataEntries: [DataEntry]) {
        presenter.pointDataEntries = dataEntries

        oldPointEntries = pointEntries
        pointEntries = presenter.computePointEntries(viewHeight: frame.height)
    }

    func updateEntries(animated: Bool) {
        removeAllSublayers(layer: gridLayer)
        removeAllSublayers(layer: barDataLayer)
        removeAllSublayers(layer: curveDataLayer)
        removeAllSublayers(layer: gradientLayer)

        let contentWidth = presenter.computeContentWidth()
        let generalFrame = CGRect(x: 0, y: 0, width: contentWidth, height: frame.size.height)
        mainLayer.frame = generalFrame
        gridLayer.frame = generalFrame
        barDataLayer.frame = generalFrame
        curveDataLayer.frame = generalFrame
        gradientLayer.frame = generalFrame

        showHorizontalLines()
        for (index, entry) in barEntries.enumerated() {
            showBarEntry(index: index, entry: entry, animated: animated, oldEntries: oldBarEntries[safe: index])
        }
        showPointEntry(entries: pointEntries, animated: animated, oldEntries: oldPointEntries)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        presenter.space = 20.0
        gradientLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor, UIColor.clear.cgColor]

        layer.addSublayer(mainLayer)
        mainLayer.addSublayer(gridLayer)
        mainLayer.addSublayer(curveDataLayer)
        mainLayer.addSublayer(gradientLayer)
        mainLayer.addSublayer(barDataLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateEntries(animated: false)
    }

    private func showBarEntry(index: Int, entry: BarEntry, animated: Bool, oldEntries: BarEntry?) {
        let cgColor = entry.data.color.cgColor

        barDataLayer.addTopRoundedRectangleLayer(frame: entry.barFrame, color: cgColor, animated: animated, oldFrame: oldEntries?.barFrame)

        barDataLayer.addTextLayer(frame: entry.bottomTitleFrame, color: cgColor, fontSize: 14, text: entry.data.title, animated: animated, oldFrame: oldEntries?.bottomTitleFrame)
    }

    private func showPointEntry(entries: [PointEntry], animated: Bool, oldEntries: [PointEntry]) {
        let mapToOrigin = { (pointEntry: PointEntry) -> CGPoint in
            return pointEntry.origin
        }
        let dataPoints = entries.map(mapToOrigin)
        let oldDataPoints = oldEntries.map(mapToOrigin)
        guard let firstDataPoint = dataPoints.first else {
            return
        }
        if let path = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            let oldPath = CurveAlgorithm.shared.createCurvedPath(oldDataPoints)
            curveDataLayer.addCurvedLayer(path: path.cgPath, color: UIColor.green.cgColor, animated: true, oldPath: oldPath?.cgPath)
        }

        let baseY = presenter.computeBaseY(viewHeight: curveDataLayer.bounds.height)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: firstDataPoint.x, y: baseY))
        path.addLine(to: firstDataPoint)
        if let curvedPath = CurveAlgorithm.shared.createCurvedPath(dataPoints) {
            path.append(curvedPath)
        }

        path.addLine(to: CGPoint(x: dataPoints[dataPoints.count - 1].x, y: baseY))
        path.addLine(to: CGPoint(x: firstDataPoint.x, y: baseY))

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillColor = UIColor.red.cgColor
        maskLayer.strokeColor = UIColor.blue.cgColor
        maskLayer.lineWidth = 0.0

        let oldPath = gradientLayer.mask as? CAShapeLayer
        gradientLayer.mask = maskLayer

        if animated,
            let newPath = maskLayer.path,
            let oldPath = oldPath?.path {
            maskLayer.animate(fromValue: oldPath, toValue: newPath,keyPath: "path")
        }
    }

    private func showHorizontalLines() {
        let lines = presenter.computeHorizontalLines(viewHeight: frame.height)
        for line in lines {
            gridLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldLineSegment: nil)
        }
    }

    private func removeAllSublayers(layer: CALayer?) {
        guard let sublayers = layer?.sublayers else {
            return
        }
        for sublayer in sublayers {
            sublayer.removeFromSuperlayer()
        }
    }

}
