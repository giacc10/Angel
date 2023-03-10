//
//  MeditationCategoryCard.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationCategoryCard: View {
    
    // MARK: - PROPERTIES
    let category: Category
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Group {
                Text(category.name.localizedString())
                    .font(.title3)
                    .textCase(.uppercase)
                    .fontWeight(.bold)
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                Spacer()
                Text(category.headline.randomElement()!)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.5)))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(5)
        } //: VSTACK
        .padding()
        .frame(width: 200, height: 220)
        .background(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color(DynamicColor(hexString: category.color).saturated(amount: 0.4)).opacity(0.3), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(DynamicColor(hexString: category.color).lighter()),
                        Color(DynamicColor(hexString: category.color).saturated(amount: 0.5))
                        ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                    )
                )
            )
        )
    }
}

struct MeditationCategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        MeditationCategoryCard(category: Category(value: ["name": "Peace", "color": "#7FB3D5", "icon": ""]))
    }
}
