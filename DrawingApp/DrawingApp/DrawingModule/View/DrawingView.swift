//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Julia Popova on 23.12.2023.
//

import SwiftUI

struct DrawingView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @State private var color: Color = .black
    @State private var lineWidth: CGFloat = 3.0
    
    @StateObject var viewModel = DrawingViewModel()
    
    let engine = DrawingEngine()
    
    var body: some View {
        VStack {
            HStack {
                ColorPicker(selection: $color, label: {
                    Text("Line color")
                }).labelsHidden()
                
                Slider(value: $lineWidth, in: 1...10)
                
                Button {
                    viewModel.removeLastLine()
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .imageScale(.large)
                }.disabled(viewModel.lines.isEmpty)
                
                Button {
                    viewModel.undoRemoveLastLine()
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .imageScale(.large)
                }.disabled(viewModel.removedLines.isEmpty)
                
                Button {
                    viewModel.lines = []
                } label: {
                    Text("Clear")
                }

            }
            .padding()
            
            Canvas { context, size in
                for line in viewModel.lines {
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
                        viewModel.lines.append(
                            .init(
                                points: [newPoint],
                                color: color,
                                lineWidht: lineWidth
                            )
                        )
                    } else {
                        let index = viewModel.lines.count - 1
                        viewModel.lines[index].points.append(newPoint)
                    }
                })
            )
        }
        .onChange(of: scenePhase) { newValue in
            if newValue == .background {
                viewModel.save()
            }
        }
    }
}

#Preview {
    DrawingView()
}
