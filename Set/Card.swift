//
//  Card.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//

import Foundation

struct Card: Identifiable {
    var id: Int
    
    var numberOfShapes: Int
    var color: String
    var shading: CGFloat
    var shape: String
    var combinations: [Int]
    
    init(numberOfShapes: Int, color: String, shading: CGFloat, shape: String, id: Int, combinations: [Int]) {
        self.numberOfShapes = numberOfShapes
        self.color = color
        self.shading = shading
        self.shape = shape
        self.id = id
        self.combinations = combinations
        
    }
    
    var isMatched: Bool = false
    var isSet: Bool? = nil
    var isSelected: Bool = false
    var isActive = true
//    var content: CardContent
    
    
}
