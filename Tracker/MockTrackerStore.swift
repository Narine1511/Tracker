//
//  MockTrackerStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 22.08.2026.
//

import Foundation

protocol TrackerStoreProtocol {
    func fetchAll() -> [Tracker]
    func save(_ tracker: Tracker)
    func delete(_ tracker: Tracker) throws
    func update(_ tracker: Tracker) throws
    var onUpdate: (() -> Void)? { get set } 
}

final class MockTrackerStore: TrackerStoreProtocol {
    var onUpdate: (() -> Void)?
    private var mockTrackers: [Tracker] = []
    
    func fetchAll() -> [Tracker] {
        return mockTrackers
    }
    
    func save(_ tracker: Tracker) {
            mockTrackers.append(tracker)
        }
    
    func delete(_ tracker: Tracker) throws {
            mockTrackers.removeAll { $0.id == tracker.id }
        }
    
    func setMockData(_ trackers: [Tracker]) {
            mockTrackers = trackers
        }
    func update(_ tracker: Tracker) throws {}
}
