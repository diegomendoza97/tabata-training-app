//
//  StateWrapper.swift
//  tabago
//
//  Created by Diego Mendoza on 8/7/23.
//

import Foundation
class StateWrapper {
    var activeTimeMinutes: Int
    var activeTimeSeconds: Int
    var passiveTimeMinutes: Int?
    var passiveTimeSeconds: Int?
    var numberOfRounds: Int?
    var currentRound = 0
    var status: String = "passive"
    
    init(activeTimeMinutes: Int, activeTimeSeconds: Int, passiveTimeMinutes: Int? = nil, passiveTimeSeconds: Int? = nil, numberOfRounds: Int? = nil, currentRound: Int = 0, status: String) {
        self.activeTimeMinutes = activeTimeMinutes
        self.activeTimeSeconds = activeTimeSeconds
        self.passiveTimeMinutes = passiveTimeMinutes
        self.passiveTimeSeconds = passiveTimeSeconds
        self.numberOfRounds = numberOfRounds
        self.currentRound = currentRound
        self.status = status
    }
}
