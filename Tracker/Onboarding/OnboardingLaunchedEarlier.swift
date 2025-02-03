//
//  OnboardingLaunchedEarlier.swift
//  Tracker
//
//  Created by Vitaly Lobov on 03.01.2025.
//

import Foundation

final class OnboardingLaunchedEarlier {
    
    private let key = "didAppStart"
    
    static let shared = OnboardingLaunchedEarlier()
    
    private init() {}
    
    private var flag: Bool? {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
    
    var didAppStart: Bool {
        get { flag ?? false }
        set { flag = newValue }
    }
}
