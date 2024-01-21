//
//  Line.swift
//  DrawingApp
//
//  Created by Julia Popova on 23.12.2023.
//

import Foundation
import SwiftUI

struct Line: Identifiable, Codable {
    
    var points: [CGPoint]
    
    var color: Color {
        get {
            customColor.color
        }
        set {
            customColor = CustomColor(color: newValue)
        }
    }
    
    private var customColor: CustomColor
    
    var lineWidht: CGFloat
    
    let id = UUID()
    
    init(points: [CGPoint], color: Color, lineWidht: CGFloat) {
        self.points = points
        self.customColor = CustomColor(color: color)
        self.lineWidht = lineWidht
        self.color = color
    }
}

struct CustomColor: Codable {
    var green: Double = 0
    var blue: Double = 0
    var red: Double = 0
    var opacity: Double = 1
    
    init(color: Color) {
        if let components = color.cgColor?.components {
            if components.count > 2 {
                self.red = components[0]
                self.green = components[1]
                self.blue = components[2]
            }
        }
    }
    
    var color: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
