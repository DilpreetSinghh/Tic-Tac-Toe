//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by dilpreet singh on 28/02/23.
//

import SwiftUI

final class GameViewModel: ObservableObject{
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @Published var moves: [GameView.Move?] = Array(repeating: nil, count: 9)
    @Published var isHumanTurn = true
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position) {return}
        moves[position] = GameView.Move(player: isHumanTurn ? .human : .computer, boardIndex: position)
        
        
        // check for win condition or draw
        if checkWindCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        isGameboardDisabled = true
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = GameView.Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWindCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerWin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
    } 
    
    func isSquareOccupied(in moves: [GameView.Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    
    // If AI can win, then win
    // if AI can't win, then block
    // if AI can't block, then take middle square
    // if AI can't take middle square, take random available square
    
    func determineComputerMovePosition(in moves: [GameView.Move?]) -> Int{
        
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7,], [2, 5, 8], [0,4,8], [2,4,6]]
        let computerMoves = moves.compactMap { $0 }.filter {$0.player == .computer}
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first! }
            }
        }
        // If AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns{
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1{
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable {return winPositions.first! }
            }
        }
        
        // If AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: 4){
            return centerSquare
        }
        
        // If AI can't take middle square, take random available square
        
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    func checkWindCondition(for player: GameView.Player, in moves: [GameView.Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7,], [2, 5, 8], [0,4,8], [2,4,6]]
        let playerMoves = moves.compactMap { $0 }.filter {$0.player == player}
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true}
        return false
        
    }
    func checkForDraw(in move: [GameView.Move?]) -> Bool{
        return moves.compactMap{$0}.count == 9
    }
    func resetGame(){
        moves = Array(repeating: nil, count: 9)
    }
    
}

