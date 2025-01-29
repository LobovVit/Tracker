//
//  Clolors+Icons.swift
//  Tracker
//
//  Created by Vitaly Lobov on 29.01.2025.
//

import UIKit

struct Section {
    let title: String
    let items: [Item]
}

struct Item {
    let name: String
    let color: UIColor?
    let icon: String?
}

let sections: [Section] = [
    Section(
        title: "Emoji",
        items: [ Item(name: "Emoji-1", color: nil, icon: "🙂"),
                 Item(name: "Emoji-2", color: nil, icon: "😻"),
                 Item(name: "Emoji-3", color: nil, icon: "🌺"),
                 Item(name: "Emoji-4", color: nil, icon: "🐶"),
                 Item(name: "Emoji-5", color: nil, icon: "❤️"),
                 Item(name: "Emoji-6", color: nil, icon: "😱"),
                 Item(name: "Emoji-7", color: nil, icon: "😇"),
                 Item(name: "Emoji-8", color: nil, icon: "😡"),
                 Item(name: "Emoji-9", color: nil, icon: "🥶"),
                 Item(name: "Emoji-10", color: nil, icon: "🤔"),
                 Item(name: "Emoji-11", color: nil, icon: "🙌"),
                 Item(name: "Emoji-12", color: nil, icon: "🍔"),
                 Item(name: "Emoji-13", color: nil, icon: "🥦"),
                 Item(name: "Emoji-14", color: nil, icon: "🏓"),
                 Item(name: "Emoji-15", color: nil, icon: "🥇"),
                 Item(name: "Emoji-16", color: nil, icon: "🎸"),
                 Item(name: "Emoji-17", color: nil, icon: "🏝"),
                 Item(name: "Emoji-18", color: nil, icon: "😪")]
    ),
    Section(
        title: "Цвет",
        items: [Item(name: "Color-1", color: UIColor(named: "C1"), icon: nil),
                Item(name: "Color-2", color: UIColor(named: "C2"), icon: nil),
                Item(name: "Color-3", color: UIColor(named: "C3"), icon: nil),
                Item(name: "Color-4", color: UIColor(named: "C4"), icon: nil),
                Item(name: "Color-5", color: UIColor(named: "C5"), icon: nil),
                Item(name: "Color-6", color: UIColor(named: "C6"), icon: nil),
                Item(name: "Color-7", color: UIColor(named: "C7"), icon: nil),
                Item(name: "Color-8", color: UIColor(named: "C8"), icon: nil),
                Item(name: "Color-9", color: UIColor(named: "C9"), icon: nil),
                Item(name: "Color-10", color: UIColor(named: "C10"), icon: nil),
                Item(name: "Color-11", color: UIColor(named: "C11"), icon: nil),
                Item(name: "Color-12", color: UIColor(named: "C12"), icon: nil),
                Item(name: "Color-13", color: UIColor(named: "C13"), icon: nil),
                Item(name: "Color-14", color: UIColor(named: "C14"), icon: nil),
                Item(name: "Color-15", color: UIColor(named: "C15"), icon: nil),
                Item(name: "Color-16", color: UIColor(named: "C16"), icon: nil),
                Item(name: "Color-17", color: UIColor(named: "C17"), icon: nil),
                Item(name: "Color-18", color: UIColor(named: "C18"), icon: nil)]
    )
]

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0
        )
    }
}
