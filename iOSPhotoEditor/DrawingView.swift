//
//  DrawingView.swift
//  iOSPhotoEditor
//
//  Created by  Jaisson Monteiro on 19/11/19.
//

import Foundation
import UIKit

class DrawingView: UIView {
    
    var paths: [UIBezierPath] = []
    var startPoint = CGPoint()
    var currentPoint = CGPoint()
    var isDrawing = false
    var color = UIColor.blue
    var colors = [UIColor]()
    var redo = [UIBezierPath]()
    var redoColor = [UIColor]()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDrawing {
            if let touch = touches.first {
                startPoint = touch.location(in: self)
                paths.append(UIBezierPath())
                colors.append(color)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDrawing {
            if let touch = touches.first {
                
                currentPoint = touch.location(in: self)
                guard let last = paths.popLast() else {return}
                last.move(to: startPoint)
                last.addLine(to: currentPoint)
                paths.append(last)
                startPoint = currentPoint
                self.setNeedsDisplay()
            }
        }

        
    }
    override func draw(_ rect: CGRect) {
        
        for (i,path) in paths.enumerated() {
            colors[i].set()
            path.lineWidth = 5
            path.stroke()
        }
        
    }
    
    func undo() {
        if paths.count > 0 {
            redo.append(paths.removeLast())
            redoColor.append(colors.removeLast())
            self.setNeedsDisplay()
        }
    }
    
    func redoPaths() {
        if redo.count > 0 {
            paths.append(redo.removeLast())
            colors.append(redoColor.removeLast())
            self.setNeedsDisplay()
        }
    }
    
    func clear() {
        redoColor.removeAll()
        redo.removeAll()
        
        paths.removeAll()
        colors.removeAll()
        
        setNeedsDisplay()
    }
}
