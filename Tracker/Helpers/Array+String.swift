//
//  Array+String.swift
//  Tracker
//
//  Created by Vitaly Lobov on 04.02.2025.
//

import Foundation

extension Array where Element: RawRepresentable {
    func toJSONString() -> String? {
        let rawValues = self.map { $0.rawValue }
        if let jsonData = try? JSONSerialization.data(withJSONObject: rawValues, options: []) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

extension String {
    func toEnumArray<T: RawRepresentable>() -> [T] where T.RawValue == String {
        guard let data = self.data(using: .utf8),
              let rawValues = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else {
            return []
        }
        return rawValues.compactMap { T(rawValue: $0) }
    }
}




//let statuses: [TaskStatus] = [.todo, .inProgress]
//object.statuses = statuses.toJSONString()


//let retrievedStatuses: [TaskStatus] = object.statuses?.toEnumArray() ?? []
//print(retrievedStatuses) // [.todo, .inProgress]
