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
    @State var now = Date()
    @State var started: Bool

    @State var workDuration: Double = 3
    @State var shortPause: Double = 1
    @State var longPause: Double = 2
    @State var workCnt: Int = 0
    @State var isWorkDone: Bool = false
    @State var startSess: Double = 0

    let lg = LinearGradient(colors: [Color(red: 1, green: 1, blue: 1, opacity: 0.1), Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.2)], startPoint: .trailing, endPoint: .leading)
    
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
        
        let minSessionString = (!isWorkDone ?
                                (workDuration * 60 - startSess) / 60 < 10 ? "0\(Int(workDuration * 60 - startSess) / 60)" : "\(Int(workDuration * 60 - startSess) / 60)" :
                                (workCnt % 4 == 0 ?
                                 (longPause * 60 - startSess) / 60 < 10 ? "0\(Int(longPause * 60 - startSess) / 60)" : "\(Int(longPause * 60 - startSess) / 60)" :
                                (shortPause * 60 - startSess) / 60 < 10 ? "0\(Int(shortPause * 60 - startSess) / 60)" : "\(Int(shortPause * 60 - startSess) / 60)"))
        let secSessionString = (!isWorkDone ?
                                Int(60*(workDuration - Double(minSessionString)!) - startSess) >= 10 ? String(Int(60*(workDuration - Double(minSessionString)!) - startSess)) : String("0\(Int(60*(workDuration - Double(minSessionString)!) - startSess))") :
                                (workCnt % 4 == 0 ?
                                 Int(60*(longPause - Double(minSessionString)!) - startSess) >= 10 ? String(Int(60*(longPause - Double(minSessionString)!) - startSess)) : String("0\(Int(60*(longPause - Double(minSessionString)!) - startSess))") :
                                Int(60*(shortPause - Double(minSessionString)!) - startSess) >= 10 ? String(Int(60*(shortPause - Double(minSessionString)!) - startSess)) : String("0\(Int(60*(shortPause - Double(minSessionString)!) - startSess))")))
                                    
        
        ZStack {
            ZStack {
                Gauge(value: started ? startSess : 0, in: 0...workDuration*60) { }
                    .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.blue, .blue], startPoint: .leading, endPoint: .trailing), lw: lw_h + 4))
                    .opacity(started && !isWorkDone ? 1 : 0)
                    .animation(.linear(duration: 1), value: startSess)
                    .frame(width: w-74)
                Gauge(value: started ? startSess : 0, in: 0...longPause*60) { }
                    .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.green, .green], startPoint: .leading, endPoint: .trailing), lw: lw_h + 4))
                    .opacity(started && isWorkDone && workCnt % 4 == 0 ? 1 : 0)
                    .animation(.linear(duration: 1), value: startSess)
                    .frame(width: w-74)
                Gauge(value: started ? startSess : 0, in: 0...shortPause*60) { }
                    .gaugeStyle(ClockGaugeStyle(gradient: LinearGradient(colors: [.pink, .pink], startPoint: .leading, endPoint: .trailing), lw: lw_h + 4))
                    .opacity(started && isWorkDone && workCnt % 4 != 0 ? 1 : 0)
                    .animation(.linear(duration: 1), value: startSess)
                    .frame(width: w-74)
                    .onReceive(timer, perform: { _ in
                        if started {
                            if !isWorkDone {
                                if startSess < workDuration*60 {
                                    startSess += 1
                                } else {
                                    startSess = 0
                                    workCnt += 1
                                    isWorkDone = true
                                }
                            } else {
                                if (workCnt % 4 == 0) {
                                    if startSess < longPause*60 {
                                        startSess += 1
                                    } else {
                                        startSess = 0
                                        isWorkDone = false
                                    }
                                } else {
                                    if startSess < shortPause*60 {
                                        startSess += 1
                                    } else {
                                        startSess = 0
                                        isWorkDone = false
                                    }
                                }
                            }
                        }
                    })
                
                VStack(spacing: 10) {
                    Text(started && !isWorkDone ? "Focus" : (workCnt % 4 == 0 ? "Long Break" : "Short Break"))
                        .font(.system(size: 16, weight: .regular))
                        .opacity(started ? 1 : 0)
                        .animation(.linear(duration: 1), value: isWorkDone)
                    Text("\(minSessionString) : \(secSessionString)")
                        .font(.system(size: 20, weight: .heavy))
                        .opacity(started ? 1 : 0)
                        .animation(.linear(duration: 1), value: isWorkDone)
                }
                .foregroundStyle(!isWorkDone ? .blue : workCnt % 4 == 0 ? .green : .pink)
            }
                
            Gauge(value: Double(h) + (Double(m)/60 + Double(s)/3600), in: 0...12) { }
                .gaugeStyle(ClockGaugeStyle(gradient: started ? lg : LinearGradient(colors: [.indigo, .blue], startPoint: .leading, endPoint: .trailing), lw: lw_h))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - 100)
            Gauge(value: Double(m) + Double(s) / 60.0, in: 0...60) { }
                .gaugeStyle(ClockGaugeStyle(gradient: started ? lg : LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing), lw: lw_m))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - (100+lw_h+lw_m) - lw_m)
            Gauge(value: Double(s), in: 0...60) { }
                .gaugeStyle(ClockGaugeStyle(gradient: started ? lg : LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing), lw: lw_s))
                .animation(.linear(duration: 1), value: s)
                .frame(width: w - (100+lw_h+lw_m+lw_s) - (lw_h+lw_m+lw_s))
            Text("\(hour_string) : \(minute_string) : \(second_string)")
                 .font(.system(size: 20, weight: .medium))
                 .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.4, opacity: 0.4))
                 .opacity(started ? 0 : 1)
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
                .trim(from: 0.0, to: configuration.value)
                .stroke(gradient, style: .init(lineWidth: lw, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview("Started") {
    Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: true)
}

#Preview("Not started") {
    Clock(w: 300, lw_h: 8, lw_m: 6, lw_s: 4, started: false)
}
