//
//  Clock.swift
//  pomodoro
//
//  Created by Florian Ouilhon on 25/07/2024.
//

import SwiftUI

struct Clock: View {
    @State private var now = Date()
    private let timer = Timer.publish(every: 0, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        let cal = Calendar.current
        let h = cal.component(.hour, from: now) < 10 ? "0\(cal.component(.hour, from: now))" : String(cal.component(.hour, from: now))
        let m = cal.component(.minute, from: now) < 10 ? "0\(cal.component(.minute, from: now))" : String(cal.component(.minute, from: now))
        let s = cal.component(.second, from: now) < 10 ? "0\(cal.component(.second, from: now))" : String(cal.component(.second, from: now))
        
        let seconds = cal.component(.second, from: now)
        let minutes = cal.component(.minute, from: now)
        let hours = (cal.component(.hour, from: now) < 13) ? cal.component(.hour, from: now) : cal.component(.hour, from: now) - 12
        ZStack {
            Gauge(value: Double(hours) + Double(minutes) / 60.0, in: 0...12) {}
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.indigo, .blue], startPoint: .trailing, endPoint: .leading), lw: 8))
                .animation(.linear(duration: 1), value: seconds)
                .frame(width: 200)
            Gauge(value: Double(minutes) + Double(seconds) / 60.0, in: 0...60) {}
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.purple, .blue], startPoint: .trailing, endPoint: .leading), lw: 6))
                .animation(.linear(duration: 1), value: seconds)
                .frame(width: 182)
            Gauge(value: Double(seconds), in: 0...59) {}
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.teal, .blue], startPoint: .trailing, endPoint: .leading), lw: 4))
                .animation(.linear(duration: 1), value: seconds)
                .frame(width: 168)
            Text("\(h) : \(m) : \(s)")
                .font(.system(size: 20, weight: .heavy))
                .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.4))
                .onReceive(timer, perform: { time in
                    now = time
                })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ClockGaugeStyle: GaugeStyle {
    @State var gradient: LinearGradient
    @State var lw: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(.clear)
            Circle()
                .trim(from: 0, to: configuration.value)
                .stroke(gradient, style: .init(lineWidth: lw, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    Clock()
}
