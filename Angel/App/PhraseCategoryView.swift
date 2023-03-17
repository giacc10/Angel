//
//  PhraseCategoryView.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import SwiftUI

struct PhraseCategoryView: View {
    
    // MARK: - PROPERTIES
    private(set) var category: Category
    
    // MARK: - BODY
    var body: some View {
        ZStack{
            List {
                ForEach(category.angelicPhrases, id: \.id) { phrase in
                    Text(LocalizedStringKey(phrase.key).stringValue())
                }
            } //: LIST
        } //: ZSTACK
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(category.name.localizedString())
//                        .customFont(size: 40)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
            }
        }
    }
}

struct PhraseCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        PhraseCategoryView(category: Category(value: []))
    }
}
