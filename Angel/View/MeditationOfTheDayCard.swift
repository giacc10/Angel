//
//  MeditationOfTheDayCard.swift
//  Angel
//
//  Created by Thomas Giacinto on 13/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationOfTheDayCard: View {
    
    // MARK: - PROPERTIES
    var meditationViewModel: MeditationViewModel
    
    let categories: [Category]
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    @State var isMeditationViewInStack: Bool = false
    
    // MARK: - BODY
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(meditationViewModel.meditationOfTheDay.title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.2)))
                    HStack(alignment: .center) {
                        Text("\(meditationViewModel.meditationOfTheDay.duration.toMinutes()) minutes")
                            .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.4)))
                        Text("•")
                            .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.5)))
                        Text(meditationViewModel.meditationOfTheDay.track)
                            .lineLimit(1)
                            .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.4)))
                    } //: HSTACK
                    .font(.caption)
                    .fontWeight(.medium)
                } //: VSTACK
                Text(meditationViewModel.meditationOfTheDay.caption)
                    .font(.footnote)
                    .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.5)))
            } //: VSTACK
            .padding(5)
            Spacer()
            Button {
                isMeditationViewInStack.toggle()
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color(DynamicColor(hexString: categories.first!.color).lighter(amount: 0.3)))
            }
            .padding()
            .background(Circle().fill(Color(DynamicColor(hexString: categories.first!.color).darkened(amount: 0.2))))
            .fullScreenCover(isPresented: $isMeditationViewInStack) {
                MeditationView(meditationViewModel: meditationViewModel, categories: categories)
            }
        } //: HSTACK
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color(DynamicColor(hexString: categories.first!.color).saturated(amount: 0.4)).opacity(0.3), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(DynamicColor(hexString: categories.first!.color).lighter(amount: 0.1)),
                        Color(DynamicColor(hexString: categories.first!.color).saturated(amount: 0.5))
                        ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                    )
                )
            )
        )
    }
}

extension MeditationOfTheDayCard {
    
}

//struct MeditationOfTheDayCard_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationOfTheDayCard(meditation: Meditation(value: ["title": "Find Peace", "caption": "Open your mind with a meditation for your mind", "categories": "Peace", "duration": 300, "track": "Calling Emotional Angelic Melodic", "type": Typology.ofTheDay]), categories: [Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""])])
//            .previewLayout(.sizeThatFits)
//    }
//}
