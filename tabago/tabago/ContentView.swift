//
//  ContentView.swift
//  tabago
//
//  Created by Diego Mendoza on 8/2/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var primaryColor = Color(red: 62/255, green: 207/255, blue: 142/255)
    var secondaryColor = Color(red: 24/255, green: 24/255, blue: 24/255)
    
    @State var activeTimeMinutes: Int = 0
    @State var activeTimeSeconds: Int = 10
    @State var passiveTimeMinutes: Int = 0
    @State var passiveTimeSeconds: Int = 12
    @State var numberOfRounds: Int = 10
    @State var status: String = "passive"
    @State var showConfiguration = false 
    @State var currentRound = 1
    @State var totalRounds = 10
    
    @State var activeTimeSound = "Alarm"
    @State var passiveTimeSound = "Alarm"
    @State var seconds = 12;
    @State var minutes = 0;
    @State var timeRunning = false;
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    
    var backgroundColor: Color {
//        36,180,126
        return status == "passive" ? secondaryColor : Color(red: 36/255, green: 180/255, blue: 126/255)
    }
    
    
    var labelColors: Color {
        return status == "passive" ? primaryColor : .white
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        restart()
                    } label: {
                        Image(systemName: "gobackward")
                            .font(.system(size: 30))
                            .foregroundColor(labelColors)
                    }
                    .disabled(status == "active")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -30, trailing: 0))
                    Spacer()
                        
                    Button {
                        showConfiguration = true;
                    } label: {
                        Image(systemName: "gear.badge")
                            .font(.system(size: 30))
                            .foregroundColor(labelColors)
                    }
                    .disabled(status == "active")
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -30, trailing: 0))
                }
                .padding()
                Spacer()
                Text("\(formatTimer())")
                    .font(.system(size: 70))
                    .onReceive(timer) { _ in
                        if timeRunning && currentRound < totalRounds + 1 {
                            seconds -= 1;
                            if seconds < 1 && minutes == 0 {
                                toggleTimer()
                            } else if seconds < 1 {
                                seconds = 59
                                minutes -= 1;
                            }
                        }
                    }
                    .foregroundColor(labelColors)
                    .padding()
                statusButtonRow
                Spacer()
                Spacer()
                HStack {
                    Text("Round \(currentRound)/\(totalRounds)")
                        .font(.system(size: 30))
                        .foregroundColor(labelColors)
                }
            }
            .padding()
            .fullScreenCover(isPresented: $showConfiguration, content: {
                ConfigurationView(activeSeconds: $activeTimeSeconds, activeTimeSound: $activeTimeSound, passiveTimeSound: $passiveTimeSound, numberOfRounds: $totalRounds, activeMinutes: $activeTimeMinutes, passiveMinutes: $passiveTimeMinutes, passiveSeconds: $passiveTimeSeconds) { val in
                    
                    restart()
                }
            })
            .background(backgroundColor)
            .onAppear {
                numberOfRounds = 10
                activeTimeSeconds = 10
                UIApplication.shared.isIdleTimerDisabled = true
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
        if (status == "passive") {
            seconds = activeTimeSeconds
            minutes = activeTimeMinutes
            status = "active"
            if currentRound < totalRounds + 1 {
                nextRound()
            }
        } else {
            seconds = passiveTimeSeconds
            minutes = passiveTimeMinutes
            status = "passive"
        }
        playMySound()

    }
    
    func previousRound() {
        currentRound -= 1
        toggleTimer()
    }
    
    func nextRound() {
        currentRound += 1
    }
    
    func restart() {
        seconds = passiveTimeSeconds
        minutes = passiveTimeMinutes
        currentRound = 1
    }
    func playMySound() {
        // 1323 - train
        // 1325 - flauta
        // 1328 - idea para pasivo
        // 1330 - cuerno de guerra
        // 1333 - sonido electrico
        do {
            try AVAudioSession.sharedInstance()
               .setCategory(.playback)
        } catch {
            print("AppDelegate Debug - Error setting AVAudioSession category. Because of this, there may be no sound. \(error)")
        }
        if (status == "passive") {
            AudioServicesPlaySystemSound(SystemSoundID(1328))
            AudioServicesPlayAlertSound(SystemSoundID(1328))
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(1333))
            AudioServicesPlayAlertSound(SystemSoundID(1333))
        }
        
    }
    
    func changeState() {
        timeRunning = !timeRunning
    }
    
    var statusButtonRow: some View {
        HStack {
            Button {
                previousRound()
            } label: {
                Image(systemName: "chevron.left.2")
                    .foregroundColor(currentRound <= 1 ? .gray : labelColors)
            }
            .font(.system(size: 30))
            .padding()
            .disabled(currentRound <= 1)

            Spacer()
            Button {
                changeState()
            } label: {
                Text(timeRunning ? "Stop" : "Start")
                    .font(.system(size: 40))
                    .frame(width: 200, height: 200)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 100)
                                    .stroke(labelColors, lineWidth: 2)
                    })
                    .foregroundColor(labelColors)
                    .padding()
            }
            Spacer()
            Button {
                toggleTimer()
            } label: {
                Image(systemName: "chevron.right.2")
                    .foregroundColor(currentRound == totalRounds ? .gray : labelColors)
            }
            .font(.system(size: 30))
            .padding()
            .disabled(currentRound >= totalRounds)


        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
