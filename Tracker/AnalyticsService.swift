//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Vitaly Lobov on 25.02.2025.
//

import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "aee475e9-f27a-4454-9790-a15998df70bd") else { return }
        AppMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
