//
//  PhraseCard.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import SwiftUI
import AVFoundation
import DynamicColor

struct PhraseCard: View {
    
    // MARK: - PROPERTIES
    let phrase: AngelicPhrase
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                ForEach(phrase.categories, id: \.self) { category in
                    CategoryPill(category: category)
                }
            } //: HSTACK
            .padding()
            
            Spacer()
            Text(LocalizedStringKey(phrase.key))
                .customFont(size: 60)
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


