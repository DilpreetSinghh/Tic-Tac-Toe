//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by dilpreet singh on 27/02/23.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"), message: Text("You are so smart"), buttonTitle: Text("Hell Yeah!"))
    static let computerWin = AlertItem(title: Text("You Lost"), message: Text("Don't worry its' Dilpreet's AI"), buttonTitle: Text("Rematch"))
    static let draw = AlertItem(title: Text("Hard to believe but its' Draw"), message: Text("What a memorable battle"), buttonTitle: Text("Once more, Once more"))
}
