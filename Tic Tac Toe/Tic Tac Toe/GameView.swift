//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by dilpreet singh on 26/02/23.
//

import SwiftUI
  


struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private  var isHumanTurn = true
    @State private  var isGameboardDisabled = false
    @State private  var alertItem: AlertItem?
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 2){
                    ForEach(0..<9) { i in
                        ZStack{
                            GameSquareView(proxy: geometry)
                            playerIndicator(systemImageName: viewModel.moves[i]?.indicator ?? "")
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                    
                }
                Spacer()
            }
            .disabled(viewModel.isGameboardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {viewModel.resetGame() }))
            })
            
            
        }
        
    }
    
    
    
    enum Player {
        case human, computer
    }
    
    struct Move {
        let player: Player
        let boardIndex: Int
        
        var indicator: String {
            return player == .human ? "xmark" : "circle"
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            GameView()
        }
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
        
            .foregroundColor(.init(red: 100, green: 0, blue: 0)).opacity(1)
            .frame(width: proxy.size.width/3 - 15,
                   height: proxy.size.width/3 - 5)
    }
}

struct playerIndicator: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .colorInvert()
            .frame(width: 40, height: 40)
    }
}
