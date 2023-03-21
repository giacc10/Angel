//
//  MeditationRow.swift
//  Angel
//
//  Created by Thomas Giacinto on 21/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationRow: View {
    
    //MARK: - PROPERTIES
    let meditation: Meditation
    let categories: [Category]
    
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    //MARK: - BODY
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(meditation.date.toString())
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 1).color).darkened(amount: 0.3)))
                    .padding(.bottom, 0)
                Text(categories.count == 1 ?
                     returnCategory(index: 0).name.localizedString() :
                        returnCategory(index: 0).name.localizedString() + " & " + returnCategory(index: 1).name.localizedString()
                )
                .font(.title3)
                .fontWeight(.bold)
                .textCase(.uppercase)
                .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 1).color).darkened(amount: 0.2)))
                HStack {
                    Text(String(localized: "Minutes \(meditation.duration.toMinutes())"))
                    Text("•")
                    Text(meditation.track)
                        .lineLimit(1)
                    Spacer()
                } //: HSTACK
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 1).color).darkened(amount: 0.4)))
            } //: VSTACK
            Divider()
            HStack(alignment: .bottom, spacing: 3) {
                Text(LocalizedStringKey(meditation.type.rawValue))
                    .font(.footnote)
                    .fontWeight(.medium)
                Spacer()
                if let mood = meditation.mood {
                    Text(String(localized: "You-Felt") + ":")
                        .font(.footnote)
                    Text(mood.localizedString() + " " + emojiForMood(mood))
                        .fontWeight(.medium)
                }
            } //: HSTACK
            .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 0).color).darkened(amount: 0.4)))
        } //: VSTACK
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color(DynamicColor(hexString: returnCategory(index: 0).color).saturated(amount: 0.4)).opacity(0.3), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        categories.count == 1 ? Color(DynamicColor(hexString: returnCategory(index: 0).color).lighter()) : Color(DynamicColor(hexString: returnCategory(index: 1).color).saturated(amount: 0.4)),
                        Color(DynamicColor(hexString: returnCategory(index: 0).color).saturated(amount: 0.5))
                    ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                    )
                )
            )
        )
    }
}

extension MeditationRow {
    // MARK: - FUNCTIONS
    func returnCategory(index: Int) -> Category {
        if index == 0 {
            if let category = categories.first {
                return category
            }
        }
        if index == 1 {
            if categories.indices.contains(index) {
                return categories[index]
            } else {
                return categories[0]
            }
        }
        return Category()
    }
    
    func emojiForMood(_ mood: Mood) -> String {
        switch mood {
        case .same:
            return "😕"
        case .better:
            return "🙂"
        case .good:
            return "😌"
        case .great:
            return "😁"
        case .blessed:
            return "🤩"
        }
    }
}

//struct MeditationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationRow(meditation:
//                        Meditation(value: ["title": "Lorem ipsum",
//                                            "caption": "Dolor sit amet magnecuis sitness",
//                                            "categories": [Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""])],
//                                            "duration": 300,
//                                            "track": "Angelic Soprano",
//                                            "type": Typology.standard])
//                        )
//            .previewLayout(.sizeThatFits)
//    }
//}
