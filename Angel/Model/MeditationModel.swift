//
//  MeditationModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation

struct Meditation {
    let id = UUID()
    let title: String
    let description: String
    let categories: [Category]
    let duration: TimeInterval
    let track: String
    
    static let data = Meditation(title: "1 Minute Relaxing Meditation", description: "Clear your mind and slumber into nothingness. Allocate only a few moments for a quick breather.", categories: [Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""])], duration: 204, track: "angelic-soprano")
}
