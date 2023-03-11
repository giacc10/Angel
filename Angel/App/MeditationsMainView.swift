//
//  MeditationView.swift
//  Angel
//
//  Created by Thomas Giacinto on 20/02/23.
//

import SwiftUI
import DynamicColor

struct MeditationsMainView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    @State var isMeditationDetailPresented = false
    @State var selectedCategoryCard: Category? = nil
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(phrasesRealmManager.categories, id: \.self) { category in
                            Button {
                                
                            } label: {
                                CategoryPill(category: category)
                            }
                        }
                    } //: HSTACK
                    .padding(.horizontal)
                } //: SCROLLVIEW
                
                VStack(alignment: .leading) {
                    Text("Featured")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .padding(.leading)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Group {
                                    Text("FORGIVENESS")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("5 minute forgiveness")
                                        .font(.callout)
                                    Text("Forgive yourself and start a beautiful new day")
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                            } //: VSTACK
                            .padding()
                            .frame(width: 350)
                            .frame(minHeight: 150)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                            )
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Group {
                                    Text("BLESSING")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Text("7 minute to be blessed")
                                        .font(.callout)
                                    Text("Feel blessed and be grateful for today")
                                        .font(.footnote)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 5)
                            } //: VSTACK
                            .padding()
                            .frame(width: 350)
                            .frame(minHeight: 150)
                            .background(RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                            )
                        } //: HSTACK
                        .padding(.horizontal)
                    } //: SCROLLVIEW
                } //: VSTACK
                
                VStack(alignment: .leading) {
                    Text("Recommended")
                        .font(.footnote)
                        .fontWeight(.bold)
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Find Peace")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("Open your mind with a meditation for your mind")
                                .font(.footnote)
                        } //: VSTACK
                        .padding(5)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "play.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Circle().fill(Color.cyan))
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                } //: VSTACK
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("All Meditations")
                            .font(.footnote)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack(spacing: 5) {
                                Text("See all")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                            }
                        }
                    } //: HSTACK
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(phrasesRealmManager.categories, id: \.self) { category in
                                MeditationCategoryCard(category: category)
                                    .onTapGesture {
                                        selectedCategoryCard = category
                                    }
                            }
                        } //: HSTACK
                        .fullScreenCover(item: $selectedCategoryCard, content: { category in
                            MeditationDetailView(meditationViewModel: MeditationViewModel(meditation: Meditation()), categories: [category])
                        })
                        .padding(.horizontal)
                    }
                } //: VSTACK
                Spacer()
            } //: VSTACK
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    VStack {
                        Text("Meditation")
                            .customFont(size: 40)
//                            .textCase(.uppercase)
                    }
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                    }
                }
            )
        } //: NAVIGATIONVIEW
    }
}

struct MeditationsMainView_Previews: PreviewProvider {
    static var previews: some View {
        MeditationsMainView()
    }
}
