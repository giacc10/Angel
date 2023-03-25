//
//  OnBoardingView.swift
//  Angel
//
//  Created by Thomas Giacinto on 24/03/23.
//

import SwiftUI
import DynamicColor

struct OnBoardingView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.openURL) var openURL
    
    let color = "#7FB3D5"
    
    @State private var onBoardingItems: [OnBoardingItem] = [
        .init(title: String(localized: "Onboarding-Title-1"), subTitle: String(localized: "Onboarding-Subtitle-1"), image: "onboarding-1"),
        .init(title: String(localized: "Onboarding-Title-2"), subTitle: String(localized: "Onboarding-Subtitle-2"), image: "onboarding-2"),
        .init(title: String(localized: "Onboarding-Title-3"), subTitle: String(localized: "Onboarding-Subtitle-3"), image: "onboarding-3")
    ]
    
    @State private var currentIndex: Int = 0
    @State private var isLoginTapped = false
    
    // MARK: - BODY
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            HStack(spacing: 0) {
                ForEach(onBoardingItems) { item in
                    let isLastSlide = (currentIndex == onBoardingItems.count - 1)
                    ZStack {
                        ParticleView()
                        VStack {
                            
                            // MARK: - Top Nav Bar
                            HStack {
                                Button(String(localized: "Back")) {
                                    if currentIndex > 0 {
                                        currentIndex -= 1
                                    }
                                }
                                .opacity(currentIndex > 0 ? 1 : 0)
                                Spacer()
                                Button(String(localized: "Skip")) {
                                    currentIndex = onBoardingItems.count - 1
                                }
                                .opacity(isLastSlide ? 0 : 1)
                            } //: HSTACK
                            .tint(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                            .fontWeight(.bold)
                            
                            Spacer()
                            
                            // MARK: - Movable Slides
                            VStack(spacing: 15) {
                                let offset = -CGFloat(currentIndex) * size.width
                                
                                Image(item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .offset(x: offset)
                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                
                                Text(item.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                                    .multilineTextAlignment(.center)
                                    .offset(x: offset)
                                    .animation(.easeInOut(duration: 0.3).delay(0.1), value: currentIndex)
                                Text(item.subTitle)
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 15)
                                    .offset(x: offset)
                                    .animation(.easeInOut(duration: 0.3).delay(0.15), value: currentIndex)
                            } //: VSTACK
                            
                            Spacer()
                            
                            // MARK: - Next / Login Button
                            VStack(spacing: 15) {
                                Text(isLastSlide ? String(localized: "Create-Profile") : String(localized: "Next"))
                                    .textCase(.uppercase)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                                    .padding(.vertical)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(Color(DynamicColor(hexString: color).lighter(amount: 0.3)))
                                    )
                                
                                    .padding(.horizontal, isLastSlide ? 0 : 100)
                                    .onTapGesture {
                                        if currentIndex < onBoardingItems.count - 1 {
                                            currentIndex += 1
                                        }
                                        if isLastSlide {
                                            isLoginTapped.toggle()
                                        }
                                    }
                                    .sheet(isPresented: $isLoginTapped) {
                                        UserFormView(user: User())
                                    }
                            } //: VSTACK
                            .padding(.bottom)
                            
                            HStack {
                                Button {
                                    openURL(URL(string: AppData.termsUrl)!)
                                } label: {
                                    Text(String(localized: "Terms-Of-Service"))
                                        .underline(true, color: Color.primary)
                                        .font(.caption2)
                                }
                                
                                Button {
                                    openURL(URL(string: AppData.privacyUrl)!)
                                } label: {
                                    Text(String(localized: "Privacy-Policy"))
                                        .underline(true, color: Color.primary)
                                        .font(.caption2)
                                }
                            } //: HSTACK
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                        } //: VSTACK
                        .animation(.easeInOut, value: isLastSlide)
                        .padding(15)
                        .frame(width: size.width, height: size.height)
                    } //: ZSTACK
                }
            } //: HSTACK
            .frame(width: size.width * CGFloat(onBoardingItems.count), alignment: .leading)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(DynamicColor(hexString: color).lighter()),
                    Color(DynamicColor(hexString: color).saturated(amount: 0.5))
                ]), startPoint: .topLeading, endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )
        }
    }
}

extension OnBoardingView {
    // MARK: - FUNCTIONS
    private func indexOf(_ item: OnBoardingItem) -> Int {
        if let index = onBoardingItems.firstIndex(of: item) {
            return index
        }
        return 0
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
