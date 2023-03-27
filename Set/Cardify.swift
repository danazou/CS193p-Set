//
//  Cardify.swift
//  Set
//
//  Created by Dana Zou on 03/03/2023.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    var state: SetState
    
    var cardStyle: some View {
        let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)

        switch state {
        case .correctSet:
            return ZStack {
                shape.fill().foregroundColor(DrawingConstants.setFill)
                shape.strokeBorder(DrawingConstants.selectedBorder, lineWidth: DrawingConstants.cardStrokeWidth)
            }
        case .incorrrectSet:
            return ZStack  {
                shape.fill().foregroundColor(DrawingConstants.incorrectSetFill)
                shape.strokeBorder(DrawingConstants.selectedBorder, lineWidth: DrawingConstants.cardStrokeWidth)
            }
        case .selected:
            return ZStack  {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(DrawingConstants.selectedBorder, lineWidth: DrawingConstants.cardStrokeWidth)
            }
        case .inactive:
            return ZStack  {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(DrawingConstants.defaultBorder, lineWidth: DrawingConstants.cardStrokeWidth)
            }
        case .hint:
            return ZStack  {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(DrawingConstants.hintBorder, lineWidth: DrawingConstants.cardStrokeWidth)
            }
        }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            cardStyle
            content
                .rotationEffect(correctSetRotation(state))
                .animation(.default.repeatCount(2, autoreverses: false), value: state)
        }
        .rotationEffect(wrongSetRotation(state))
        .animation(.default, value: state)
    }
    

    private func wrongSetRotation (_ state: SetState) -> Angle {
        if state == .incorrrectSet {
            return .degrees(5)
        } else {
            return .degrees(0)
        }
    }
    
    private func correctSetRotation (_ state: SetState) -> Angle {
        if state == .correctSet {
            return .degrees(180)
        }
        else {
            return .degrees(0)
        }
    }
    
    struct DrawingConstants {
        static let cornerRadius: CGFloat = 8
        static let cardStrokeWidth: CGFloat = 2

        static let defaultBorder: Color = .gray.opacity(0.3)
        static let selectedBorder: Color = .orange
        static let hintBorder: Color = .brown
        static let setFill: Color = Color(red: 1.0, green: 1.0, blue: 0.65)
        static let incorrectSetFill: Color = .gray.opacity(0.3)
    }
}

extension View {
    func cardify(state: SetState) -> some View {
        return self.modifier(Cardify(state: state))
    }
}

//                .scaleEffect(scaleFactor(state))
//                .animation(.interpolatingSpring(mass: 7, stiffness: 2500, damping: 0), value: state)

//    private func scaleFactor (_ state: SetState) -> CGFloat {
//        if state == .correctSet {
//            return 1.1
//        } else {
//            return 1
//        }
//    }
    
