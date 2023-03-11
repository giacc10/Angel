//
//  MeditationViewModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation

final class MeditationViewModel: ObservableObject {
    
    let durations: [TimeInterval] = [60, 600, 900, 1800, 2700, 3600]
    let tracks: [String] = ["Angelic Soprano", "Did You Know Angels Play Guitar?", "Solo Path", "For When It Rains", "Epic Era", "Calling Emotional Angelic Melodic", "Angelic Interlude"]
    
    private(set) var meditation: Meditation
    
    init (meditation: Meditation) {
        self.meditation = meditation
    }
    
    func createMeditation(title: String, caption: String, categories: [Category], duration: Int, track: String, type: Typology) {
        self.meditation = Meditation(value: ["date": Date(), "title": title, "caption": caption, "categories": categories, "duration": durations[duration], "track": track, "type": type])
    }
}
