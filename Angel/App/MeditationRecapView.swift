//
//  MeditationRecapView.swift
//  Angel
//
//  Created by Thomas Giacinto on 10/03/23.
//

import SwiftUI

struct MeditationRecapView: View {
    var body: some View {
        VStack {
            Text("Metitation Ended")
        }
        .navigationBarItems(
            trailing: Button(action: {
                UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
            }) {
                Image(systemName: "xmark")
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

struct MeditationRecapView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationRecapView()
    }
}
