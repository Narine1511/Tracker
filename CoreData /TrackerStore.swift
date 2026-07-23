//
//  TrackerStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerStore: NSObject, NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    var onUpdate: (() -> Void)?
    
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "label", ascending: true)]
        
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
    
    // Создать новый трекер
    func save(_ tracker: Tracker) {
        print("TrackerStore.save() начат")
            print("Название: \(tracker.label)")
            print("Дни (модель): \(tracker.timetable.days.map { $0.rawValue })")
        print("ID: \(tracker.id), \(tracker.label), \(tracker.emoji), \(tracker.color), \(tracker.timetable.days.map { $0.rawValue })")
        let entity = TrackerCoreData(context: context)
        updateEntity(entity, with: tracker)
        print("После updateEntity: entity.days = \(entity.days ?? "nil")")
            
        AppDelegate.shared.saveContext()
        onUpdate?()
        print("onUpdate вызван")
    }
    
    // Получить все трекеры
    func fetchAll() -> [Tracker] {
        let entities = fetchedResultsController.fetchedObjects ?? []
        return entities.map { convertModel($0)}
    }
    
 /*   // Изменить трекер
    func update(_ tracker: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let entity = try context.fetch(request).first else
        { throw NSError(
            domain: "TrackerStore",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
        }
        updateEntity(entity, with: tracker)
        try AppDelegate.shared.saveContext()
    }*/
    
    // Удалить трекер
    func delete(_ tracker: Tracker) throws {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        guard let entity = try context.fetch(request).first else
        { throw NSError(
            domain: "TrackerStore",
            code: 404,
            userInfo: [NSLocalizedDescriptionKey: "Tracker not found"])
        }
        context.delete(entity)
        AppDelegate.shared.saveContext()
    }
    
    private func updateEntity(_ entity: TrackerCoreData, with model: Tracker) {
        entity.id = model.id
        entity.label = model.label
        entity.emoji = model.emoji
        entity.color = model.color
        
        let dayStrings = model.timetable.days.map { $0.rawValue }
        /*entity.days = dayStrings as NSObject*/
        entity.days = dayStrings.joined(separator: ",")
    }
    
    private func convertModel(_ entity: TrackerCoreData) -> Tracker {
        var days: [Weekday] = []
        if let dayString = entity.days, !dayString.isEmpty {
                    days = dayString.split(separator: ",").compactMap { Weekday(rawValue: String($0)) }
                }
        return Tracker(
            id: entity.id ?? UUID(),
            label: entity.label ?? "",
            color: entity.color ?? "",
            emoji: entity.emoji ?? "",
            timetable: TrackerSchedule(days: days)
        )
    }
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
            onUpdate?()
        }
    }
