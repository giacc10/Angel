//
//  MeditationModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation
import RealmSwift

class Meditation: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: Date
    @Persisted var title: String
    @Persisted var caption: String
    @Persisted var categories: List<Category>
    @Persisted var duration: TimeInterval
    @Persisted var track: String
    @Persisted var type: Typology
}

enum Typology: String, PersistableEnum, CaseIterable {
    case standard = "Standard"
    case featured = "Featured"
    case ofTheDay = "Of The Day"
}
