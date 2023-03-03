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
//            HStack {
//                deckBody
//                discardBody
//            }
//            deal3Cards
        }
        .padding(.horizontal)
    }
    
//    var deckBody: some View {
//        // to add
//        /*
//         show cards in deck
//         */
//        ZStack {
//            ForEach (viewModel.cardsInDeck) { card in
//                CardView(card: card)
//            }
//        }
//    }
    
//    var discardBody: some View {
//        // to add
//        /*
//         discard set, when cards get removed it goes to the set
//         */
//    }
    
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
            VStack {
                ForEach(0..<card.numberOfShapes, id: \.self) { _ in
                    ZStack {
                        viewModel.symbol(card.shape, opacity: card.shading, strokeWidth: DrawingConstants.symbolStrokeWidth)
                        Spacer(minLength: 0) // spacer to make ZStack maximum flexible
                    }
                    .aspectRatio(2/1, contentMode: .fit)
                }
            }
            .padding(.all, paddingSize(in: geometry.size))
            .foregroundColor(viewModel.findColor(of: card.color))
            .cardify(isSet: card.isSet, isSelected: card.isSelected)
        }
    }
    
    private func paddingSize(in size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.symbolPaddingScale
    }
    
    private struct DrawingConstants {
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
