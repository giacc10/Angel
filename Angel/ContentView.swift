//
//  ContentView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @StateObject var appRealmManager = AppRealmManager()
    
    // MARK: - BODY
    var body: some View {
        if appRealmManager.user != nil {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "doc.append")
                        Text("Feed")
                    }
                PhrasesView()
                    .tabItem {
                        Image(systemName: "quote.opening")
                        Text("Phrases")
                    }
                MeditationsMainView()
                    .tabItem {
                        Image(systemName: "person.and.background.dotted")
                        Text("Meditation")
                    }
                Text("View 4")
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
            }
        } else {
            CreateUserView()
                .environmentObject(appRealmManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
