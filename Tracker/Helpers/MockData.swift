//
//  MockData.swift
//  Tracker
//
//  Created by Vitaly Lobov on 30.01.2025.
//

import Foundation

final class MockData {
    static var mockData: [TrackerCategory] = [
        TrackerCategory(
            name: "Мое время",
            trackers: [
                Tracker(id: UUID(),
                        name: "Спать",
                        color: .C_1,
                        emoji: "❤️",
                        scheduler: [.mon, .fri]),
            ]),
        TrackerCategory(
            name: "Не мое время",
            trackers: [
                Tracker(id: UUID(),
                        name: "Есть",
                        color: .C_2,
                        emoji: "😻",
                        scheduler: [.mon, .tue,]),
                Tracker(id: UUID(),
                        name: "Жрать",
                        color: .C_3,
                        emoji: "🌺",
                        scheduler: [.sat, .sun]),
                Tracker(id: UUID(),
                        name: "курить",
                        color: .C_4,
                        emoji: "❤️",
                        scheduler: [.sat]),
            ]),
        TrackerCategory(
            name: "Бестолковые занятия",
            trackers: [
                Tracker(id: UUID(),
                        name: "Курить",
                        color: .C_5,
                        emoji: "🙂",
                        scheduler: [.tue, .sun]),
                Tracker(id: UUID(),
                        name: "Пить",
                        color: .C_6,
                        emoji: "😪",
                        scheduler: []),
            ]),
    ]
}
