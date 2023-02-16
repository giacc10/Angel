//
//  ContentView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    // MARK: - PROPERTY
    var body: some View {
        
        TabView {
            HomeView()
                .environmentObject(phrasesRealmManager)
                .tabItem {
                    Image(systemName: "doc.append")
                    Text("Feed")
                }
            Text("View 2")
                .tabItem {
                    Image(systemName: "quote.opening")
                    Text("Phrases")
                }
            Text("View 3")
                .tabItem {
                    Image(systemName: "person.and.background.dotted")
                    Text("Meditation")
                }
            Text("View 4")
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
