//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 20.07.2026.
//

import CoreData
final class TrackerRecordStore: NSObject,NSFetchedResultsControllerDelegate {
    
    private let context: NSManagedObjectContext
    var onUpdate: (() -> Void)?
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
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
    
    // Получить все данные
    func fetchAll() -> [TrackerRecord] {
        let entities = fetchedResultsController.fetchedObjects ?? []
        return entities.map { convertModel($0) }
    }
    
    // Получить записи за определённую дату
    func fetch(by date: Date) -> [TrackerRecord] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "date >= %@ AND date < %@",
            startOfDay as CVarArg,
        endOfDay as CVarArg
        )
        guard let entities = try? context.fetch(request) else {
            return []
        }
        return entities.map { convertModel($0)}
        
    }
    // Отметить трекер как выполненный
    func save(_ record: TrackerRecord) {
        print("Сохранено успешно")
        let entity = TrackerRecordCoreData(context: context)
        entity.trackerId = record.trackerId
        entity.date = record.date
        AppDelegate.shared.saveContext()
    }
    // Отменить выполнение
    func delete(_ record: TrackerRecord) {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            record.trackerId as CVarArg,
            record.date as CVarArg
        )
        guard let entity = try? context.fetch(request).first else {
        /*{throw NSError(
         domain: "TrackerRecordStore",
         code: 404,
         userInfo: [NSLocalizedDescriptionKey: "Record not found"])
         }*/
            return
            }
        context.delete(entity)
        AppDelegate.shared.saveContext()
    }
    // Проверить, выполнен ли трекер
    
    func isRecorded(trackerId: UUID, date: Date) -> Bool {
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
        trackerId as CVarArg,
        date as CVarArg
        )
        request.fetchLimit = 1
        let count = try? context.count(for: request)
        return count ?? 0 > 0
    }
    
    private func convertModel(_ entity: TrackerRecordCoreData) -> TrackerRecord {
        return TrackerRecord(
            trackerId: entity.trackerId ?? UUID(),
            date: entity.date ?? Date()
        )
    }
}
