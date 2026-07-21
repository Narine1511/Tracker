//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerRecordStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: AppDelegate.shared.context)
    }
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // Получить записи за определённую дату
    func fetch(by date: Date) -> [TrackerRecord] {
        
    }
    // Отметить трекер как выполненный
    func save(_ record: TrackerRecord) throws {
        let entity = TrackerRecordCoreData(context: context)
        updateEntity(entity, with: record)
        try CoreDataManager.shared.saveContext()
    }
    // Отменить выполнение
    func delete(_ record: TrackerRecord) throws {
    }
    // Проверить, выполнен ли трекер
}
