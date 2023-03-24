//
//  ContentView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    // MARK: - PROPERTIES
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
