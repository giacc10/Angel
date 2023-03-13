//
//  MeditationsStorageModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 13/03/23.
//

import Foundation
import RealmSwift

class MeditationsStorage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id = 0
    
    @Persisted var todaysMeditation: Meditation?
    @Persisted var featuredMeditations: List<Meditation>
}
