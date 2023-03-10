//
//  ProgressBar.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI
import DynamicColor

struct ProgressBar: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var audioManager: AudioManager
    @State var value: CGFloat = 0.0
    var duration: TimeInterval
    var color: String

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    // MARK: - BODY
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                
                Rectangle()
                    .fill(Color(DynamicColor(hexString: color).lighter(amount: 0.3)))
                    .frame(height: 7)
                
                Rectangle()
                    .fill(Color(DynamicColor(hexString: color).darkened(amount: 0.1)))
                    .frame(width: calcPercentage(value: value, duration: duration), height: 7)
                
            } //: ZTACK
            .cornerRadius(10)
            
            if let player = audioManager.player {
                HStack {
                    Text(DateComponentsFormatter.positional.string(from: player.currentTime) ?? "0.00")
                    Spacer()
                    Text(DateComponentsFormatter.positional.string(from: duration - player.currentTime) ?? "0:00")
                }
                .font(.caption)
                .foregroundColor(.white)
            }
            
        } //: VSTACK
        .onReceive(timer, perform: { _ in
            guard let player = audioManager.player else { return }
            value = player.currentTime
        })
    }
}

//MARK: - FUNCTIONS
extension ProgressBar {
    func calcPercentage(value: CGFloat, duration: TimeInterval) -> CGFloat {
        let width = UIScreen.main.bounds.width - 38 // PaddingX
        return width * (value/duration)
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: 5.50, duration: 70, color: "#7FB3D5")
    }
}
