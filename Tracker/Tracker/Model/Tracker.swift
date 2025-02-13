//
//  Tracker.swift
//  Tracker
//
//  Created by Vitaly Lobov on 25.12.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let scheduler: [DayOfWeek]
}

enum DayOfWeek: String, Codable {
    case mon = "Понедельник"
    case tue = "Вторник"
    case wed = "Среда"
    case thu = "Четверг"
    case fri = "Пятница"
    case sat = "Суббота"
    case sun = "Воскресенье"
    var shortWeekDay: String {
        switch self {
        case .mon: return "Пн"
        case .tue: return "Вт"
        case .wed: return "Ср"
        case .thu: return "Чт"
        case .fri: return "Пт"
        case .sat: return "Сб"
        case .sun: return "Вс"
        }
    }
    static func getDay(number: Int) -> String {
        switch number {
        case 1: return DayOfWeek.mon.rawValue
        case 2: return DayOfWeek.tue.rawValue
        case 3: return DayOfWeek.wed.rawValue
        case 4: return DayOfWeek.thu.rawValue
        case 5: return DayOfWeek.fri.rawValue
        case 6: return DayOfWeek.sat.rawValue
        case 7: return DayOfWeek.sun.rawValue
        default: return ""
        }
    }
    
    static func getDayEnum(number: Int) -> DayOfWeek? {
        switch number {
        case 1: return DayOfWeek.sun
        case 2: return DayOfWeek.mon
        case 3: return DayOfWeek.tue
        case 4: return DayOfWeek.wed
        case 5: return DayOfWeek.thu
        case 6: return DayOfWeek.fri
        case 7: return DayOfWeek.sat
        default: return nil
        }
    }
}

extension DayOfWeek: CaseIterable {}
