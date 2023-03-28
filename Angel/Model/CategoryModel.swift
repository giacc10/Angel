//
//  CategoryModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import Foundation
import RealmSwift

class Category: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var idProgressive: Int
    @Persisted var name: CategoryName
    @Persisted var longName: String
    @Persisted var headline: List<String>
    @Persisted var headlineShort: List<String>
    @Persisted var color: String
    @Persisted var icon: String
    
    @Persisted var angelicPhrases: List<AngelicPhrase>
}

enum CategoryName: String, PersistableEnum, CaseIterable {
    case peace          = "Peace"
    case hope           = "Hope"
    case blessing       = "Blessing"
    case forgiveness    = "Forgiveness"
    case adundance      = "Abundance"
    case courage        = "Courage"
    case joy            = "Joy"
    case protection     = "Protection"
    case transformation = "Transformation"
    case selfcare       = "Self-Care"
    case relationships  = "Relationships"
    case success        = "Success"
    case confidence     = "Confidence"
    case gratitude      = "Gratitude"
    case healing        = "Healing"
    case kindness       = "Kindness"
    case faith          = "Faith"
    case serenity       = "Serenity"
    case fear           = "Fear"
    case patience       = "Patience"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
