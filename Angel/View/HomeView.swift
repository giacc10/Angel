//
//  HomeView.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import SwiftUI
import DynamicColor

struct HomeView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    @State private var currentPhrase = ""
    @State private var phrasesArray: [AngelicPhrase] = []
//    @State private var phrasesIndexs: [Int] = []
    @State private var loadedPhraseIds = Set<Int>()
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            ZStack {
                
                // MARK: - Phrases Reels
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    TabView(selection: $currentPhrase) {
                        ForEach(phrasesArray) { phrase in
                            VStack {
                                
                                HStack {
                                    ForEach(phrase.categories, id: \.self) { category in
                                        Text(category.name)
                                            .font(.caption)
                                            .textCase(.uppercase)
                                            .fontWeight(.medium)
                                            .padding(.horizontal)
                                            .padding(.vertical, 5)
                                            .foregroundColor(.black)
                                            .background(Capsule()
                                                .fill(Color(DynamicColor(hexString: category.color).tinted(amount: 0.2)))
                                            )
                                    }
                                }
                                
                                Spacer()
                                Text(phrase.key)
                                    .customFont(size: 60)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .onAppear {
                                loadPhrase()
                            }
                            .padding()
                            .frame(width: size.width)
                            .rotationEffect(.init(degrees: -90))
                            .ignoresSafeArea(.all)
                        }
                    }
                    .rotationEffect(.init(degrees: 90))
                    .frame(width: size.height) // Setting width as height since is rotated
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(width: size.width) // Setting max width
                    .onAppear {
                        loadPhrase()
                    }
                }
                .ignoresSafeArea(.all, edges: .trailing)
                
                // MARK: - Sidebar Actions
                HStack {
                    Spacer()
                    VStack(spacing: 25) {
                        Spacer()
                        Button {
                            
                        } label: {
                            VStack(spacing: 7) {
                                Image(systemName: "heart.fill")
                                    .font(.title)
                                Text("Like")
                                    .font(.caption2)
                            }
                            .foregroundColor(.primary)
                        }
                        Button {
                            
                        } label: {
                            VStack(spacing: 7) {
                                Image(systemName: "arrowshape.turn.up.right.fill")
                                    .font(.title)
                                Text("Share")
                                    .font(.caption2)
                            }
                            .foregroundColor(.primary)
                        }
                    } //: VSTACK
                    .padding(.bottom, 50)
                    .padding(.trailing, 30)
                } //: HSTACK
            } //: ZSTACK
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Angel")
                            .customFont(size: 40)
//                            .textCase(.uppercase)
                    }
                }
            }
        } //: NAVIGATIONVIEW
        
    }
    
    // MARK: - FUNCTIONS
    private func loadPhrase() {
        print("##: Loading new phrase")
        if phrasesRealmManager.angelicPhrases.count > loadedPhraseIds.count {
            
            // Choose a random phrase from the phrases array that has not already been loaded
            var randomPhrase = phrasesRealmManager.angelicPhrases.randomElement()!
            
            print("##: Try \(randomPhrase.idProgressive)")
            while loadedPhraseIds.contains(randomPhrase.idProgressive) {
                randomPhrase = phrasesRealmManager.angelicPhrases.randomElement()!
                print("##: Already present, retry")
            }
            
            // Append the random phrase to the phrases array and mark its id as loaded
            phrasesArray.append(randomPhrase)
            loadedPhraseIds.insert(randomPhrase.idProgressive)
            
            print("##: Insert \(randomPhrase.idProgressive)")
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
