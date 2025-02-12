//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Vitaly Lobov on 04.02.2025.
//

import CoreData
import UIKit

final class TrackerRecordStore: NSObject {
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
    
    func fetchRecord(id: UUID, date: Date) throws -> TrackerRecordCodeData? {
        let fetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", id as CVarArg, startOfDay as CVarArg)
        do {
             let result = try context.fetch(fetchRequest)
             return result.first
         } catch {
             throw error
         }
    }
    
    func updateRecord(id: UUID, date: Date) throws {
        let calendar = Calendar.current
        let currentDateWithoutTime = calendar.startOfDay(for: Date())
        let dateWithoutTime = calendar.startOfDay(for: date)
        
        guard dateWithoutTime <= currentDateWithoutTime else {
            return
        }
        
        if let existingRecord = try fetchRecord(id: id, date: dateWithoutTime) {
            context.delete(existingRecord)
        } else {
            let newRecord = TrackerRecordCodeData(context: context)
            newRecord.id = id
            newRecord.date = dateWithoutTime
            print("Записано, что трекер \(id) выполнен \(dateWithoutTime)")
        }
        saveContext()
    }
    
    func deleteRecord(id: UUID, date: Date) throws {
        if let record = try fetchRecord(id: id, date: date) {
            self.context.delete(record)
            self.saveContext()
            print("Удалена запись трекера \(id) за \(date)")
        }
    }
    
    func completedDays(for id: UUID) throws -> [Date] {
        let fetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let result = try context.fetch(fetchRequest)
        let dates = result.compactMap { $0.date }
        return dates
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
}
