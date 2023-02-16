//
//  ContentView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        
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
            Text("View 3")
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
