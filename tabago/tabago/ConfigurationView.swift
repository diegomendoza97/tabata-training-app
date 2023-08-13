//
//  ConfigurationView.swift
//  tabago
//
//  Created by Diego Mendoza on 8/4/23.
//

import SwiftUI

struct ConfigurationView: View {
//    @Binding var state: StateWrapper
    @Binding var activeSeconds: Int
    @Binding var activeTimeSound: String
    @Binding var passiveTimeSound: String
    @Binding var numberOfRounds: Int
    @Binding var activeMinutes: Int
    
    @Binding var passiveMinutes: Int
    @Binding var passiveSeconds: Int
    
    // Output
    let updatedConfigurations: (String) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
                Form {
                    Section {
                        VStack {
                            HStack(alignment: .center){
                                Text("Time")
                                HStack {
                                    Picker("", selection: $activeMinutes){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) min").tag(i)
                                        }
                                    }.pickerStyle(.wheel)
                                        .frame(height: 100)
                                    Picker("", selection: $activeSeconds){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) sec").tag(i)
                                        }
                                    }.pickerStyle(WheelPickerStyle())
                                        .frame(height: 100)
                                }.aspectRatio(contentMode: .fit)
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Text("Sound")
                                TextField("Alarm", text: $activeTimeSound).multilineTextAlignment(.trailing)
                            }
                            
                        }
                    } header: {
                        Text("Active")
                        
                    }
//                    Passive Activity
                    Section {
                        VStack {
                            HStack(alignment: .center){
                                Text("Time")
                                HStack {
                                    Picker("", selection: $passiveMinutes){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) min").tag(i)
                                        }
                                    }.pickerStyle(.wheel)
                                        .frame(height: 100)
                                    Picker("", selection: $passiveSeconds){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) sec").tag(i)
                                        }
                                    }.pickerStyle(WheelPickerStyle())
                                        .frame(height: 100)
                                }.aspectRatio(contentMode: .fit)
                            }
                            Divider()
                            HStack(alignment: .center) {
                                Text("Sound")
                                TextField("Alarm", text: $passiveTimeSound).multilineTextAlignment(.trailing)
                            }
                            
                        }
                    } header: {
                        Text("Passive")
                    }
                    
                    Section {
                        VStack {
                            HStack(alignment: .center){
                                Text("Number of Rounds")
                                HStack {
                                    Picker("", selection: $numberOfRounds){
                                        ForEach(1..<99, id: \.self) { i in
                                            Text("\(i) round(s)").tag(i)
                                        }
                                    }.pickerStyle(WheelPickerStyle())
                                        .frame(height: 100)
                                }.aspectRatio(contentMode: .fit)
                            }
                        }
                    } header: {
                        Text("Passive")
                    }
                        
                }
            
                .navigationTitle(Text("Edit Configuration"))
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button {
                                updatedConfigurations("Test")
                                presentationMode.wrappedValue.dismiss()

                            } label: {
                                Text("Done")
                            }
                        }
                    }
        }
        
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        @State var activeTimeMinutes = 0
        @State var activeTimeSeconds = 10
        @State var passiveTimeMinutes = 0
        @State var passiveTimeSeconds = 10
        @State var activeTimeSound = "Alarm"
        @State var passiveTimeSound = "Alarm"
        @State var numberOfRounds = 2
        
        ConfigurationView(activeSeconds: $activeTimeSeconds, activeTimeSound: $activeTimeSound, passiveTimeSound: $passiveTimeSound, numberOfRounds: $numberOfRounds, activeMinutes: $activeTimeMinutes, passiveMinutes: $passiveTimeMinutes, passiveSeconds: $passiveTimeSeconds) { va in
            
        }
    }
}
