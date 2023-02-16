//
//  AngelicPhraseModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import Foundation
import RealmSwift

class AngelicPhrase: Object, Identifiable {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var idProgressive: Int
    @Persisted var key: String
    @Persisted var premium: Bool
    
    @Persisted var categories = LinkingObjects(fromType: Category.self, property: "angelicPhrases")
}
