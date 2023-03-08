//
//  MeditationViewModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation

final class MeditationViewModel: ObservableObject {
    @Published private(set) var value: CGFloat = 0.0
    
    private(set) var meditation: Meditation
    
    init (meditation: Meditation) {
        self.meditation = meditation
    }
}
