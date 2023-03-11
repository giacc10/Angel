//
//  ButtonCTA.swift
//  Angel
//
//  Created by Thomas Giacinto on 11/03/23.
//

import SwiftUI
import DynamicColor

struct ButtonCTA: View {
    
    // MARK: - PROPERTIES
    var text: String
    var color: String
    var clicked: (() -> Void)
    
    // MARK: - BODY
    var body: some View {
        Button(action: clicked) {
            Text(text)
                .textCase(.uppercase)
                .fontWeight(.bold)
                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(DynamicColor(hexString: color).lighter(amount: 0.3)))
        )
    }
}

struct ButtonCTA_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCTA(text: "Start Peace Meditation", color: "#7FB3D5", clicked: {})
            .previewLayout(.sizeThatFits)
    }
}
