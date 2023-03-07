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
    @Persisted var name: String
    @Persisted var longName: String
    @Persisted var headline: List<String>
    @Persisted var color: String
    @Persisted var icon: String
    
    @Persisted var angelicPhrases: List<AngelicPhrase>
}
