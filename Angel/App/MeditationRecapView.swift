//
//  MeditationRecapView.swift
//  Angel
//
//  Created by Thomas Giacinto on 10/03/23.
//

import SwiftUI
import RealmSwift
import DynamicColor

struct MeditationRecapView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.realm) var realm
    
    @ObservedRealmObject var meditation: Meditation
    @State var meditationID: ObjectId = ObjectId()
    let categories: [Category]
    
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    let moods: [Mood] = [.same, .better, .good, .great, .blessed]
    @State var selectedMood: Mood? = nil
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            ParticleView()
            VStack {
                Text(String(localized: "Thank-You"))
                    .font(.title)
                    .fontWeight(.bold)
                    .textCase(.uppercase)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                Text(String(localized: "Meditation-Ended"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.1)))
                    .padding(.bottom)
                Text(String(localized: "Say-Thank-You"))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.1)))
                    .padding(.top)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(String(localized: "How-Do-You-Feel"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                    HStack {
                        
                        ForEach(moods, id: \.self) { mood in
                            MoodFace(emoji: emojiForMood(mood), mood: mood, color: mainCategory().color, selectedMood: $selectedMood)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.selectedMood == mood ? Color(DynamicColor(hexString: mainCategory().color).saturated(amount: 0.2)) : Color(DynamicColor(hexString: mainCategory().color).lighter(amount: 0.3))
                                        )
                                )
                                .onTapGesture {
                                    selectedMood = mood
//                                    $meditation.mood.wrappedValue = selectedMood
                                    updateMood(to: meditationID, with: selectedMood)
                                }
                            if mood != .blessed {
                                Spacer()
                            }
                        }
                        
                    } //: HSTACK
                } //: VSTACK
                .padding()
                .background(Color(DynamicColor(hexString: mainCategory().color).lighter(amount: 0.3)))
                .cornerRadius(25)
                .padding(.bottom, 50)
                
                ButtonCTA(text: String(localized: "Close-Meditation"),
                          color: mainCategory().color) {
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }
                
            } //: VSTACK
            .padding()
        } //: ZSTACK
        .onAppear {
            appendMeditation()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(DynamicColor(hexString: mainCategory().color).lighter()),
                Color(DynamicColor(hexString: mainCategory().color).saturated(amount: 0.5))
                ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
            ).ignoresSafeArea()
        )
        .navigationBarItems(
            trailing: Button(action: {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

extension MeditationRecapView {
    func mainCategory() -> Category {
        if let mainCategory = categories.first {
            return mainCategory
        } else {
            return Category()
        }
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
    
    func appendMeditation() {
        guard let user = realm.objects(User.self).where({ $0.id == 0 }).first else { return }
        try! realm.write {
            user.meditations.append(meditation)
        }
        meditationID = meditation.id
    }
    
    func updateMood(to meditationID: ObjectId, with mood: Mood?) {
//        try! realm.write {
//            meditation.setValue(mood, forKey: "mood")
//        }
        guard let med = realm.objects(Meditation.self).where({ $0.id == meditationID }).first else { return }
        let thawedMeditationRealm = med.thaw()!.realm!
        try! thawedMeditationRealm.write {
            med.mood = mood
            thawedMeditationRealm.create(Meditation.self, value: med, update: .modified)
        }
    }
}

//struct MeditationRecapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationRecapView(meditation:
//                                Meditation(value: ["title": "Lorem ipsum",
//                                                   "caption": "Dolor sit amet magnecuis sitness",
//                                                   "categories": [Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""])],
//                                                   "duration": 300,
//                                                   "track": "Angelic Soprano",
//                                                   "type": Typology.standard])
//                            )
//    }
//}
