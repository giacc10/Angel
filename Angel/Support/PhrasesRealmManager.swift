//
//  PhrasesRealmManager.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import Foundation
import RealmSwift

class PhrasesRealmManager: ObservableObject {
    
    // With private(set) we can only set this variable within the class RealmManager
    private(set) var localRealm: Realm?
    @Published private(set) var categories: [Category] = []
    @Published private(set) var angelicPhrases: [AngelicPhrase] = []
    
    // Open Realm everytime the class is initialized
    init() {
        openRealm()
        getCategories()
        getAngelicPhrases()
    }
    
    private func openRealm() {
        do {
            let realmPath = Bundle.main.url(forResource: "phrases", withExtension: "realm")!
            
            // Configure to read only as file located in Bundle is not writeable
            let config = Realm.Configuration(fileURL: realmPath, readOnly: true, schemaVersion: 1)
            
            localRealm = try Realm(configuration: config)
            print("##: Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch {
            print("##: Error opening Realm: \(error)")
        }
    }
    
    func getCategories() {
        if let localRealm = localRealm {
            let allCategories = localRealm.objects(Category.self)
            categories.removeAll()
            allCategories.forEach { category in
                categories.append(category)
            }
        }
    }
    
    func getAngelicPhrases() {
        if let localRealm = localRealm {
            let allPhrases = localRealm.objects(AngelicPhrase.self)
            angelicPhrases.removeAll()
            allPhrases.forEach { phrase in
                angelicPhrases.append(phrase)
            }
        }
    }
    
}
