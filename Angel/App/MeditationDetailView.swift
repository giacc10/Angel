//
//  MeditationRecapView.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import SwiftUI
import DynamicColor

struct MeditationDetailView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @StateObject var meditationViewModel: MeditationViewModel
    
    let category: Category
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    @State var timerSelected: Int = 0
    @State var isMeditationViewInStack: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                ParticleView()
                VStack {
                    Text(category.longName)
                        .font(.title)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                    Text(category.headline.randomElement()!)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.1)))
                    Text(meditationViewModel.meditation.description)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.1)))
                        .padding(.top)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Choose meditation minutes:")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                        
                        CustomSegmentedPicker(items: meditationViewModel.durations, selection: $timerSelected, color: category.color)
                    }
                    .padding()
                    .background(Color(DynamicColor(hexString: category.color).lighter(amount: 0.3)))
                    .cornerRadius(25)
                    .padding(.bottom, 30)
                    
                    Button {
                        meditationViewModel.createMeditation(duration: timerSelected)
                        isMeditationViewInStack.toggle()
                    } label: {
                        Text("Start \(category.name.localizedString()) Meditation")
                            .textCase(.uppercase)
                            .fontWeight(.bold)
                            .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(DynamicColor(hexString: category.color).lighter(amount: 0.3)))
                    )
                    .navigationDestination(isPresented: $isMeditationViewInStack) {
                        MeditationView(meditationViewModel: meditationViewModel, category: category)
                    }
                    
                } //: VSTACK
                .padding()
            } //: ZSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(DynamicColor(hexString: category.color).lighter()),
                    Color(DynamicColor(hexString: category.color).saturated(amount: 0.5))
                    ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                ).ignoresSafeArea()
            )
            .navigationBarItems(
                trailing: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(DynamicColor(hexString: category.color).darkened(amount: 0.2)))
                }
            )
        } //: NAVIGATIONVIEW
    }
}

struct MeditationDetailView_Previews: PreviewProvider {
    static let meditationVM = MeditationViewModel (meditation: Meditation.data)
    
    static var previews: some View {
        MeditationDetailView(meditationViewModel: meditationVM, category: Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""]))
    }
}
