//
//  FeatureLabel.swift
//  Angel
//
//  Created by Thomas Giacinto on 22/03/23.
//

import SwiftUI

struct FeatureLabel: View {
    
    //MARK: - PROPERTIES
    private(set) var isDone: Bool
    private(set) var headline: String
    private(set) var caption: String
    
    //MARK: - BODY
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: isDone ? "checkmark.circle.fill" : "checkmark.circle")
                .font(.title3)
            VStack(alignment: .leading) {
                Text(headline)
                    .font(.title3)
                    .fontWeight(.medium)
                Text(caption)
                    .font(.caption)
            }
        }
    }
}

struct FeatureLabel_Previews: PreviewProvider {
    static var previews: some View {
        FeatureLabel(isDone: false, headline: "Unlimited categories", caption: "Lorem ipsum dolor sit amet")
            .previewLayout(.sizeThatFits)
    }
}
