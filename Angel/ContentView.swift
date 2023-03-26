//
//  ContentView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI
import RealmSwift
import RevenueCat

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @Environment(\.realm) var realm
    @ObservedResults(User.self) var users
    
    // MARK: - BODY
    var body: some View {
        if !users.isEmpty {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "doc.append")
                        Text("Feed")
                    }
                    .onAppear {
                        checkSubscription()
                    }
                PhrasesView()
                    .tabItem {
                        Image(systemName: "quote.opening")
                        Text(String(localized: "Phrases"))
                    }
                MeditationsMainView()
                    .tabItem {
                        Image(systemName: "person.and.background.dotted")
                        Text(String(localized: "Meditation"))
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text(String(localized: "Profile"))
                    }
            }
        } else {
            OnBoardingView()
        }
    }
}

extension ContentView {
    func checkSubscription() {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            // access latest customerInfo
            if customerInfo?.activeSubscriptions.isEmpty == true {
                let user = realm.objects(User.self).where { $0.id == 0 }.first!
                try! realm.write {
                    user.isSubscriptionActive = false
                }
                print("##: SUBSCRIPTION NOT ACTIVE")
            } else {
                print("##: SUBSCRIPTION ACTIVE")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
