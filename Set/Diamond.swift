//
//  Diamond.swift
//  Set
//
//  Created by Dana Zou on 20/02/2023.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        
        let start = CGPoint(x: 0, y: rect.height/2)
        
        var p = Path()
        p.move(to: start)
        p.addLine(to: CGPoint(x: rect.width/2, y: 0))
        p.addLines([CGPoint(x: rect.width/2, y: 0),
                    CGPoint(x: rect.width, y: rect.height/2),
                    CGPoint(x: rect.width/2, y: rect.height),
                   start])
        return p
    }
}
