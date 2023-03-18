//
//  MeditationFeaturedCard.swift
//  Angel
//
//  Created by Thomas Giacinto on 18/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationFeaturedCard: View {
    
    // MARK: - PROPERTIES
    var featuredMeditation: Meditation
    
    let categories: [Category]
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Group {
                Text(featuredMeditation.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .foregroundColor(Color(DynamicColor(hexString: categories[0].color).darkened(amount: 0.2)))
                HStack(alignment: .center) {
                    Text("\(featuredMeditation.duration.toMinutes()) minutes")
                        .foregroundColor(Color(DynamicColor(hexString: categories[0].color).darkened(amount: 0.4)))
                    Text("•")
                        .foregroundColor(Color(DynamicColor(hexString: categories[0].color).darkened(amount: 0.5)))
                    Text(featuredMeditation.track)
                        .font(.footnote)
                        .foregroundColor(Color(DynamicColor(hexString: categories[0].color).darkened(amount: 0.5)))
                } //: HSTACK
                .font(.caption)
                .fontWeight(.medium)
                Text(featuredMeditation.caption)
                    .font(.footnote)
                    .foregroundColor(Color(DynamicColor(hexString: categories[0].color).darkened(amount: 0.5)))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 5)
        } //: VSTACK
        .padding()
        .frame(width: 350)
        .frame(minHeight: 150)
        .background(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color(DynamicColor(hexString: categories[0].color).saturated(amount: 0.4)).opacity(0.3), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(DynamicColor(hexString: categories[1].color).saturated(amount: 0.4)),
                        Color(DynamicColor(hexString: categories[0].color).saturated(amount: 0.5))
                        ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                    )
                )
            )
        )
    }
}

//struct MeditationFeaturedCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationFeaturedCard()
//    }
//}
