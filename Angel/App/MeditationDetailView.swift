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
    @StateObject var audioPreviewManager = AudioManager()
    var meditationViewModel: MeditationViewModel
    
    let categories: [Category]
    @State var meditation = Meditation()
    
    let topUnitPoint: [UnitPoint] = [.top, .topLeading, .topTrailing]
    let bottomUnitPoint: [UnitPoint] = [.bottom, .bottomLeading, .bottomTrailing]
    
    @State var selectedTimer: Int = 0
    @State var selectedSoundtrack: String? = nil
    @State var isMeditationViewInStack: Bool = false
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                ParticleView()
                VStack {
                    Text(mainCategory().longName)
                        .font(.title)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                    Text(mainCategory().headline.randomElement()!)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.1)))
                    Text(meditation.caption)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.1)))
                        .padding(.top)
                    
                    Spacer()
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "Choose-Meditation-Soundtrack"))
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                            
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(meditationViewModel.tracks, id: \.self) { track in
                                        SoundtrackRow(color: mainCategory().color, title: track, selectedSoundtrack: $selectedSoundtrack)
                                            .environmentObject(audioPreviewManager)
                                            .onTapGesture {
                                                selectedSoundtrack = track
                                            }
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(selectedSoundtrack == track ?
                                                          Color(DynamicColor(hexString: mainCategory().color).saturated(amount: 0.2)) :
                                                            Color(DynamicColor(hexString: mainCategory().color).tinted(amount: 0.7))
                                                         )
                                            )
                                            .padding(.horizontal, 7)
                                            .padding(.bottom, 2)
                                    }
                                } //: VSTACK
                                .padding(.vertical, 7)
                            } //: SCROLLVIEW
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(DynamicColor(hexString: mainCategory().color).tinted(amount: 0.7)))
                            )
                            .frame(maxHeight: 170)
                            
                        } //: VSTACK
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(String(localized: "Choose-Meditation-Minutes"))
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                            
                            CustomSegmentedPicker(items: meditationViewModel.durations, selection: $selectedTimer, color: mainCategory().color)
                        } //: VSTACK
                    } //: VSTACK
                    .padding()
                    .background(Color(DynamicColor(hexString: mainCategory().color).lighter(amount: 0.3)))
                    .cornerRadius(25)
                    .padding(.bottom, 50)
                    
                    ButtonCTA(text: String(localized: "Start-Meditation \(mainCategory().name.localizedString())"),
                              color: mainCategory().color) {
                        audioPreviewManager.stop()
                        meditationViewModel.createMeditation(title: "", caption: "", categories: categories, duration: selectedTimer, track: selectedSoundtrack ?? "A Meditation", type: .standard)
//                        meditation = meditationViewModel.createMeditation(title: "", caption: "", categories: categories, duration: selectedTimer, track: selectedSoundtrack ?? "Angelic Soprano", type: .standard)
                        isMeditationViewInStack.toggle()
                    }
                    .navigationDestination(isPresented: $isMeditationViewInStack) {
                        MeditationView(meditationViewModel: meditationViewModel)
                    }
                    
                } //: VSTACK
                .padding()
            } //: ZSTACK
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(DynamicColor(hexString: mainCategory().color).lighter()),
                    Color(DynamicColor(hexString: mainCategory().color).saturated(amount: 0.5))
                    ]), startPoint: topUnitPoint.randomElement()!, endPoint: bottomUnitPoint.randomElement()!
                ).ignoresSafeArea()
            )
            .navigationBarItems(
                trailing: Button(action: {
                    audioPreviewManager.stop()
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(DynamicColor(hexString: mainCategory().color).darkened(amount: 0.2)))
                }
            )
        } //: NAVIGATIONVIEW
    }
}

extension MeditationDetailView {
    func mainCategory() -> Category {
        if let mainCategory = categories.first {
            return mainCategory
        } else {
            return Category()
        }
    }
}

//struct MeditationDetailView_Previews: PreviewProvider {
//    static let meditationVM = MeditationViewModel (meditation: Meditation.data)
//    
//    static var previews: some View {
//        MeditationDetailView(meditationViewModel: meditationVM, category: Category(value: ["name": "Peace", "longName": "Inner Peace and Calm", "color": "#7FB3D5", "icon": ""]))
//    }
//}
