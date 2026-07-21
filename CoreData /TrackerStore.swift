//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: AppDelegate.shared.context)
    }
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // Получить все трекеры
    func fetchAll() -> [Tracker] {
        let request = TrackerCoreData.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { convertToModel($0) }
        } catch {
            return []
        }
    }
    // Создать новый трекер
    func save(_ tracker: Tracker) throws {
        let entity = TrackerCoreData(context: context)
        updateEntity(entity, with: tracker)
        try CoreDataManager.shared.saveContext()
    }
}
    private func updateEntity(_ entity: TrackerCoreData, with model: Tracker) { ... }
    private func convertToModel(_ entity: TrackerCoreData) -> Tracker { ... }
    
