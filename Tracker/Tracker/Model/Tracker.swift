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
    let scheduler: Schedule
}

struct Schedule {
    let mon: Bool
    let tue: Bool
    let wed: Bool
    let thu: Bool
    let fri: Bool
    let sat: Bool
    let sun: Bool
}
