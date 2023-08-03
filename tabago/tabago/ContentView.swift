//
//  ContentView.swift
//  tabago
//
//  Created by Diego Mendoza on 8/2/23.
//

import SwiftUI

struct ContentView: View {
    @State var seconds = 30;
    @State var minutes = 1;
    @State var timeRunning = false;
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    var body: some View {
        NavigationView {
            VStack {
                HStack{Spacer()}
                Spacer()
                Text("\(formatTimer())")
                    .onReceive(timer) { _ in
                        if timeRunning {
                            seconds -= 1;
                            if seconds < 1 && minutes == 0 {
                                restart()
                            } else if seconds < 1 {
                                seconds = 59
                                minutes -= 1;
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                Button(timeRunning ? "Stop" : "Start") {
                    changeState()
                }
                .foregroundColor(.white)
                .padding()
                .ignoresSafeArea()
//                Divider()
                Spacer()
            }
            .background(timeRunning ? Color.blue : Color.purple)
            .ignoresSafeArea()
        }
    }
    
    func formatTimer() -> String {
        var remainingTime = "";
        if minutes > 9 {
            remainingTime += "\(minutes)"
        } else if minutes > 0 {
            remainingTime += "0\(minutes)"
        } else {
            remainingTime += "00"
        }
        
        remainingTime += ":"
        if seconds > 9 {
            remainingTime += "\(seconds)"
        } else {
            remainingTime += "0\(seconds)"
        }
        return remainingTime;
    }
    
    func toggleTimer() {
        
    }
    
    func restart() {
        seconds = 30
    }
    
    func changeState() {
        timeRunning = !timeRunning
//        if timeRunning == false {
//            timeRunning = true;
//        } else {
//            timeRunning = false;
//        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
