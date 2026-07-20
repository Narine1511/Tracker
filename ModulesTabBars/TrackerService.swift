//
//  Models.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 05.07.2026.
//

import UIKit

struct Tracker {
    let id: UUID
    let label: String
    let color: String
    let emoji: String
    let timetable: TrackerSchedule
    
    init(id: UUID, label: String, color: String, emoji: String, timetable: TrackerSchedule) {
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
    let trackerId: UUID
    let date: Date

    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
    
}

struct TrackerSchedule {
    let days: [Weekday]
}
    
    enum Weekday: String, CaseIterable {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
        
        
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
        var numberInCalendar: Int {
            switch self {
            case .monday: return 2
            case .tuesday: return 3
            case .wednesday: return 4
            case .thursday: return 5
            case .friday: return 6
            case .saturday: return 7
            case .sunday: return 1
            }
        }
    }

