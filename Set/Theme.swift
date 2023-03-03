//
//  Theme.swift
//  Set
//
//  Created by Dana Zou on 20/02/2023.
//

import Foundation

struct Theme {
    let colors: [String]
    let shadings: [CGFloat]
    let shapes: [String]
    
    init(colors: [String], shadings: [CGFloat], shapes: [String]) {
        self.colors = colors
        self.shadings = shadings
        self.shapes = shapes
    }
}
