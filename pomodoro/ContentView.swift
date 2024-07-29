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
    
    @State var s: Bool = false
    @State var configOpened: Bool = false
    
    func start() {
        s.toggle()
    }
    
    func config() {
        print("config")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if (s) {
                    Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: true)
                } else {
                    Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: false)
                }
                HStack {
                    Button(s ? "Stop Session" : "Start Session", action: start)
                        .buttonStyle(startStyle())
                        .background(s ? .pink : .blue)
                        .animation(.easeIn(duration: 0.3), value: s)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    
                    
                    NavigationLink(destination: ConfigureView(), label: {
                        //configOpened.toggle()
                        Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                //.foregroundColor(s ? Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 1) : .white)
                        //.padding(.leading, 7)
                    })
                    .frame(width: 40, height: 40)
                    .disabled(s)
                    .background(s ? Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.5) : .blue)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .animation(.easeIn(duration: 0.3), value: s)
                    .padding(.leading, 10)
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct confStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12))
            .frame(width: 40, height: 40)
    }
}
struct startStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .frame(width: 120, height: 40)
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
