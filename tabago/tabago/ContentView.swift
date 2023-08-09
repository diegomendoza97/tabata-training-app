//
//  ContentView.swift
//  tabago
//
//  Created by Diego Mendoza on 8/2/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var activeTimeMinutes: Int = 0
    @State var activeTimeSeconds: Int = 10
    @State var passiveTimeMinutes: Int = 0
    @State var passiveTimeSeconds: Int = 12
    @State var numberOfRounds: Int = 10
    @State var currentRound = 0
    @State var status: String = "passive"
    @State var showConfiguration = false
    
    @State var activeTimeSound = "Alarm"
    @State var passiveTimeSound = "Alarm"
    @State var seconds = 10;
    @State var minutes = 0;
    @State var timeRunning = false;
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    
    
    var buttonColor: Color {
        return status == "active" ? .red : .white
    }
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showConfiguration = true;
                    }, label: {
                        Image(systemName: "gear.badge")
                            .font(.system(size: 24))
                            .foregroundColor(buttonColor)
                    })
                    .disabled(status == "active")
                    .padding()
                }
                .padding()
                Spacer()
                Text("\(formatTimer())")
                    .font(.largeTitle)
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
                statusButton
                Spacer()
            }
            .fullScreenCover(isPresented: $showConfiguration, content: {
                ConfigurationView(activeSeconds: $activeTimeSeconds, activeTimeSound: $activeTimeSound, passiveTimeSound: $passiveTimeSound, numberOfRounds: $numberOfRounds, activeMinutes: $activeTimeMinutes, passiveMinutes: $passiveTimeMinutes, passiveSeconds: $passiveTimeSeconds) { val in
                    
                }
            })
            .background(status == "passive" ? Color.purple : Color.blue)
            .onAppear {
                numberOfRounds = 10
                activeTimeSeconds = 10
                print(activeTimeMinutes)
            }
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
        playMySound()
        seconds = 30
    }
    func playMySound() {
        // 1323 - train
        // 1325 - flauta
        // 1328 - idea para pasivo
        // 1330 - cuerno de guerra
        // 1333 - sonido electrico
        
        AudioServicesPlayAlertSound(SystemSoundID(1328))
    }
    
    func changeState() {
        timeRunning = !timeRunning
        if (timeRunning) {
            status = "active"
        } else {
            status = "passive"
        }
//        if timeRunning == false {
//            timeRunning = true;
//        } else {
//            timeRunning = false;
//        }
    }
    
    var statusButton: some View {
        Button {
            changeState()
        } label: {
            Text(timeRunning ? "Stop" : "Start")
                .frame(width: 100, height: 100)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.white, lineWidth: 2)
                })
                .foregroundColor(.white)
                .padding()
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
