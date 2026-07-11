//
//  Models.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 05.07.2026.
//

import Foundation

struct Tracker {
    let id: UInt
    let label: String
    let color: String
    let emoji: String
    let timetable: TrackerSchedule
    
    init(id: UInt, label: String, color: String, emoji: String, timetable: TrackerSchedule) {
        self.id = id
        self.label = label
        self.color = color
        self.emoji = emoji
        self.timetable = timetable
    }
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}

struct TrackerRecord {
    let trackerId: UInt
    let date: Date

    init(trackerId: UInt, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
    
}

struct TrackerSchedule {
    let days: [Weekday]
}
    
    enum Weekday: CaseIterable {
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday
        case sunday
        
        
        var shortName: String {
            switch self {
            case .monday: return "Пн"
                   case .tuesday: return "Вт"
                   case .wednesday: return "Ср"
                   case .thursday: return "Чт"
                   case .friday: return "Пт"
                   case .saturday: return "Сб"
                   case .sunday: return "Вс"
            }
        }
    }

