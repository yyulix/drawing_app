//
//  ContentView.swift
//  DrawingApp
//
//  Created by Julia Popova on 23.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var color: Color = .black
    @State private var lineWidth: CGFloat = 3.0
    @State private var lines: [Line] = []
    @State private var removedLines: [Line] = []
    
    let engine = DrawingEngine()
    
    var body: some View {
        VStack {
            HStack {
                ColorPicker(selection: $color, label: {
                    Text("Line color")
                }).labelsHidden()
                
                Slider(value: $lineWidth, in: 1...10)
                
                Button {
                    let line = lines.removeLast()
                    removedLines.append(line)
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.disabled(lines.isEmpty)
                
                Button {
                    let line = removedLines.removeLast()
                    lines.append(line)
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }.disabled(removedLines.isEmpty)
                
                Button {
                    lines = []
                } label: {
                    Text("Clear")
                }

            }
            .padding()
            
            Canvas { context, size in
                for line in lines {
                    let path = engine.createPath(for: line.points)
                    context.stroke(
                        path,
                        with: .color(line.color),
                        style: StrokeStyle(
                            lineWidth: line.lineWidht,
                            lineCap: .round,
                            lineJoin: .round
                        )
                        
                    )
                }
            }
            .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
                .onChanged({ value in
                    let newPoint = value.location
                    
                    if value.translation.width + value.translation.height == 0 {
                        lines.append(
                            .init(
                                points: [newPoint],
                                color: color,
                                lineWidht: lineWidth
                            )
                        )
                    } else {
                        let index = lines.count - 1
                        lines[index].points.append(newPoint)
                    }
                })
            )
        }
    }
}

#Preview {
    ContentView()
}
