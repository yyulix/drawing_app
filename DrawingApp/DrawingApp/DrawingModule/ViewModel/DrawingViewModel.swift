//
//  DrawingViewModel.swift
//  DrawingApp
//
//  Created by Julia Popova on 21.01.2024.
//

import Foundation

class DrawingViewModel: ObservableObject {
    @Published var lines: [Line] = []
    @Published var removedLines: [Line] = []
    
    func removeLastLine() {
        let line = lines.removeLast()
        removedLines.append(line)
    }
    
    func undoRemoveLastLine() {
        let line = removedLines.removeLast()
        lines.append(line)
    }
    
    init() {
        // Load data
        if FileManager.default.fileExists(atPath: url.path), let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                self.lines = try decoder.decode([Line].self, from: data)
            } catch {
                print("decoding error \(error)")
            }
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        do {
            let data = try? encoder.encode(lines)
            try data?.write(to: self.url)
        } catch {
            print("error saving \(error)")
        }
    }
    
    var url: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        return documentsDirectory.appendingPathComponent("Document").appendingPathExtension("json")
    }
}
