//
//  CategoryPill.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import SwiftUI
import DynamicColor

struct CategoryPill: View {
    
    // MARK: - PROPERTIES
    let category: Category
    
    // MARK: - BODY
    var body: some View {
        Text(category.name.localizedString())
            .font(.caption)
            .textCase(.uppercase)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.vertical, 5)
            .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.5)))
            .background(Capsule()
                .fill(Color(DynamicColor(hexString: category.color).saturated()))
            )
    }
}

struct CategoryPill_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPill(category: Category(value: ["name": "Peace", "color": "#7FB3D5", "icon": ""]))
    }
}
