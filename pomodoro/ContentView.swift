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
    
    @State var started: Bool = false
    
    func start() {
        started = true
    }
    
    var body: some View {
        VStack {
            if (started) {
                Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: true)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .padding()
            } else {
                Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: false)
                    .frame(maxWidth: 300, maxHeight: 300)
                    .padding()
            }
            HStack {
                Button("Start Session") { 
                    started.toggle()
                }
                    .buttonStyle(startStyle())
                Button(action: start) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(confStyle())
                .padding(.leading, 20)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct confStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .font(.system(size: 12))
        .frame(width: 40, height: 40)
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}
struct startStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .font(.system(size: 14))
        .frame(width: 120, height: 40)
        .background(.blue)
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
