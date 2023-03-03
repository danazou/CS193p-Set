//
//  ContentView.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ClassicalSetGame
    
    var body: some View {
        VStack {
            header
            Spacer()
            Divider()
//            Spacer()
            gameBody
            deal3Cards
        }
        .padding(.horizontal)
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
                .padding(3)
                .onTapGesture { viewModel.choose(card) }
        }
    }
    
    var deal3Cards: some View {
        
        Button ("Deal 3 Cards") {
            if !viewModel.cardsInDeck.isEmpty {
                viewModel.dealMoreCards()
            }
        }.foregroundColor(viewModel.cardsInDeck.isEmpty ? .gray : .blue)
        
    }
    
    var header: some View {
        HStack {
            title
            Spacer()
            newGame
        }
    }
    
    var title: some View {
        Text("Set").font(.largeTitle).fontWeight(.bold)
    }
    
    var newGame: some View {
        Button("New Game") {
            viewModel.newGame()
        }.foregroundColor(.blue)
    }
}

struct CardView: View {
    let card: Card
    var viewModel = ClassicalSetGame()
    
    var body: some View{
        GeometryReader { geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                if card.isSet == nil {
                    shape.fill().foregroundColor(.white)
                } else if card.isSet == true {
                    shape.fill().foregroundColor(Color(red: 1.0, green: 1.0, blue: 0.65))
                } else if card.isSet == false {
                    shape.fill().foregroundColor(.gray).opacity(0.3)
                }
                
                if card.isSelected {
                    shape.strokeBorder(.orange, lineWidth: DrawingConstants.cardStrokeWidth)
                } else {
                    shape.strokeBorder(.gray, lineWidth: DrawingConstants.cardStrokeWidth)
                }
                
                VStack {
                    ForEach(0..<card.numberOfShapes, id: \.self) { _ in
                        ZStack {
                            viewModel.symbol(card.shape, opacity: card.shading, strokeWidth: DrawingConstants.symbolStrokeWidth)
                            Spacer(minLength: 0)
                        }
                        .aspectRatio(2/1, contentMode: .fit)
                    }
//                    Text(card.combinations.map{String($0)}.joined()).font(.caption)
                }
                .padding(.all, paddingSize(in: geometry.size))
                .foregroundColor(viewModel.findColor(of: card.color))
            }
        }
    }
    
    private func paddingSize(in size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.symbolPaddingScale
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 8
        static let cardStrokeWidth: CGFloat = 2
        static let symbolStrokeWidth: CGFloat = 1.5
        static let symbolPaddingScale: CGFloat = 0.2
    }
}



















struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = ClassicalSetGame()
        ContentView(viewModel: game)
            .previewDevice("iPhone 12 mini")
            .preferredColorScheme(.light)
    }
}
