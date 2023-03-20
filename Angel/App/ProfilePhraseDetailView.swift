//
//  ProfilePhraseDetailView.swift
//  Angel
//
//  Created by Thomas Giacinto on 20/03/23.
//

import SwiftUI
import AVFoundation
import RealmSwift
import DynamicColor

struct ProfilePhraseDetailView: View {
    
    //: MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @ObservedResults(AngelicPhrase.self) var allPhrases
    @ObservedRealmObject var phrase: AngelicPhrase
    let category: Category
    
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    let synthesizer = AVSpeechSynthesizer()
    
    //: MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [
                    Color(DynamicColor(hexString: category.color).tinted(amount: 0.7)),
                    Color(DynamicColor(hexString: category.color).saturated(amount: 0.7))]
                    ), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!)
                .ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Text(LocalizedStringKey(phrase.key))
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.6)))
                    
                    Spacer()
                    
                    HStack {
                        
                        Button {
                            dismiss()
                            $allPhrases.remove(phrase)
                        } label: {
                            Image(systemName: "heart.slash.fill")
                                .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.6)))
                                .padding()
                                .background(Circle().fill(Color(DynamicColor(hexString: category.color).darkened(amount: 0.3)).opacity(0.1)))
                        }
                        
                        Button {
                            speakPhrase()
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.6)))
                                .padding()
                                .background(Circle().fill(Color(DynamicColor(hexString: category.color).darkened(amount: 0.3)).opacity(0.1)))
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "arrowshape.turn.up.right.fill")
                                .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.6)))
                                .padding()
                                .background(Circle().fill(Color(DynamicColor(hexString: category.color).darkened(amount: 0.3)).opacity(0.1)))
                        }
                    } //: HSTACK
                    .padding(.bottom)
                    
                } //: VSTACK
                .padding()
                
            } //: ZSTACK
            .toolbar {
                ToolbarItem(placement: .principal) {
                    CategoryPill(category: category)
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                }
            )
        } //: NAVIGATIONVIEW
    }
}

extension ProfilePhraseDetailView {
    // MARK: - FUNCTIONS
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
        utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode())
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

//struct ProfilePhraseDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePhraseDetailView()
//    }
//}
