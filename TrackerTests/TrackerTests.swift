//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Наринэ  Овсепян on 19.06.2026.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    
    @MainActor
    func testViewControllerLight() {
        
        let testTrackers = [
                
                    Tracker(
                        id: UUID(),
                        label: "Йога",
                        color: "ypLightGreen",
                        emoji: "🧘",
                        timetable: TrackerSchedule(days: [.monday, .wednesday, .friday, .saturday, .sunday, .tuesday, .thursday]),
                        category: nil
                    )
                ]
        let mockStore = MockTrackerStore()
        mockStore.setMockData(testTrackers)
        
        let vc = ViewController()
        vc.trackerStore = mockStore
        
        vc.loadData()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)),
                       record: false
        )
      
    }
    
    func testViewControllerDark() {
        
        let testTrackers = [
                
                    Tracker(
                        id: UUID(),
                        label: "Йога",
                        color: "ypLightGreen",
                        emoji: "🧘",
                        timetable: TrackerSchedule(days: [.monday, .wednesday, .friday, .saturday, .sunday, .tuesday, .thursday]),
                        category: nil
                    )
                ]
        let mockStore = MockTrackerStore()
        mockStore.setMockData(testTrackers)
        
        let vc = ViewController()
        vc.trackerStore = mockStore
        
        vc.loadData()
        
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)),
                       record: false
        )
      
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
