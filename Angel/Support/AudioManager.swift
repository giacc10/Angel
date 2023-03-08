//
//  AudioManager.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation
import AVKit

final class AudioManager: ObservableObject {
    var player: AVAudioPlayer?
    
    @Published private(set) var isLooping: Bool = false
    
    func startPlayer (track: String) {
        guard let url = Bundle.main.url(forResource: track, withExtension: "mp3") else {
            print("##: Resource not found: \(track)")
            return
        }
        
        do {
            // to enable audio when silent - Check if it silent the voiceover (.playback) has priority and close other
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("##: Failed to inizialize player", error)
        }
        
    }
    
    func playPause() {
        guard let player = player else {
            print("##: Instance of audio player not found")
            return
        }
        
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func stop() {
        guard let player = player else {
            print("##: Instance of audio player not found")
            return
        }
        
        if player.isPlaying {
            player.stop()
        }
    }
    
    func toggleLoop() {
        guard let player = player else {
            print("##: Instance of audio player not found")
            return
        }
        player.numberOfLoops = player.numberOfLoops == 0 ? -1: 0
        isLooping = player.numberOfLoops != 0
    }
        
}

