//
//  ParticleViewModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 07/03/23.
//

import Foundation
import UIKit
import SwiftUI

class ParticleViewModel: ObservableObject {
    @Published var particles: [Particle] = []
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    init() {
        // Create 50 particles with random positions, colors, speeds and angles
        for _ in 0..<50 {
            let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
            let radius = CGFloat.random(in: 1...3)
            let color = Color.white.opacity(CGFloat.random(in: 0.3...0.8))
            let speed = CGFloat.random(in: 0.5...2.0)
            let angle = CGFloat.random(in: 0...360)
            particles.append(Particle(x: x, y: y, radius: radius, color: color, speed: speed, angle: angle))
        }
    }
    
    func updateParticles() {
        // Move particles based on their speed and angle
        for i in 0..<particles.count {
            particles[i].x += particles[i].speed * cos(particles[i].angle * CGFloat.pi / 180)
            particles[i].y += particles[i].speed * sin(particles[i].angle * CGFloat.pi / 180)
            
            // If particle goes off screen, reset its position
            if particles[i].x < -particles[i].radius ||
                particles[i].x > UIScreen.main.bounds.width + particles[i].radius ||
                particles[i].y < -particles[i].radius ||
                particles[i].y > UIScreen.main.bounds.height + particles[i].radius {
                particles[i].x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
                particles[i].y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
                particles[i].angle = CGFloat.random(in: 0...360)
            }
        }
    }
}
