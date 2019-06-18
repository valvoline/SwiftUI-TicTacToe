//
//  ContentView.swift
//  PrimoTestConSwiftUI
//
//  Created by Costantino Pistagna on 17/06/2019.
//  Copyright © 2019 sofapps.it All rights reserved.
//

import SwiftUI
import Combine

enum SquareStatus {
    case empty
    case visitor
    case home
}

class Square: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    var status: SquareStatus {
        didSet {
            didChange.send(())
        }
    }
    
    init(status: SquareStatus) {
        self.status = status
    }
}

class ModelBoard {
    var squares = [Square]()
    init() {
        for _ in 0...8 {
            squares.append(Square(status: .empty))
        }
    }
    func resetGame() {
        for i in 0...8 {
            squares[i].status = .empty
        }
    }
    var gameOver: (SquareStatus, Bool) {
        get {
            if thereIsAWinner != .empty {
                return (thereIsAWinner, true)
            } else {
                for i in 0...8 {
                    if squares[i].status == .empty {
                        return (.empty, false)
                    }
                }
                return (.empty, true)
            }
        }
    }
    private var thereIsAWinner:SquareStatus {
        get {
            if let check = self.checkIndexes([0, 1, 2]) {
                return check
            } else  if let check = self.checkIndexes([3, 4, 5]) {
                return check
            }  else  if let check = self.checkIndexes([6, 7, 8]) {
                return check
            }  else  if let check = self.checkIndexes([0, 3, 6]) {
                return check
            }  else  if let check = self.checkIndexes([1, 4, 7]) {
                return check
            }  else  if let check = self.checkIndexes([2, 5, 8]) {
                return check
            }  else  if let check = self.checkIndexes([0, 4, 8]) {
                return check
            }  else  if let check = self.checkIndexes([2, 4, 6]) {
                return check
            }
            return .empty
        }
    }
    private func checkIndexes(_ indexes: [Int]) -> SquareStatus? {
        var homeCounter:Int = 0
        var visitorCounter:Int = 0
        for anIndex in indexes {
            let aSquare = squares[anIndex]
            if aSquare.status == .home {
                homeCounter = homeCounter + 1
            } else if aSquare.status == .visitor {
                visitorCounter = visitorCounter + 1
            }
        }
        if homeCounter == 3 {
            return .home
        } else if visitorCounter == 3 {
            return .visitor
        }
        return nil
    }
    private func aiMove() {
        var anIndex = Int.random(in: 0 ... 8)
        while (makeMove(index: anIndex, player: .visitor) == false && gameOver.1 == false) {
            anIndex = Int.random(in: 0 ... 8)
        }
    }
    func makeMove(index: Int, player:SquareStatus) -> Bool {
        if squares[index].status == .empty {
            squares[index].status = player
            if player == .home { aiMove() }
            return true
        }
        return false
    }
}

struct SquareView: View {
    @ObjectBinding var dataSource:Square
    var action: () -> Void
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Text((dataSource.status != .empty) ?
                (dataSource.status != .visitor) ? "X" : "0"
                : " ")
                .font(.largeTitle)
                .foregroundColor(Color.black)
                .frame(minWidth: 60, minHeight: 60)
                .background(Color.gray)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
    }
}

struct ContentView : View {
    private var checker = ModelBoard()
    @State private var isGameOver = false
    
    func buttonAction(_ index: Int) {
        _ = self.checker.makeMove(index: index, player: .home)
        self.isGameOver = self.checker.gameOver.1
    }
    
    var body: some View {
        VStack {
            HStack {
                SquareView(dataSource: checker.squares[0]) { self.buttonAction(0) }
                SquareView(dataSource: checker.squares[1]) { self.buttonAction(1) }
                SquareView(dataSource: checker.squares[2]) { self.buttonAction(2) }
            }
            HStack {
                SquareView(dataSource: checker.squares[3]) { self.buttonAction(3) }
                SquareView(dataSource: checker.squares[4]) { self.buttonAction(4) }
                SquareView(dataSource: checker.squares[5]) { self.buttonAction(5) }
            }
            HStack {
                SquareView(dataSource: checker.squares[6]) { self.buttonAction(6) }
                SquareView(dataSource: checker.squares[7]) { self.buttonAction(7) }
                SquareView(dataSource: checker.squares[8]) { self.buttonAction(8) }
            }
            }
            .presentation($isGameOver) { () -> Alert in
                Alert(title: Text("Game Over"),
                      message: Text(self.checker.gameOver.0 != .empty ?
                        (self.checker.gameOver.0 == .home) ? "You Win!" : "iPhone Wins!"
                        : "Parity"), dismissButton: Alert.Button.destructive(Text("Ok"), onTrigger: {
                            self.checker.resetGame()
                        }) )
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
