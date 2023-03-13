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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
