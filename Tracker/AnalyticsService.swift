//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Наринэ  Овсепян on 16.08.2026.
//
import Foundation
import AppMetricaCore

struct AnalyticsService {
    static func activate() {
        guard let configuration = AppMetricaConfiguration(apiKey: "322d109b-550a-4a77-813c-ee65e320327a") else { return }

        AppMetrica.activate(with: configuration)
    }

    func report(event: String, params : [AnyHashable : Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
