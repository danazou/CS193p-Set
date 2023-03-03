//
//  Cardify.swift
//  Set
//
//  Created by Dana Zou on 03/03/2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    var isSet: Bool?
    var isSelected: Bool
    
    func body(content: Content) -> some View {
        ZStack{
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            
            if isSet == nil {
                shape.fill().foregroundColor(.white)
            } else {
                shape.fill().foregroundColor(isSet! ? DrawingConstants.setFill : DrawingConstants.incorrectSetFill)
            }

            shape.strokeBorder(isSelected ? DrawingConstants.setFill : DrawingConstants.defaultBorder, lineWidth: DrawingConstants.cardStrokeWidth)

            content
        }
    }
    
    struct DrawingConstants {
        static let cornerRadius: CGFloat = 8
        static let cardStrokeWidth: CGFloat = 2

        static let defaultBorder: Color = .gray.opacity(0.3)
        static let selectedBorder: Color = .orange
        static let setFill: Color = Color(red: 1.0, green: 1.0, blue: 0.65)
        static let incorrectSetFill: Color = .gray
    }
}

extension View {
    func cardify(isSet: Bool?, isSelected: Bool) -> some View {
        return self.modifier(Cardify(isSet: isSet, isSelected: isSelected))
    }
}
