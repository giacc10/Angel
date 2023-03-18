//
//  MeditationView.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI
import AVFoundation
import RealmSwift
import DynamicColor

struct MeditationView: View {
    
    // MARK: - PROPERTIES
    @StateObject var audioManager = AudioManager()
//    var meditationViewModel: MeditationViewModel
    
    let synthesizer = AVSpeechSynthesizer()
    
    var meditation: Meditation
    let categories: [Category]
    @State var phrase: String = ""
    @State var isIntroduction: Bool = true
    @State var isPlaying: Bool = true
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    // Timer for the meditation
    @State var secondElapsed: TimeInterval = 0
    @State var meditationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Timer for phrases
    @State var phraseTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    
    @State var isMeditationRecapInStack: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            
            ZStack {
                ParticleView()
                VStack(spacing: 10) {
                    
                    Spacer()
                    
                    Text(isIntroduction ? LocalizedStringKey("Start-Meditation-Speech") : LocalizedStringKey(phrase))
                    //                    .customFont(size: 40)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 0).color).darkened(amount: 0.2)))
                        .padding()
                        .onAppear {
                            playIntroduction()
                        }
                        .onReceive(phraseTimer, perform: { _ in
                            loadAndSpeechPhrase()
                        })
                        .animation(.easeInOut)
                    
                    Spacer()
                    
                    ProgressBar(isPlaying: $isPlaying, duration: meditation.duration, color: returnCategory(index: 0).color)
                        .environmentObject(audioManager)
                    
                    if let player = audioManager.player {
                        Button {
                            if player.isPlaying {
                                cancelTimer()
                            } else {
                                instantiateTimer()
                            }
                            audioManager.playPause()
                            isPlaying.toggle() // Because player.isPlaying not working
                        } label: {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 0).color).darkened(amount: 0.2)))
                        }
                        .padding(20)
                        .background(Circle().fill(Color(DynamicColor(hexString: returnCategory(index: 0).color).lighter(amount: 0.3))))
                    }
                    
                } //: VSTACK
                .padding()
            } //: ZSTACK
            .navigationDestination(isPresented: $isMeditationRecapInStack) {
                MeditationRecapView(meditation: meditation, categories: categories)
            }
            .onReceive(meditationTimer, perform: { _ in
                guard let player = audioManager.player else { return }
                
                secondElapsed += 1
                if secondElapsed >= meditation.duration {
                    player.stop()
                    cancelTimer()
                    isMeditationRecapInStack.toggle()
                    sayThankYou()
                }
                // Stop reading phrases little bit before ending
                if meditation.duration - secondElapsed == 20 {
                    phraseTimer.upstream.connect().cancel()
                    player.setVolume(0, fadeDuration: 18)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    categories.count == 1 ? Color(DynamicColor(hexString: returnCategory(index: 0).color).lighter()) : Color(DynamicColor(hexString: returnCategory(index: 1).color).saturated(amount: 0.4)),
                    Color(DynamicColor(hexString: returnCategory(index: 0).color).saturated(amount: 0.5))
                ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                ).ignoresSafeArea()
            )
            .navigationBarItems(
                trailing: Button(action: {
                    cancelTimer()
                    audioManager.stop()
                    UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(DynamicColor(hexString: returnCategory(index: 0).color).darkened(amount: 0.2)))
                }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}

extension MeditationView {
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
    
    func instantiateTimer() {
        self.meditationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.phraseTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    }
    
    func cancelTimer() {
        self.meditationTimer.upstream.connect().cancel()
        self.phraseTimer.upstream.connect().cancel()
    }
    
    func getLanguageCode() -> String {
        switch Locale.current.language.languageCode?.identifier {
        case "it":
            return "it-IT"
        default:
            return "en-US"
        }
    }
    
    func loadAndSpeechPhrase() {
        if categories.count == 1 {
            let phraseIndex = Int.random(in: 0...returnCategory(index: 0).angelicPhrases.count - 1)
            phrase = returnCategory(index: 0).angelicPhrases[phraseIndex].key
            
        }
        if categories.count == 2 {
            let randomCategory = categories.randomElement()!
            let phraseIndex = Int.random(in: 0...randomCategory.angelicPhrases.count - 1)
            phrase = randomCategory.angelicPhrases[phraseIndex].key
            
        }
        let utterance = AVSpeechUtterance(string: LocalizedStringKey(phrase).stringValue())
        utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode())
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func playIntroduction() {
        let utterance = AVSpeechUtterance(string: LocalizedStringKey("Start-Meditation-Speech").stringValue())
        //                utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first)
        utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode())
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            isIntroduction = false
            instantiateTimer()
            audioManager.startPlayer(track: meditation.track)
            audioManager.toggleLoop()
        }
    }
    
    func sayThankYou() {
        let utterance = AVSpeechUtterance(string: LocalizedStringKey("Thank-You-Meditation-Speech").stringValue())
        //                utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first)
        utterance.voice = AVSpeechSynthesisVoice(language: getLanguageCode())
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

//struct MeditationView_Previews: PreviewProvider {
//    static let meditationVM = MeditationViewModel (meditation: Meditation.data)
//    
//    static var previews: some View {
//        MeditationView(meditationViewModel: meditationVM, category: Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""]))
//    }
//}
