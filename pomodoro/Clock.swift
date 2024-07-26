//
//  Clock.swift
//  pomodoro
//
//  Created by Florian Ouilhon on 25/07/2024.
//

import SwiftUI

struct Clock: View {
    
    @State var w: CGFloat
    @State var lw_h: CGFloat
    @State var lw_m: CGFloat
    @State var lw_s: CGFloat
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        let cal = Calendar.current
        
        let hour_string = cal.component(.hour, from: now) < 10 ? "0\(cal.component(.hour, from: now))" : String(cal.component(.hour, from: .now))
        let minute_string = cal.component(.minute, from: now) < 10 ? "0\(cal.component(.minute, from: now))" : String(cal.component(.minute, from: .now))
        let second_string = cal.component(.second, from: now) < 10 ? "0\(cal.component(.second, from: now))" : String(cal.component(.second, from: .now))
        
        let s = cal.component(.second, from: now)
        let m = cal.component(.minute, from: now)
        let h = cal.component(.hour, from: now) < 12 ? cal.component(.hour, from: now) : cal.component(.hour, from: now) - 12
        
        ZStack {
            Gauge(value: Double(h) + (Double(m)/60 + Double(s)/3600), in: 0...12) { }
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.indigo, .blue], startPoint: .trailing, endPoint: .leading), lw: lw_h))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - 100)
            Gauge(value: Double(m) + Double(s) / 60.0, in: 0...60) { }
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.purple, .blue], startPoint: .trailing, endPoint: .leading), lw: lw_m))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - (100+lw_h+lw_m) - lw_m)
            Gauge(value: Double(s), in: 0...60) { }
                .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.teal, .blue], startPoint: .trailing, endPoint: .leading), lw: lw_s))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - (100+lw_h+lw_m+lw_s) - (lw_h+lw_m+lw_s))
            if (w > 150) {
                Text("\(hour_string) : \(minute_string) : \(second_string)")
                    .font(.system(size: w / 20, weight: .heavy))
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.4))
                    .onReceive(timer, perform: { time in
                        now = time
                    })
            } else {
                Text("\(hour_string) : \(minute_string) : \(second_string)")
                    .hidden()
                    .font(.system(size: w / 20, weight: .heavy))
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.4))
                    .onReceive(timer, perform: { time in
                        now = time
                    })
            }
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
                .trim(from: 0.0, to: configuration.value)
                .stroke(gradient, style: .init(lineWidth: lw, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4)
}
