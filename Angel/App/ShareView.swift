//
//  ShareView.swift
//  Angel
//
//  Created by Thomas Giacinto on 25/03/23.
//

import SwiftUI
import DynamicColor

struct ShareView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.displayScale) var displayScale
    
    let phrase: AngelicPhrase
    let category: Category
    
    @State private var renderedImage = Image(systemName: "photo")
    var myView: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(DynamicColor(hexString: category.color).tinted(amount: 0.7)),
                Color(DynamicColor(hexString: category.color).saturated(amount: 0.7))]
                                             ), startPoint: .top, endPoint: .bottom)
            VStack {
                Spacer()
                CategoryPill(category: category)
                    .padding(.bottom)
                Text(LocalizedStringKey(phrase.key).stringValue())
                    .font(.system(size: 35))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.6)))
                    .padding()
                Spacer()
                Text("\(AppData.appName) - \(AppData.appHeadline)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.3)))
                    .padding(.bottom)
            }
        }
        .frame(width: 500, height: 600)
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 50)
                .fill(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                .frame(width: 45, height: 5)
                .padding()
            VStack(spacing: 7) {
                ShareLink(item: renderedImage, preview: SharePreview(Text(String(localized: "Shared-Phrase \(category.name.localizedString())")), image: renderedImage))
                    .font(.title)
                    .labelStyle(.iconOnly)
                    .symbolVariant(.fill)
                Text(String(localized: "Share"))
                    .font(.caption2)
            } //: VSTACK
            .padding(.bottom)
        } //: VSTACK
        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
        .onAppear { render() }
    }
}

extension ShareView {
    @MainActor func render() {
        let renderer = ImageRenderer(content: myView)

        // make sure and use the correct display scale for this device
        renderer.scale = displayScale

        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        }
    }
}

//struct ShareView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShareView()
//    }
//}
