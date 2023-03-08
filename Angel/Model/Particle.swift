//
//  Particle.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import Foundation
import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var color: Color
    var speed: CGFloat
    var angle: CGFloat
}
