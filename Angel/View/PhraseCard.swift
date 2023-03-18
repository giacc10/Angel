//
//  PhraseCard.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import SwiftUI
import RealmSwift
import AVFoundation
import DynamicColor

struct PhraseCard: View {
    
    // MARK: - PROPERTIES
    @Environment(\.realm) var realm
    @ObservedResults(AngelicPhrase.self) var allPhrases
    
    
    let phrase: AngelicPhrase
    @State var isFavorite: Bool = false
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - BODY
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                HStack {
                    ForEach(phrase.categories, id: \.self) { category in
                        CategoryPill(category: category)
                    }
                } //: HSTACK
                .padding()
                
                Spacer()
                Text(LocalizedStringKey(phrase.key))
                //                .customFont(size: 40)
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(DynamicColor(hexString: phrase.categories.first!.color).darkened(amount: 0.6)))
                    .padding()
                
                Spacer()
                
                Button {
                    speakPhrase()
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundColor(Color(DynamicColor(hexString: phrase.categories.first!.color).darkened(amount: 0.6)))
                        .padding()
                        .background(Circle().fill(Color(DynamicColor(hexString: phrase.categories.first!.color).darkened(amount: 0.3)).opacity(0.1)))
                }
                .padding(.bottom)
                .onAppear {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        print("Fail to enable session")
                    }
                }
                
            } //: VSTACK
            
            // MARK: - Sidebar Actions
            HStack {
                Spacer()
                VStack(spacing: 25) {
                    Spacer()
                    Button {
                            addToFavorites()
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: "heart.fill")
                                .font(.title)
                            Text(String(localized: "Like"))
                                .font(.caption2)
                        }
                        .foregroundColor(allPhrases.contains(where: { $0.idProgressive == phrase.idProgressive }) ? .red : Color(DynamicColor(hexString: phrase.categories.first!.color).darkened(amount: 0.5)))
                    }
                    
                    Button {
                        
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .font(.title)
                            Text(String(localized: "Share"))
                                .font(.caption2)
                        }
                        .foregroundColor(Color(DynamicColor(hexString: phrase.categories.first!.color).darkened(amount: 0.5)))
                    }
                } //: VSTACK
                .padding(.bottom, 20)
                .padding(.trailing, 20)
            } //: HSTACK
            
        } //: ZSTACK
        .background(RoundedRectangle(cornerRadius: 12)
            .strokeBorder(Color(DynamicColor(hexString: phrase.categories.first!.color).saturated(amount: 0.4)).opacity(0.3), lineWidth: 1)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(gradient: Gradient(colors: [
                        Color(DynamicColor(hexString: phrase.categories.first!.color).tinted(amount: 0.7)),
                        Color(DynamicColor(hexString: phrase.categories.first!.color).saturated(amount: 0.7))]
                    ), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!)
                )
            )
        )
        .padding(10)
    }
}

extension PhraseCard {
    func getLanguageCode() -> String {
        switch Locale.current.language.languageCode?.identifier {
        case "it":
            return "it-IT"
        default:
            return "en-US"
        }
    }
    
    func speakPhrase() {
        let utterance = AVSpeechUtterance(string: LocalizedStringKey(phrase.key).stringValue())
//        utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first)
        utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode())
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func addToFavorites() {
        guard let user = realm.objects(User.self).where({ $0.id == 0 }).first else { return }
        
        if !user.favoritePhrases.contains(where: { $0.idProgressive == phrase.idProgressive }) {
            let thawedUserRealm = user.thaw()!.realm!
            try! thawedUserRealm.write {
                let phraseToAppend = thawedUserRealm.create(AngelicPhrase.self, value: phrase, update: .modified)
                user.favoritePhrases.append(phraseToAppend)
            }
        } else {
            // TODO: - Remove from favorites and from Realm
            
        }
    }
}

//struct PhraseCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PhraseCard(phrase: AngelicPhrase(value: ["idProgressive": 1,
//                                                 "key": "Lorem ipsum dolor",
//                                                 "premium": false,
//                                                 "categories": [Category(value: ["name": "Peace", "color": "#7FB3D5", "icon": ""])]
//                                                ]))
//    }
//}


