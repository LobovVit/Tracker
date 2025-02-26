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
        }
        saveContext()
    }
    
    func deleteRecord(id: UUID, date: Date) throws {
        if let record = try fetchRecord(id: id, date: date) {
            self.context.delete(record)
            self.saveContext()
        }
    }
    
    func completedDays(for id: UUID) throws -> [Date] {
        let fetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let result = try context.fetch(fetchRequest)
        let dates = result.compactMap { $0.date }
        return dates
    }
    
    func completedTrackers() -> Int {
        do {
            let fetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
            let result = try context.fetch(fetchRequest).count
            return result
        } catch {
            print("ERR: completedTrackers: \(error)")
            return 0
        }
    }
    
    func countPerfectDays() -> Int {
        do {
            let trackersFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            let allTrackers = try context.fetch(trackersFetchRequest)
            
            let recordsFetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
            let allRecords = try context.fetch(recordsFetchRequest)
            
            var recordsByDate: [Date: Set<UUID>] = [:]
            for record in allRecords {
                guard let recordID = record.id, let recordDate = record.date else { continue }
                recordsByDate[recordDate, default: []].insert(recordID)
            }
            
            var perfectDaysCount = 0
            
            for (recordDate, completedTrackers) in recordsByDate {
                let calendar = Calendar.current
                let dayNumber = calendar.component(.weekday, from: recordDate) 
                guard let weekDay = DayOfWeek.getDayEnum(number: dayNumber) else { continue }
                
                let scheduledTrackers = allTrackers.filter { tracker in
                    guard let scheduleJSON = tracker.scheduler,
                          let scheduleDays = scheduleJSON.toEnumArray() as [DayOfWeek]? else { return false }
                    return scheduleDays.contains(weekDay)
                }
                
                let scheduledTrackerIDs = Set(scheduledTrackers.compactMap { $0.id })
                
                if !scheduledTrackerIDs.isEmpty, scheduledTrackerIDs.isSubset(of: completedTrackers) {
                    perfectDaysCount += 1
                }
            }
            
            return perfectDaysCount
        } catch {
            print("ERR: countPerfectDays: \(error)")
            return 0
        }
    }
    
    func longestPerfectStreak() -> Int {
        do {
            let trackersFetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
            let allTrackers = try context.fetch(trackersFetchRequest)
            
            let recordsFetchRequest: NSFetchRequest<TrackerRecordCodeData> = TrackerRecordCodeData.fetchRequest()
            let allRecords = try context.fetch(recordsFetchRequest)
            
            var recordsByDate: [Date: Set<UUID>] = [:]
            for record in allRecords {
                guard let recordID = record.id, let recordDate = record.date else { continue }
                recordsByDate[recordDate, default: []].insert(recordID)
            }
            
            var perfectDays: Set<Date> = []
            
            for (recordDate, completedTrackers) in recordsByDate {
                let calendar = Calendar.current
                let dayNumber = calendar.component(.weekday, from: recordDate)
                guard let weekDay = DayOfWeek.getDayEnum(number: dayNumber) else { continue }
                
                let scheduledTrackers = allTrackers.filter { tracker in
                    guard let scheduleJSON = tracker.scheduler,
                          let scheduleDays = scheduleJSON.toEnumArray() as [DayOfWeek]? else { return false }
                    return scheduleDays.contains(weekDay)
                }
                
                let scheduledTrackerIDs = Set(scheduledTrackers.compactMap { $0.id })
                
                if !scheduledTrackerIDs.isEmpty, scheduledTrackerIDs.isSubset(of: completedTrackers) {
                    perfectDays.insert(recordDate)
                }
            }
            
            return longestConsecutiveStreak(from: perfectDays)
        } catch {
            print("ERR: longestPerfectStreak: \(error)")
            return 0
        }
    }
    
    private func longestConsecutiveStreak(from dates: Set<Date>) -> Int {
        let sortedDates = dates.sorted()
        var maxStreak = 0
        var currentStreak = 0
        var previousDate: Date?
        
        for date in sortedDates {
            if let prev = previousDate, Calendar.current.isDate(date, inSameDayAs: Calendar.current.date(byAdding: .day, value: 1, to: prev)!) {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
            maxStreak = max(maxStreak, currentStreak)
            previousDate = date
        }
        
        return maxStreak
    }
    
    private func saveContext() {
        do {
            try context.save()
            NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: nil)
        } catch {
            context.rollback()
        }
    }
    
}
