//
//  UserModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import Foundation
import RealmSwift

class User: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = 0
    @Persisted var name: String
    @Persisted var email: String
    @Persisted var image: Data?
    @Persisted var isSubscriptionActive: Bool = false
    
    @Persisted var favoritePhrases: List<AngelicPhrase>
    @Persisted var meditations: List<Meditation>
}
