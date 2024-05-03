//
//  TimerStorage.swift
//  SatelliTrack
//
//  Created by Hugo Pereira on 03/05/2024.
//

import UIKit


/// This class is used to store the timers
class TimerStorage: Identifiable {
    
    static private var timerTab: [Timer] = []
    
    static func addTimer(timer: Timer) {
        timerTab.append(timer)
    }
    
    static func removeTimer() {
        for timer in timerTab {
            timer.invalidate()
        }
    }
}
