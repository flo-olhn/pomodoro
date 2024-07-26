//
//  ContentView.swift
//  pomodoro
//
//  Created by Florian Ouilhon on 25/07/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    let gradient = Gradient(colors: [.pink, .blue])
    @State var wdth: CGFloat = 0
    
    func start() {
        wdth = 100
    }
    
    var body: some View {
        VStack {
            if (wdth == 100) {
                Clock(w: 150, lw_h: 4, lw_m: 3, lw_s: 2)
                    .frame(maxWidth: 50, maxHeight: 50)
                    .position(x: 30, y: 30)
            } else {
                Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4)
                    .frame(maxWidth: 200, maxHeight: 200)
            }
            HStack {
                Button("Start Session", action: start)
                Button("\(Image(systemName: "gearshape.fill"))", action: start)
                    .frame(width: 40, height: 40)
                    .background(Color(red: 0, green: 0.5, blue: 0.5))
                    .padding()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
