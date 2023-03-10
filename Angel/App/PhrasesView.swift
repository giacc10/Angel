//
//  PhrasesView.swift
//  Angel
//
//  Created by Thomas Giacinto on 16/02/23.
//

import SwiftUI

struct PhrasesView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack{
                List {
                    ForEach(phrasesRealmManager.categories, id: \.id) { category in
                        NavigationLink(destination: PhraseCategoryView(category: category)) {
                            Text(category.name.localizedString())
                        }
                    }
                } //: LIST
            } //: ZSTACK
            .onAppear {
                phrasesRealmManager.getCategories()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Phrases")
                            .customFont(size: 40)
//                            .textCase(.uppercase)
                    }
                }
            }
        } //: NAVIGATIONVIEW
    }
}

struct PhrasesView_Previews: PreviewProvider {
    static var previews: some View {
        PhrasesView()
    }
}
