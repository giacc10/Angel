//
//  MeditationView.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI
import Combine
import AVFoundation
import DynamicColor

struct MeditationView: View {
    
    // MARK: - PROPERTIES
    @StateObject var audioManager = AudioManager()
    var meditationViewModel: MeditationViewModel
    
    let synthesizer = AVSpeechSynthesizer()

    let category: Category
    @State var phraseIndex: Int = 0
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
        ZStack {
            ParticleView()
            VStack(spacing: 10) {
                
                Spacer()
                
                Text(isIntroduction ? "Let's start this \(category.name) meditation, close your eyes, relax and flow within" : category.angelicPhrases[phraseIndex].key)
                    .customFont(size: 60)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                    .padding()
                    .onAppear {
                        playIntroduction()
                    }
                    .onReceive(phraseTimer, perform: { _ in
                        loadAndSpeechPhrase()
                    })
                    .animation(.easeInOut)
                
                Spacer()

                ProgressBar(isPlaying: $isPlaying, duration: meditationViewModel.meditation.duration, color: category.color)
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
                            .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                    }
                    .padding(20)
                    .background(Circle().fill(Color(DynamicColor(hexString: category.color).lighter(amount: 0.3))))
                }
                
            } //: VSTACK
            .padding()
        } //: ZSTACK
        .navigationDestination(isPresented: $isMeditationRecapInStack) {
            MeditationRecapView()
        }
        .onReceive(meditationTimer, perform: { _ in
            guard let player = audioManager.player else { return }
            
            secondElapsed += 1
            if secondElapsed >= meditationViewModel.meditation.duration {
                player.stop()
                cancelTimer()
                isMeditationRecapInStack.toggle()
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                Color(DynamicColor(hexString: category.color).lighter()),
                Color(DynamicColor(hexString: category.color).saturated(amount: 0.5))
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
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

extension MeditationView {
    
    func instantiateTimer() {
        self.meditationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        self.phraseTimer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    }
    
    func cancelTimer() {
        self.meditationTimer.upstream.connect().cancel()
        self.phraseTimer.upstream.connect().cancel()
    }
    
    func loadAndSpeechPhrase() {
        phraseIndex = Int.random(in: 0...category.angelicPhrases.count - 1)
        let utterance = AVSpeechUtterance(string: category.angelicPhrases[phraseIndex].key)
        //                utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
    func playIntroduction() {
        let utterance = AVSpeechUtterance(string: "Let's start this \(category.name) meditation, close your eyes, relax and flow within")
        //                utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.pitchMultiplier = 1.2
        utterance.rate = 0.4
        synthesizer.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            isIntroduction = false
            instantiateTimer()
            audioManager.startPlayer(track: meditationViewModel.meditation.track)
            audioManager.toggleLoop()
        }
    }
}

struct MeditationView_Previews: PreviewProvider {
    static let meditationVM = MeditationViewModel (meditation: Meditation.data)
    
    static var previews: some View {
        MeditationView(meditationViewModel: meditationVM, category: Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""]))
    }
}
