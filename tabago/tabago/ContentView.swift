//
//  ContentView.swift
//  tabago
//
//  Created by Diego Mendoza on 8/2/23.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct ContentView: View {
    
    let defaults = UserDefaults.standard;
    
    var primaryColor = Color(red: 62/255, green: 207/255, blue: 142/255)
    var activeColor = Color(red: 245/255,green: 59/255, blue: 102/255)
    var secondaryColor = Color(red: 24/255, green: 24/255, blue: 24/255)
    
    @State var activeTimeMinutes: Int = 0
    @State var activeTimeSeconds: Int = 5
    @State var passiveTimeMinutes: Int = 0
    @State var passiveTimeSeconds: Int = 5
    @State var numberOfRounds: Int = 10
    @State var status: String = "initial"
    @State var showConfiguration = false 
    @State var currentRound = 1
    @State var totalRounds = 10
    
    @State var activeTimeSound = "Alarm"
    @State var passiveTimeSound = "Alarm"
    @State var seconds = 5;
    @State var minutes = 0;
    @State var timeRunning = false;
    
    @State var circleParts = 0.20
    @State var circleDivision = 20.0
    @State var circleProgress = 1
    
    @State var timerStarted = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();


    
    func initDefaults() {
        activeTimeMinutes =  defaults.integer(forKey: "activeTimeMinutes")
        activeTimeSeconds =  defaults.integer(forKey: "activeTimeSeconds")
        
        passiveTimeMinutes =  defaults.integer(forKey: "passiveTimeMinutes")
        passiveTimeSeconds =  defaults.integer(forKey: "passiveTimeSeconds")
        numberOfRounds =  defaults.integer(forKey: "numberOfRounds")
        totalRounds = numberOfRounds
    }
    
    var backgroundColor: Color {
        if status == "initial" {
            return Color.blue
        }
        return secondaryColor
    }
    
    
    var labelColors: Color {
        if status == "passive" {
            return primaryColor
        } else if status == "active" {
            return activeColor
        }
        return .white
    }
    
    var body: some View {
        NavigationView {
            VStack {
                actionButtons
                Spacer()
                Text("\(formatTimer())")
                    .font(.system(size: 120))
                    .onReceive(timer) { _ in
                        if timeRunning && currentRound < totalRounds + 1 {
                            seconds -= 1;
                            if seconds < 1 && minutes == 0 {
                                toggleTimer()
                            } else if seconds < 1 {
                                seconds = 59
                                minutes -= 1;
                            }
                            updateCircle()
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
                UIApplication.shared.isIdleTimerDisabled = true
                MPVolumeView.setVolume(7.00)
//                initDefaults()
//                print(UserDefaults.standard.dictionaryRepresentation());
//                totalRounds = defaults.integer(forKey: "numberOfRounds")
//                activeTimeMinutes =  defaults.integer(forKey: "activeTimeMinutes")
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
        var total: Double = 0.0
        if (status == "passive") {
            seconds = activeTimeSeconds
            minutes = activeTimeMinutes
            status = "active"
            total = Double((activeTimeMinutes * 60) + activeTimeSeconds)
        } else {
            seconds = passiveTimeSeconds
            minutes = passiveTimeMinutes
            status = "passive"
            total = Double((passiveTimeMinutes * 60) + passiveTimeSeconds)
            if currentRound < totalRounds + 1 && timerStarted {
                nextRound()
            }
            if currentRound == 1 {
                timerStarted = true
            }
        }
        circleParts = 0.0
        circleDivision = Double(100 / total)
        circleProgress = 1
        playMySound()

    }
    
    func previousRound() {
        if currentRound != 1 {
            currentRound -= 1
        }
        toggleTimer()
    }
    
    func nextRound() {
        currentRound += 1
    }
    
    func restart() {
        seconds = 5
        minutes = 0
        currentRound = 1
        status = "initial"
        circleParts = 0.20
        circleDivision = 20.0
            circleProgress = 1
    }
    
    func updateCircle() {
        circleParts = circleDivision * Double(circleProgress) / 100
        circleProgress += 1
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
                    .foregroundColor(currentRound <= 1 && (status == "initial" || status == "passive") ? .gray : labelColors)
            }
            .font(.system(size: 30))
            .disabled(currentRound <= 1 && (status == "initial" || status == "passive"))
            .padding()


            Spacer()
            Button {
                changeState()
            } label: {
                Text(timeRunning ? "Stop" : "Start")
                    .font(.system(size: 40))
                    .frame(width: 200, height: 200)
                    .overlay(content: {
                        ZStack {
                            Circle()
                                .stroke(labelColors, lineWidth: 10)
                                .opacity(0.5)
                            Circle()
                                .trim(from: 0, to: circleParts)
                                .stroke(labelColors, lineWidth: 10)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeIn, value: circleParts)
                        }
                        
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
    
    var actionButtons: some View {
        HStack {
            Button {
                restart()
            } label: {
                Image(systemName: "gobackward")
                    .font(.system(size: 30))
                    .foregroundColor(labelColors)
            }
            .disabled(timeRunning)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -30, trailing: 0))
            Spacer()
                
            Button {
                showConfiguration = true;
            } label: {
                Image(systemName: "gear.badge")
                    .font(.system(size: 30))
                    .foregroundColor(labelColors)
            }
            .disabled(timeRunning)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: -30, trailing: 0))
        }
        .padding()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//Update system volume
extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}
