//
//  ContentView.swift
//  TicTacToe
//
//  Created by valvoline on 18/06/2019.
//  Copyright © 2019 Costantino Pistagna. All rights reserved.
//

import SwiftUI


enum SquareStatus {
    case empty
    case visitor
    case home
}

class Square: BindableObject {
    
}

struct ContentView : View {
    var body: some View {
        Text("Hello World")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
