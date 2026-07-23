//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerCategoryStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    var onUpdate: (() -> Void)?
    
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
   override convenience init() {
        self.init(context: AppDelegate.shared.context)
    }
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        try?fetchedResultsController.performFetch()
    }
    

    // Получить все категории
    func fetchAll() -> [TrackerCategory] {
        let entities = fetchedResultsController.fetchedObjects ?? []
        return entities.map { convertModel($0)}
    }
    // Создать категорию
    func save(_ category: TrackerCategory) {
        let entity = TrackerCategoryCoreData(context: context)
        entity.title = category.title
        AppDelegate.shared.saveContext()
        }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onUpdate?()
    }
    private func convertModel(_ entity: TrackerCategoryCoreData) -> TrackerCategory {
        return TrackerCategory(
            id: entity.id ?? UUID(),
            title: entity.title ?? "",
            trackers: [])   }
    }
