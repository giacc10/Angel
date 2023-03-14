//
//  MoodFace.swift
//  Angel
//
//  Created by Thomas Giacinto on 11/03/23.
//

import SwiftUI
import DynamicColor

struct MoodFace: View {
    
    // MARK: - PROPERTIES
    var emoji: String
    var mood: Mood
    var color: String
    @Binding var selectedMood: Mood?
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text(emoji)
                .font(.system(size: 45))
            Text(mood.localizedString())
                .font(.system(size: 9))
                .fontWeight(.medium)
                .foregroundColor(selectedMood == mood ? Color(DynamicColor(hexString: color).lighter(amount: 0.3)) : Color(DynamicColor(hexString: color).darkened(amount: 0.1)))
        } //: VSTACK
        .padding(.horizontal, 5)
        .padding(.bottom, 5)
    }
}

struct MoodFace_Previews: PreviewProvider {
    static var previews: some View {
        MoodFace(emoji: "😌", mood: Mood(rawValue: "Good") ?? .good, color: "#7FB3D5", selectedMood: .constant(.good))
    }
}
