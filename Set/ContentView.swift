//
//  ContentView.swift
//  Set
//
//  Created by Dana Zou on 13/11/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ClassicalSetGame
    
    @Namespace private var discardingNamespace
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            header
            Spacer()
            Divider()
//            Spacer()
            gameBody
            HStack {
                deckBody
                Spacer()
                discardBody
            }
            .padding(.horizontal)
//            deal3Cards
        }
        .padding(.horizontal)
    }
    
    /*
     dealing card delay
     
     Make the dealing of the cards happen one card at a time by delaying the animation of each subsequent card.
         
         Create a func that calculates the delay for each card and returns a delayed Animation.
         
         The delay duration of each card should depend the card’s index (i.e. position) in the cards array
     */
    
    @State var dealt = Set<Int>()
    
    func deal (_ card: Card) {
        dealt.insert(card.id)
    }
    
    func isUndealt (_ card: Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    func dealAnimation (for card: Card) -> Animation {
        var delay = 0.0
        
        if let index = viewModel.cards.firstIndex(where: {$0.id == card.id}) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(viewModel.cards.count))
        }
        return Animation.easeInOut.delay(delay)
    }
    
    var gameBody: some View {
        AspectVGrid(items: viewModel.cards, aspectRatio: 2/3) { card in
            if isUndealt(card)  {
                Color.clear
            } else {
                CardView(card: card)
                .padding(3)
            /* Animate cards entering and leaving Grid*/
                .matchedGeometryEffect(id: card.id, in: discardingNamespace)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(AnyTransition.asymmetric(insertion: .scale, removal: .scale))
            /* Tapping on card*/
                .onTapGesture {
                    withAnimation (.easeInOut(duration: 0.2)) {
                        viewModel.choose(card)
                    }
                }
            }
        }
//        .onAppear {
//            for card in viewModel.cards {
//                withAnimation(dealAnimation(for: card)) {
//                    deal(card)
//                }
//            }
//        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(viewModel.deck) { card in
                RoundedRectangle(cornerRadius: CardConstants.cornerRadius)
                    .foregroundColor(CardConstants.deckColor)
                    /* Animate cards entering and leaving deck*/
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: CardConstants.deckWidth, height: CardConstants.deckHeight)
        .onTapGesture {
            if viewModel.isNewGame {
                viewModel.isNewGame = false
                for card in viewModel.cards {
                    withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
//                withAnimation(Animation.easeInOut(duration: 2)) {
//                    for card in viewModel.cards {
//                        deal(card)
//                    }
//                }
                
                
//                for card in viewModel.cards {
//                    withAnimation (Animation.easeInOut(duration: 2)) {
//                        deal(card)
//                    }
//                }
            } else {
                withAnimation {
                    viewModel.dealMoreCards()
                }
            }
//            withAnimation {
//                if viewModel.isNewGame {
////                    deal...
//                    for card in viewModel.cards {
//                        deal(card)
//                    }
//                    viewModel.isNewGame = false
//                } else {
//                    viewModel.dealMoreCards()
//                }
//            }
        }
    }
    
    var discardBody: some View {
        ZStack {
            ForEach (viewModel.discardedCards) { card in
                CardView(card: card)
                /* Animate card entering discard pile*/
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: discardingNamespace)
            }
        }
        .frame(width: CardConstants.deckWidth, height: CardConstants.deckHeight)
    }
    
//    var deal3Cards: some View {
//        Button ("Deal 3 Cards") {
//            if !viewModel.cardsInDeck.isEmpty {
//                viewModel.dealMoreCards()
//            }
//        }.foregroundColor(viewModel.cardsInDeck.isEmpty ? .gray : .blue)
//
//    }
    
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
            withAnimation {
                dealt = []
                viewModel.newGame()
            }
        }.foregroundColor(.blue)
    }
    
    struct CardConstants {
        static let deckWidth: CGFloat = deckHeight * aspectRatio
        static let deckHeight: CGFloat = 100
        static let aspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 8
        static let deckColor: Color = .indigo
        static let totalDealDuration: Double = 3
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
