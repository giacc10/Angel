//
//  PayWallView.swift
//  Angel
//
//  Created by Thomas Giacinto on 22/03/23.
//

import SwiftUI
import RealmSwift
import DynamicColor
import RevenueCat
import ProgressHUD

struct PayWallView: View {
    
    //MARK: - PROPERTIES
    @Environment(\.dismiss) var dismiss
    @State private var barHidden = true
    
    @ObservedRealmObject var user: User
    
    @State var currentOffering: Offering?
    @State var selectedPackage: Package? = nil
    @State private var isPurchasing = false
    
    let color: String
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack {
                    ZStack(alignment: .topTrailing) {
                        Button{
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                        }
                        VStack {
                            Image("betty-icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white, lineWidth: 2)
                                )
                            Text(String(localized: "Go-Premium"))
                                .font(.title)
                                .fontWeight(.bold)
                                .textCase(.uppercase)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                            Text(String(localized: "Get-Access-Features"))
                                .fontWeight(.medium)
                                .font(.callout)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                        } //: VSTACK
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                    } //: ZSTACK
                    .padding(.top)
                    VStack(alignment: .leading, spacing: 10) {
                        FeatureLabel(isDone: true, headline: String(localized: "Get-All-Phrases"), caption: String(localized: "Get-All-Phrases-Caption"))
                        FeatureLabel(isDone: true, headline: String(localized: "Speech-The-Phrases"), caption: String(localized: "Speech-The-Phrases-Caption"))
                        FeatureLabel(isDone: true, headline: String(localized: "Meditation-With-Phrases"), caption: String(localized: "Meditation-With-Phrases-Caption"))
                        FeatureLabel(isDone: true, headline: String(localized: "Meditation-By-Category"), caption: String(localized: "Meditation-By-Category-Caption"))
                        FeatureLabel(isDone: true, headline: String(localized: "Meditation-By-Day"), caption: String(localized: "Meditation-By-Day-Caption"))
                        FeatureLabel(isDone: true, headline: String(localized: "Meditation-By-Featured"), caption: String(localized: "Meditation-By-Featured-Caption"))
                        Divider()
                            .padding(.top)
                    }
                    .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                    .padding(.top)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(String(localized: "And-Coming-Soon"))
                            .fontWeight(.medium)
                            .font(.callout)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.bottom, 5)
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                        FeatureLabel(isDone: false, headline: String(localized: "More-Phrases-Coming"), caption: String(localized: "More-Phrases-Coming-Caption"))
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                        FeatureLabel(isDone: false, headline: String(localized: "Daily-Notifications"), caption: String(localized: "Daily-Notifications-Caption"))
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                        Divider()
                            .padding(.top)
                    }
                    
                    VStack {
                        Text(String(localized: "Select-Plan"))
                            .font(.title2)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                        
                        if currentOffering != nil {
                            
                            HStack {
                                ForEach(currentOffering!.availablePackages) { pkg in
                                    VStack {
                                        Text("\(pkg.storeProduct.subscriptionPeriod!.value)")
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                                        Text("\(pkg.storeProduct.subscriptionPeriod!.periodTitle)")
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .textCase(.uppercase)
                                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                                        Text(pkg.storeProduct.localizedPriceString)
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                            .padding(.top, 0)
                                            .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                                    } //: VSTACK
                                    .frame(width: 75)
                                    .padding()
                                    .onTapGesture {
                                        selectedPackage = pkg
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(self.selectedPackage == pkg ? Color(DynamicColor(hexString: color).lighter(amount: 0.3)) :
                                                Color(DynamicColor(hexString: color).darkened(amount: 0.2)), lineWidth: 4)
                                    )
                            } //: HSTACK
                        }
                            
                        ButtonCTA(text: String(localized: "Continue"), color: color) {
                                ProgressHUD.show(String(localized: "Processing"), interaction: false)

                            if let package = selectedPackage {
                                
                                Purchases.shared.purchase(package: package) { (transaction, customerInfo, error, userCancelled) in
                                    
                                    isPurchasing = true
                                    
                                    if customerInfo?.entitlements["premium"]?.isActive == true {
                                        // Unlock that great "pro" content
                                        
                                        $user.isSubscriptionActive.wrappedValue = true
                                        isPurchasing = false
                                        ProgressHUD.dismiss()
                                        ProgressHUD.showSuccess(String(localized: "All-Set-Premium"))
                                        return
                                    }
                                    ProgressHUD.showFailed()
                                    isPurchasing = false
                                }
                            }
                            }
                            .padding(.top)
                            Text(String(localized: "Support-Developer") + " 👨‍💻")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .padding(.bottom)
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                            
                        }
                        
                        
                        Button {
                            Purchases.shared.restorePurchases { customerInfo, error in
                                //... check customerInfo to see if entitlement is now active
                                $user.isSubscriptionActive.wrappedValue = customerInfo?.entitlements["premium"]?.isActive == true
                            }
                        } label: {
                            Text(String(localized: "Restore-Purchase"))
                                .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                        }
                        
                        
                    }
                    
                    Text(String(localized: "Payment-Disclaimer"))
                        .font(.system(size: 10))
                        .multilineTextAlignment(.center)
                        .padding(.top)
                        .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.2)))
                } //: VSTACK
                .padding(.horizontal)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                                           value: -$0.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) {
                    if !barHidden && $0 < 120 {
                        barHidden = true
                    } else if barHidden && $0 > 120 {
                        barHidden = false
                    }
                }
                .onAppear {
                    Purchases.shared.getOfferings { offerings, error in
                        if let offer = offerings?.current, error == nil {
                            currentOffering = offer
                        }
                    }
                }
                .overlay {
                    // Display an overlay during purchases
                    Rectangle()
                        .foregroundColor(.black)
                        .opacity(isPurchasing ? 0.5 : 0.0)
                        .edgesIgnoringSafeArea(.all)
                }
            } //: SCROLLVIEW
            .coordinateSpace(name: "scroll")
            .navigationBarHidden(barHidden)
            .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigation) {
                            VStack {
                                Text(String(localized: "Go-Premium"))
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .textCase(.uppercase)
                                    .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.3)))
                            }
                        }
                    }
            .navigationBarItems(
                trailing: Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color(DynamicColor(hexString: color).darkened(amount: 0.4)))
                }
            )
            .background(
                LinearGradient(gradient: Gradient(colors: [
                    Color(DynamicColor(hexString: color).lighter()),
                    Color(DynamicColor(hexString: color).saturated(amount: 0.5))
                ]), startPoint: .topLeading, endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )
            
        } //: NAVIGATION
        .animation(.default, value: barHidden)
        .edgesIgnoringSafeArea(.all)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct PayWallView_Previews: PreviewProvider {
//    static var previews: some View {
//        PayWallView(color: "#C3F2E5")
//    }
//}
