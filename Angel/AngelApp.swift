//
//  AngelApp.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI
import RealmSwift
import RevenueCat

@main
struct AngelApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, Realm.Configuration(schemaVersion: 1))
                .onAppear {
                    print("##: Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
                }
        }
    }
    
    init() {
        
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_PQNhYqBHIAhctWPcescscyZfoQY")
        
    }
}
