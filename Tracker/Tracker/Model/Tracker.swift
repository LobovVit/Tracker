//
//  Tracker.swift
//  Tracker
//
//  Created by Vitaly Lobov on 25.12.2024.
//
import SwiftUI

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let image: Image
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
