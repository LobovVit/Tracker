//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Vitaly Lobov on 04.02.2025.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case missingName
    case missingCategoryName
    case missingID
    case missingColor
    case missingEmoji
    case invalidSchedule
}

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(
        _ store: TrackerCategoryStore,
        didUpdate update: TrackerCategoryStoreUpdate
    )
}

final class TrackerCategoryStore: NSObject, ObservableObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private let trackerStore = TrackerStore()
    
    @Published var categories: [TrackerCategoryCoreData] = []
    
    weak var delegate: TrackerCategoryStoreDelegate?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
    var trackerCategories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let categories = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return categories
    }
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure("AppDelegate could not be cast to expected type.")
            self.init(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch {
            print("Err: controller.performFetch : \(error)")
        }
    }
    
    func fetchCategories() {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Err: Failed to fetch categories: \(error)")
        }
    }
    
    func addCategory(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else { return } // Игнорируем пустые названия
        guard !categoryExists(name: trimmedName) else {
            print("Err: Категория с таким именем уже существует!")
            return
        }
        
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.name = trimmedName
        
        do {
            try context.save()
        } catch {
            print("Err: Ошибка при сохранении категории: \(error)")
        }
    }
    
    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Err: Failed to fetch categories: \(error)")
            return []
        }
    }
    
    private func categoryExists(name: String) -> Bool {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print("Err: Ошибка при проверке существования категории: \(error)")
            return false
        }
    }
    
    func trackerCategory(from trackerCategoryStore: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryStore.name else { throw TrackerCategoryStoreError.missingCategoryName }
        var trackers: [Tracker] = []
        guard let trackerSet = trackerCategoryStore.tracker as? Set<TrackerCoreData> else {
            return TrackerCategory(name: name, trackers: [])
        }
        for trackerCoreData in trackerSet {
            do {
                guard let id = trackerCoreData.id else {
                    throw TrackerCategoryStoreError.missingID
                }
                guard let name = trackerCoreData.name else {
                    throw TrackerCategoryStoreError.missingName
                }
                guard let color = UIColor.from(data: trackerCoreData.color)  else {
                    throw TrackerCategoryStoreError.missingColor
                }
                guard let emoji = trackerCoreData.emoji  else {
                    throw TrackerCategoryStoreError.missingEmoji
                }
                let schedule: [DayOfWeek] = trackerCoreData.scheduler?.toEnumArray() ?? []
                trackers.append(Tracker(id: id, name: name, color: color, emoji: emoji, scheduler: schedule, isPinned: false))
            } catch {
                print("Err: trackerCoreData in trackerSet for \(name): \(error)")
            }
        }
        return TrackerCategory(name: name, trackers: trackers)
    }
    
    func updateTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@", trackerCategory.name.trimmingCharacters(in: .whitespacesAndNewlines))

        let fetchedResults = try context.fetch(fetchRequest)
        
        let trackerCategoryCoreData: TrackerCategoryCoreData
        
        if let existingCategory = fetchedResults.first {
            trackerCategoryCoreData = existingCategory
        } else {
            trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.name = trackerCategory.name
        }

        var updatedTrackers = trackerCategoryCoreData.tracker as? Set<TrackerCoreData> ?? Set<TrackerCoreData>()
        updatedTrackers.formUnion(updateTrackersInCategory(trackerCategoryCoreData, with: trackerCategory))
        
        trackerCategoryCoreData.tracker = updatedTrackers as NSSet
        
        try context.save()
    }
    
    func updateTrackersInCategory(_ trackerCategoryCorData: TrackerCategoryCoreData, with category: TrackerCategory) -> Set<TrackerCoreData> {

        var newTrackers = Set<TrackerCoreData>()

        for tracker in category.trackers {
            if let existingTrackerCoreData = trackerStore.fetchTrackerCoreData(tracker: tracker) {
                newTrackers.insert(existingTrackerCoreData)
            } else {
                guard let context = trackerCategoryCorData.managedObjectContext else {
                    continue
                }
                let newTrackerCoreData = TrackerCoreData(context: context)
                newTrackerCoreData.id = tracker.id
                newTrackerCoreData.name = tracker.name
                newTrackerCoreData.color = tracker.color.toData() ?? Data()
                newTrackerCoreData.emoji = tracker.emoji
                newTrackerCoreData.scheduler = tracker.scheduler.toJSONString()
                newTrackerCoreData.category = trackerCategoryCorData
                newTrackers.insert(newTrackerCoreData)
            }
        }

        return newTrackers
    }
    
    func clearCoreData(for entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Err: clearCoreData: \(error.localizedDescription)")
        }
    }
    
}


extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = TrackerCategoryStoreUpdate(
            insertedIndexes: insertedIndexes ?? [],
            deletedIndexes: deletedIndexes ?? [],
            updatedIndexes: updatedIndexes ?? [],
            movedIndexes: movedIndexes ?? []
        )
        
        delegate?.store(self, didUpdate: update)
        
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
