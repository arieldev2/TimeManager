//
//  TimeManager.swift
//  TimeManager
//
//  Created by Ariel Ortiz on 12/2/23.
//

import Foundation

final class TimeManager: ObservableObject{
        
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(){
        timer.upstream.connect().cancel()
    }
    
    var calendar: Calendar {
        let userLocale = Locale.autoupdatingCurrent
        var gregorianCalendar = Calendar(identifier: .gregorian)
        gregorianCalendar.locale = userLocale
        return gregorianCalendar
    }
    
    @Published var timeCounter: Date = .now
    @Published var startTime: Date = .now
    @Published var endTime: Date = .now
    @Published var ruleTimeSeconds: Double = 0.0
    @Published var ruleTimeExtraSeconds: Double = 0.0
    
    /// Set everything up to start tracking
    /// - Parameters:
    ///   - startTime: The started time (default: .now)
    ///   - endTimeSeconds: The end time in seconds
    ///   - ruleTimeSeconds: The time in seconds in which the extra seconds must be added
    ///   - ruleTimeExtraSeconds: The amount of that time in seconds to add
    func start(startTime: Date = .now, endTimeSeconds: Double, ruleTimeSeconds: Double = 0.0, ruleTimeExtraSeconds: Double = 0.0){
        self.startTime = startTime
        self.ruleTimeSeconds = ruleTimeSeconds
        self.ruleTimeExtraSeconds = ruleTimeExtraSeconds
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: startTime)
        guard let newStartDate = calendar.date(from: components) else {return}
        self.startTime = newStartDate
        self.endTime = startTime.addingTimeInterval(endTimeSeconds)
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
    
    /// Track the time
    func track(){
        self.timeCounter = Date()
        // Check the distance to the end time
        let currentTime = Date().distance(to: endTime)
        if currentTime <= 0{
            timer.upstream.connect().cancel()
            return
        }
        
        // Check if the currentTime is minor to the ruleTimeSeconds to add the ruleTimeExtraSeconds
        if Int(currentTime) <= Int(ruleTimeSeconds){
            endTime = endTime.addingTimeInterval(ruleTimeExtraSeconds)
        }
    }
    
}
