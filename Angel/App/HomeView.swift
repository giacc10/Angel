//
//  HomeView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI
import RealmSwift
import DynamicColor

struct HomeView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    @ObservedResults(User.self) var users
    
    @State private var currentPhrase = ""
    @State private var phrasesArray: [AngelicPhrase] = []
    @State private var freePhrasesArray: [AngelicPhrase] = []
//    @State private var phrasesIndexs: [Int] = []
    @State private var loadedPhraseIds = Set<String>()
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                
                // MARK: - Phrases Reels
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    TabView(selection: $currentPhrase) {
                        ForEach(phrasesArray) { phrase in
                            
                            // MARK: - Phrase
                            PhraseCard(phrase: phrase, isPremium: users.first!.isSubscriptionActive)
                                .onAppear {
                                    loadPhrase()
                                }
                                .frame(width: size.width)
                                .rotationEffect(.init(degrees: -90))
                                .ignoresSafeArea(.all)
                        }
                    } //: TABVIEW
                    .onAppear {
                        if loadedPhraseIds.isEmpty {
                            loadPhrase()
                        }
                    }
                    .rotationEffect(.init(degrees: 90))
                    .frame(width: size.height) // Setting width as height since is rotated
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: size.width) // Setting max width
                } //: GEOMETRYREADER
                .ignoresSafeArea(.all, edges: .trailing)
                
            } //: ZSTACK
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Angel")
//                            .customFont(size: 40)
                            .font(.headline)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                    }
                }
            }
        } //: NAVIGATIONVIEW
        
    }
}

extension HomeView {
    
    // MARK: - FUNCTIONS
    private func loadPhrase() {
        print("##: Loading new phrase")
        
        let phrasesCount = !users.first!.isSubscriptionActive ? phrasesRealmManager.angelicPhrases.filter { !$0.premium }.count : phrasesRealmManager.angelicPhrases.count
        
        if phrasesCount > loadedPhraseIds.count {
            
            var randomPhraseToAppend = randomPhrase()
            
            print("##: Try \(randomPhraseToAppend.idProgressive)")
            while loadedPhraseIds.contains(randomPhraseToAppend.idProgressive) {
                randomPhraseToAppend = randomPhrase()
                print("##: Already present, retry")
            }
            
            // Append the random phrase to the phrases array and mark its id as loaded
            phrasesArray.append(randomPhraseToAppend)
            loadedPhraseIds.insert(randomPhraseToAppend.idProgressive)
            
            print("##: Insert \(randomPhraseToAppend.idProgressive)")
            print("##: Loaded \(phrasesArray.count) phrases")
        }
//        if phrasesArray.count < phrases.count {
//            for _ in phrases {
//                // Create an Index
//                let randomIndex = Int.random(in: 0..<phrases.count)
//                // Check if the index already loaded
//                print("try \(randomIndex)")
//                if !phrasesIndexs.contains(randomIndex) {
//                    phrasesIndexs.append(randomIndex)
//                    phrasesArray.append(phrases[randomIndex])
//                    print("insert \(randomIndex)")
//                    print(phrasesIndexs)
//                    break
//                }
//                print("Already present, retry")
//            }
//        }
    }
    
    private func randomPhrase() -> AngelicPhrase {
        var randomPhrase = AngelicPhrase()
        
        if !users.first!.isSubscriptionActive {
            let filteredPhrases = phrasesRealmManager.angelicPhrases.filter { phrase in
                return !phrase.premium
            }
            randomPhrase = filteredPhrases.randomElement()!
        } else {
            // Choose a random phrase from the phrases array that has not already been loaded
            randomPhrase = phrasesRealmManager.angelicPhrases.randomElement()!
        }
        
        return randomPhrase
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
