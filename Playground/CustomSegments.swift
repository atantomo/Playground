//
//  CustomSegments.swift
//  BarChart
//
//  Created by Nguyen Vu Nhat Minh on 22/5/19.
//  Copyright © 2019 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

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
