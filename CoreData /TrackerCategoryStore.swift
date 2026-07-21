//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerCategoryStore {
    private let context: NSManagedObjectContext
    
    convenience init() {
        self.init(context: AppDelegate.shared.context)
    }
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    // Получить все категории
    func fetchAll() -> [TrackerCategory] {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: "name", ascending: true)]
        do {
            let entities = try context.fetch(request)
            return entities.map { convertToModel($0)}
        } catch {
            return []
        }
        }
    // Создать категорию
    func save(_ category: TrackerCategory) throws {
        if let existing = fetch(by: category.name) {
            try update(category)
            return
        }
        let entity = TrackerCategoryCoreData(context: context)
        updateEntity(entity, with: category)
        try CoreData.shared.saveContext()
    }
    }
