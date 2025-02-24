//
//  UIColor+Data.swift
//  Tracker
//
//  Created by Vitaly Lobov on 04.02.2025.
//

import UIKit

extension UIColor {
    
    func toData() -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    static func from(data: Data?) -> UIColor? {
        guard let data = data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
    }
    
}

extension UIColor {
    static let backgroundColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? .black : .white
    }
    
    static let textColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    static let searchBarColor = UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .dark ? .darkGray : .lightGray
    }
}
