//
//  DrawingEngine.swift
//  DrawingApp
//
//  Created by Julia Popova on 23.12.2023.
//

import Foundation
import SwiftUI

class DrawingEngine {
    func createPath(for points: [CGPoint]) -> Path {
        var path = Path()
        
        if let firstPoint = points.first {
            path.move(to: firstPoint)
        }
        
        for index in 1..<points.count {
            let mid = calculateMidPoint(points[index - 1], points[index])
            path.addQuadCurve(to: points[index], control: mid)
        }
        
        if let lastPoint = points.last {
            path.addLine(to: lastPoint)
        }
        
        return path
    }
    
    private func calculateMidPoint(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        let newMidPoint = CGPoint(x: (point1.x + point2.x)/2, y: (point1.y + point2.y)/2)
        return newMidPoint
    }
}
