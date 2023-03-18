//
//  MeditationView.swift
//  Angel
//
//  Created by Thomas Giacinto on 20/02/23.
//

import SwiftUI
import RealmSwift
import DynamicColor

struct MeditationsMainView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    @StateObject var meditationViewModel = MeditationViewModel()
    
    @ObservedResults(User.self) var users
    
    @State var isMeditationDetailPresented = false
    @State var selectedCategoryCard: Category? = nil
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15) {
                    //                ScrollView(.horizontal, showsIndicators: false) {
                    //                    HStack(spacing: 10) {
                    //                        ForEach(phrasesRealmManager.categories, id: \.self) { category in
                    //                            Button {
                    //
                    //                            } label: {
                    //                                CategoryPill(category: category)
                    //                            }
                    //                        }
                    //                    } //: HSTACK
                    //                    .padding(.horizontal)
                    //                } //: SCROLLVIEW
                    
                    HStack {
                        Image(systemName: "person.fill")
                        Text(users.first?.name ?? String(localized: "Buddy"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text(String(localized: "Meditation-Number \(users.first?.meditations.count ?? 0)"))
                            .font(.subheadline)
                            .fontWeight(.medium)
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text(String(localized: "Featured"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(.leading)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                
                                ForEach(meditationViewModel.featuredMeditations, id: \.self) { meditation in
                                    MeditationFeaturedCard(featuredMeditation: meditation, categories: meditationViewModel.getCategories(for: meditation))
                                }
                                
                            } //: HSTACK
                            .padding(.horizontal)
                        } //: SCROLLVIEW
                    } //: VSTACK
                    
                    VStack(alignment: .leading) {
                        Text(String(localized: "Of-The-Day"))
                            .font(.footnote)
                            .fontWeight(.bold)
                        
                        MeditationOfTheDayCard(meditationViewModel: meditationViewModel, categories: meditationViewModel.getCategories(for: meditationViewModel.meditationOfTheDay))
                        
                    } //: VSTACK
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(String(localized: "All-Meditations"))
                                .font(.footnote)
                                .fontWeight(.bold)
                            Spacer()
                            Button {
                                
                            } label: {
                                HStack(spacing: 5) {
                                    Text(String(localized: "See-All"))
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
                                MeditationDetailView(meditationViewModel: meditationViewModel, categories: [category])
                            })
                            .padding(.horizontal)
                        }
                    } //: VSTACK
                    Spacer()
                } //: VSTACK
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(String(localized: "Meditation"))
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

//struct MeditationsMainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MeditationsMainView()
//    }
//}
