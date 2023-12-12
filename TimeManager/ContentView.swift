//
//  ContentView.swift
//  TimeManager
//
//  Created by Ariel Ortiz on 12/2/23.
//

import SwiftUI

struct ContentView: View {
        
    @StateObject var timeMN = TimeManager()
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }()
    
    var body: some View {
        VStack {
            HStack{
                Text("Time counter:")
                Text(timeMN.timeCounter, formatter: dateFormatter)
                Spacer()
            }
            HStack{
                Text("Start time:")
                Text(timeMN.startTime, formatter: dateFormatter)
                Spacer()
            }
            HStack{
                Text("End time:")
                Text(timeMN.endTime, formatter: dateFormatter)
                Spacer()
            }
            HStack{
                Text("Rule time seconds:")
                Text("\(timeMN.ruleTimeSeconds)")
                Spacer()
            }
            HStack{
                Text("Rule time extra seconds:")
                Text("\(timeMN.ruleTimeExtraSeconds)")
                Spacer()
            }
        }
        .padding()
        .onAppear{
            timeMN.start(endTimeSeconds: 30, ruleTimeSeconds: 10, ruleTimeExtraSeconds: 20)
        }
        .onReceive(timeMN.timer) { _ in
            timeMN.track()
            
        }
        
    }
}

#Preview {
    ContentView()
}
