//
//  SoundtrackRow.swift
//  Angel
//
//  Created by Thomas Giacinto on 10/03/23.
//

import SwiftUI
import DynamicColor

struct SoundtrackRow: View {
    
    // MARK: - PROPERTIES
    @EnvironmentObject var audioPreviewManager: AudioManager
    var color: String
    var title: String
    @State var buttonPlaying: Bool = false
    
    // MARK: - BODY
    var body: some View {
        HStack {
            Button {
                audioPreviewManager.stop()
                if buttonPlaying == false {
                    audioPreviewManager.startPlayer(track: title)
                }
                if buttonPlaying == true {
                    audioPreviewManager.stop()
                }
                buttonPlaying.toggle()
            } label: {
                Image(systemName: buttonPlaying ? "stop.fill" : "play.fill")
                    .foregroundColor(Color(DynamicColor(hexString: color).lighter(amount: 0.3)))
            }
            .padding(10)
            .background(Circle().fill(Color(DynamicColor(hexString: color).saturated(amount: 0.2))))
            
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
            Spacer()
        } //: HSTACK
        .contentShape(Rectangle())
        .padding(5)        
    }
}

struct SoundtrackRow_Previews: PreviewProvider {
    static var previews: some View {
        SoundtrackRow(color: "#7FB3D5", title: "Angelic Song")
            .previewLayout(.sizeThatFits)
    }
}
