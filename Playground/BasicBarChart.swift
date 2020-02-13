//
//  BasicBarChart.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 19/8/17.
//  Copyright © 2017 Nguyen Vu Nhat Minh. All rights reserved.
//

import UIKit

extension UIBezierPath {
    convenience init(curvedSegment: CurvedSegment) {
        self.init()
        move(to: curvedSegment.startPoint)
        addCurve(to: curvedSegment.toPoint, controlPoint1: curvedSegment.controlPoint1, controlPoint2: curvedSegment.controlPoint2)
        addLine(to: curvedSegment.endPoint)
    }

    convenience init(lineSegment: LineSegment) {
        self.init()
        move(to: lineSegment.startPoint)
        addLine(to: lineSegment.endPoint)
    }
}

struct DataEntry {
    let color: UIColor
    let height: Float
    let title: String
}

struct CurvedSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
    let toPoint: CGPoint
    var controlPoint1: CGPoint
    var controlPoint2: CGPoint
}

struct LineSegment {
    let startPoint: CGPoint
    let endPoint: CGPoint
}

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < count {
            return self[index]
        } else {
            return nil
        }
    }
}

extension CALayer {

    func addCurvedLayer(path: CGPath, color: CGColor, animated: Bool, oldPath: CGPath?) {
        let layer = CAShapeLayer()
        layer.path = path
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        addSublayer(layer)

        if animated, let oldPath = oldPath {
            layer.animate(
                fromValue: oldPath,
                toValue: layer.path!,
                keyPath: "path")
        }
    }

    func addLineLayer(lineSegment: LineSegment, color: CGColor, width: CGFloat, isDashed: Bool, animated: Bool, oldSegment: LineSegment?) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(lineSegment: lineSegment).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = width
        if isDashed {
            layer.lineDashPattern = [4, 4]
        }
        addSublayer(layer)

        if animated, let segment = oldSegment {
            layer.animate(
                fromValue: UIBezierPath(lineSegment: segment).cgPath,
                toValue: layer.path!,
                keyPath: "path")
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

        if animated, let oldFrame = oldFrame {
            // "frame" property is not animatable in CALayer, so, I use "position" instead
            // Position is at the center of the frame (if you don't change the anchor point)
            let oldPosition = CGPoint(x: oldFrame.midX, y: oldFrame.midY)
            textLayer.animate(fromValue: oldPosition, toValue: textLayer.position, keyPath: "position")
        }
    }

    func addCircleLayer(origin: CGPoint, radius: CGFloat, color: CGColor, animated: Bool, oldOrigin: CGPoint?) {
        let layer = CALayer()
        layer.frame = CGRect(x: origin.x, y: origin.y, width: radius * 2, height: radius * 2)
        layer.backgroundColor = color
        layer.cornerRadius = radius
        addSublayer(layer)

        if animated, let oldOrigin = oldOrigin {
            let oldFrame = CGRect(x: oldOrigin.x, y: oldOrigin.y, width: radius * 2, height: radius * 2)

            // "frame" property is not animatable in CALayer, so, I use "position" instead
            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY),
                          toValue: CGPoint(x: layer.frame.midX, y: layer.frame.midY),
                          keyPath: "position")
        }
    }

    func addRectangleLayer(frame: CGRect, color: CGColor, animated: Bool, oldFrame: CGRect?) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        addSublayer(layer)

        if animated, let oldFrame = oldFrame {
            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY), toValue: layer.position, keyPath: "position")
            layer.animate(fromValue: CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height), toValue: layer.bounds, keyPath: "bounds")
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

    static let shared = CurveAlgorithm()

    private func controlPointsFrom(points: [CGPoint]) -> [CurvedSegment] {
        var result: [CurvedSegment] = []

        let delta: CGFloat = 0.3 // The value that help to choose temporary control points.

        // Calculate temporary control points, these control points make Bezier segments look straight and not curving at all
        for i in 1..<points.count {
            let A = points[i-1]
            let B = points[i]
            let controlPoint1 = CGPoint(x: A.x + delta*(B.x-A.x), y: A.y + delta*(B.y - A.y))
            let controlPoint2 = CGPoint(x: B.x - delta*(B.x-A.x), y: B.y - delta*(B.y - A.y))
            let curvedSegment = CurvedSegment(startPoint: .zero, endPoint: .zero, toPoint: .zero, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
            result.append(curvedSegment)
        }

        // Calculate good control points
        for i in 1..<points.count-1 {
            /// A temporary control point
            let M = result[i-1].controlPoint2

            /// A temporary control point
            let N = result[i].controlPoint1

            /// central point
            let A = points[i]

            /// Reflection of M over the point A
            let MM = CGPoint(x: 2 * A.x - M.x, y: 2 * A.y - M.y)

            /// Reflection of N over the point A
            let NN = CGPoint(x: 2 * A.x - N.x, y: 2 * A.y - N.y)

            result[i].controlPoint1 = CGPoint(x: (MM.x + N.x)/2, y: (MM.y + N.y)/2)
            result[i-1].controlPoint2 = CGPoint(x: (NN.x + M.x)/2, y: (NN.y + M.y)/2)
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
            path.addCurve(to: dataPoints[i], controlPoint1: curveSegments[i-1].controlPoint1, controlPoint2: curveSegments[i-1].controlPoint2)
        }
        return path
    }
}

class BarLineChart: UIView {

    private let mainLayer: CALayer = CALayer()
    private let barDataLayer: CALayer = CALayer()
    private let gridLayer: CALayer = CALayer()
    private let lineDataLayer: CALayer = CALayer()
    private let gradientLayer: CAGradientLayer = CAGradientLayer()

    private var animated = false

    private let presenter = BasicBarChartPresenter(barWidth: 30, space: 20)

    private var barEntries: [BasicBarEntry] = [] {
        didSet {
            barDataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})

            mainLayer.frame = CGRect(x: 0, y: 0, width: presenter.computeContentWidth(), height: frame.size.height)
            barDataLayer.frame = CGRect(x: 0, y: 0, width: presenter.computeContentWidth(), height: frame.size.height)

            showHorizontalLines()

            for (index, entry) in barEntries.enumerated() {
                showBarEntry(index: index, entry: entry, animated: animated, oldEntries: oldValue.safeValue(at: index))
            }
        }
    }

    private var pointEntries: [PointEntry] = [] {
        didSet {
            lineDataLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            gradientLayer.sublayers?.forEach({$0.removeFromSuperlayer()})

            let lineChartFrame = CGRect(x: 0, y: 0, width: presenter.computeContentWidth(), height: frame.size.height)
            lineDataLayer.frame = lineChartFrame
            gradientLayer.frame = lineChartFrame

            showPointEntry(entries: pointEntries, animated: animated, oldEntries: oldValue)
        }
    }

    func updateBarDataEntries(dataEntries: [DataEntry], animated: Bool) {
        self.animated = animated
        presenter.barDataEntries = dataEntries
        barEntries = presenter.computeBarEntries(viewHeight: frame.height)
    }

    func updateLineDataEntries(dataEntries: [DataEntry], animated: Bool) {
        self.animated = animated
        presenter.lineDataEntries = dataEntries
        pointEntries = presenter.computePointEntries(viewHeight: frame.height)
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
        gradientLayer.colors = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7).cgColor, UIColor.clear.cgColor]

        layer.addSublayer(mainLayer)
        mainLayer.addSublayer(gridLayer)
        mainLayer.addSublayer(lineDataLayer)
        mainLayer.addSublayer(gradientLayer)
        mainLayer.addSublayer(barDataLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        presenter.barWidth = (bounds.width - (presenter.space * 8)) / 7
        updateBarDataEntries(dataEntries: presenter.barDataEntries, animated: false)
        updateLineDataEntries(dataEntries: presenter.lineDataEntries, animated: false)
    }

    private func showBarEntry(index: Int, entry: BasicBarEntry, animated: Bool, oldEntries: BasicBarEntry?) {
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
            lineDataLayer.addCurvedLayer(path: path.cgPath, color: UIColor.green.cgColor, animated: true, oldPath: oldPath?.cgPath)
        }

        let baseY = presenter.computeBaseY(viewHeight: lineDataLayer.bounds.height)
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
            maskLayer.animate(
                fromValue: oldPath,
                toValue: newPath,
                keyPath: "path")
        }
    }

    private func showHorizontalLines() {
        gridLayer.frame = bounds
        if let sublayers = gridLayer.sublayers {
            for sublayer in sublayers {
                if sublayer is CAShapeLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        let lines = presenter.computeHorizontalLines(viewHeight: frame.height)
        for line in lines {
            gridLayer.addLineLayer(lineSegment: line.segment, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor, width: line.width, isDashed: line.isDashed, animated: false, oldSegment: nil)
        }
    }

}
