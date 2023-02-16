//
//  AppRealmManager.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import Foundation
import RealmSwift

class AppRealmManager: ObservableObject {
    
    // With private(set) we can only set this variable within the class RealmManager
    private(set) var localRealm: Realm?
    @Published private(set) var user: User?
    
    // Open Realm everytime the class is initialized
    init() {
        openRealm()
    }
    
    private func openRealm() {
        do {
            let config = Realm.Configuration(schemaVersion: 1)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
            print("##: Realm path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        } catch {
            print("##: Error opening Realm: \(error)")
        }
    }
    
    private func getUser() {
        if let localRealm = localRealm {
            if let userLocal = localRealm.object(ofType: User.self, forPrimaryKey: 0) {
                user = nil
                user = userLocal
            }
        }
    }
    
    func createUser(name: String) {
        if let localRealm = localRealm {
            do {
                try localRealm.write {
                    let user = User(value: ["name": name])
                    localRealm.add(user)
                    getUser()
                    print("##: Created new User to Realm: \(name)")
                }
            } catch {
                print("##: Error creating User to Realm: \(error)")
            }
        }
    }
}
