//
//  ParticleView.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI

struct ParticleView: View {
    
    // MARK: - PROPERTIES
    @ObservedObject var viewModel = ParticleViewModel()
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            ForEach(viewModel.particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.radius * 2, height: particle.radius * 2)
                    .offset(x: particle.x, y: particle.y)
            }
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.updateParticles()
        }
    }
}

struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleView()
    }
}
