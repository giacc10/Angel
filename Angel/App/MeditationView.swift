//
//  MeditationView.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationView: View {
    
    // MARK: - PROPERTIES
    let category: Category
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Text("Hello, World!")
        } //: ZSTACK
        .navigationBarItems(
            trailing: Button(action: {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
            }
        )
    }
}

struct MeditationView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationView(category: Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""]))
    }
}
