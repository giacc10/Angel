//
//  MeditationViewModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation

final class MeditationViewModel: ObservableObject {
    
    let durations: [TimeInterval] = [300, 600, 900, 1800, 2700, 3600]
    
    private(set) var meditation: Meditation
    
    init (meditation: Meditation) {
        self.meditation = meditation
    }
    
    func createMeditation(duration: Int) {
        self.meditation = Meditation(title: "", description: "", categories: [], duration: durations[duration], track: "angelic-soprano")
    }
}
