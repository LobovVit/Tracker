//
//  TrackerStore.swift
//  Tracker
//
//  Created by Vitaly Lobov on 04.02.2025.
//

import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate could not be cast to expected type.")
        }
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    private func saveContext() {
        do {
            try context.save()
            NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: nil)
        } catch {
            context.rollback()
        }
    }
    
    func fetchTrackerCoreData(tracker: Tracker) -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults.first
        } catch {
            return nil
        }
    }
    
    func updateTracker(_ tracker: Tracker, newCategory: String? = nil) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            let trackerCoreData: TrackerCoreData
            
            if let existingTracker = results.first {
                trackerCoreData = existingTracker
            } else {
                trackerCoreData = TrackerCoreData(context: context)
                trackerCoreData.id = tracker.id
            }
            
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color.toData()
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.scheduler = tracker.scheduler.toJSONString()
            
            if let newCategoryName = newCategory {
                let categoryFetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
                categoryFetchRequest.predicate = NSPredicate(format: "name ==[c] %@", newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines))
                
                let fetchedCategories = try context.fetch(categoryFetchRequest)
                if let newCategoryCoreData = fetchedCategories.first {
                    trackerCoreData.category = newCategoryCoreData
                } else {
                    let newCategoryCoreData = TrackerCategoryCoreData(context: context)
                    newCategoryCoreData.name = newCategoryName
                    trackerCoreData.category = newCategoryCoreData
                }
            }
            saveContext()
        } catch {
            print("ERR: Ошибка при сохранении/обновлении трекера:", error)
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            
            if let trackerToDelete = results.first {
                context.delete(trackerToDelete)
                saveContext()
            }
        } catch {
            print("ERR: Ошибка при удалении трекера:", error)
        }
    }
    
    func changePinnedTracker(_ tracker: Tracker) {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
        do {
            let results = try context.fetch(fetchRequest)
            
            if let trackerToChangePinned = results.first {
                trackerToChangePinned.isPinned = !trackerToChangePinned.isPinned
                saveContext()
            }
        } catch {
            print("ERR: Ошибка при удалении трекера:", error)
        }
    }
    
    func trackersCount() -> Int {
        do {
            let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            let result = try context.fetch(fetchRequest).count
            return result
        } catch {
            print("ERR: trackersCount: \(error)")
            return 0
        }
    }
    
}
