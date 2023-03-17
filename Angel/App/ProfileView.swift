//
//  ProfileView.swift
//  Angel
//
//  Created by Thomas Giacinto on 17/03/23.
//

import SwiftUI
import Charts
import RealmSwift
import DynamicColor

struct ProfileView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    @ObservedResults(User.self) var users
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10) {
                    ZStack(alignment: .bottomTrailing) {
                        
                        if !users.first!.isPremium {
                            Button {
                                
                            } label: {
                                HStack {
                                    Image(systemName: "star.square.on.square.fill")
                                    Text(String(localized: "Go-Premium"))
                                }
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                            }
                        }
                        
                        HStack(alignment: .top) {
                            
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 50))
                                
                                VStack(alignment: .leading) {
                                    Text(users.first!.name)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .textCase(.uppercase)
                                    Text(users.first!.isPremium ? String(localized: "Premium") : String(localized: "Free"))
                                        .fontWeight(.medium)
                                        .font(.footnote)
                                    
                                } //: VSTACK
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil")
                            }
                            
                        } //: HSTACK
                    } //: ZSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(String(localized: "Meditations"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(.bottom, 7)
                        
                        if !users.first!.meditations.isEmpty {
                            HStack {
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(String(localized: "Total") + ":")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                    Text(String(localized: "Meditation-Number \(users.first!.meditations.count)"))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                } //: VSTACK
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 0) {
                                    Text(String(localized: "Favorite") + ":")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                    Text(LocalizedStringKey(favoriteMeditationCategory()))
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                } //: VSTACK
                                
                            } //: HSTACK
                            
                            Chart {
                                ForEach(topMeditationCategories(meditations: Array(users.first!.meditations)), id: \.category) { category, count in
                                    BarMark(
                                        x: .value("Value", count),
                                        y: .value("Category", category.name.localizedString())
                                    )
                                    .foregroundStyle(
                                        LinearGradient(gradient: Gradient(colors: [
                                            Color(DynamicColor(hexString: category.color).saturated(amount: 0.3)),
                                            Color(DynamicColor(hexString: category.color).saturated(amount: 1))
                                        ]), startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(10)
                                    .annotation(position: .trailing) {
                                        Text(String(format: "%lld", count))
                                            .font(.caption)
                                            .fontWeight(.medium)
                                    }
                                }
                            } //: CHART
                            .frame(height: 200)
                            
                            HStack {
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Text(String(localized: "See-More"))
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                }
                            } //: HSTACK
                        } else {
                            Text(String(localized: "You-Havent-Made-Meditations"))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                    } //: VSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(String(localized: "Phrases"))
                            .font(.footnote)
                            .fontWeight(.bold)
                            .padding(.bottom, 7)
                        
                        HStack {
                            
                            VStack(alignment: .center, spacing: 3) {
                                Text("40")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                CategoryPill(category: Category())
                            } //: VSTACK
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 3) {
                                Text("40")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                CategoryPill(category: Category())
                            } //: VSTACK
                            
                            Spacer()
                            
                            VStack(alignment: .center, spacing: 3) {
                                Text("40")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                CategoryPill(category: Category())
                            } //: VSTACK
                        } //: HSTACK
                        .padding(.bottom, 10)
                        
                        HStack {
                            Spacer()
                            Button {
                                
                            } label: {
                                Text(String(localized: "See-Favorites"))
                                    .font(.footnote)
                                    .fontWeight(.bold)
                            }
                        } //: HSTACK
                        
                    } //: VSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                    HStack {
                        Text(String(localized: "Settings"))
                            .font(.footnote)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            
                        } label: {
                            Text(String(localized: "Go-To-Settings"))
                                .font(.footnote)
                                .fontWeight(.bold)
                        }
                    } //: HSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                    Spacer()
                    
                } //: VSTACK
            } //: SCROLLVIEW
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(String(localized: "Profile"))
                        //                            .customFont(size: 40)
                            .font(.headline)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                    }
                }
            }
        } //: NAVIGATIONSTACK
    }
}

extension ProfileView {
    // MARK: - FUNCTIONS
    private func favoriteMeditationCategory() -> String {
        
        // Storing all meditated categories
        var categories: [String] = []
        // Count the values with using forEach
        var counts: [String: Int] = [:]
        
        for meditation in users.first!.meditations {
            if meditation.type == .standard {
                categories.append(meditation.categories.first!)
            }
        }
        categories.forEach{ counts[$0] = (counts[$0] ?? 0) + 1 }
        
        // Find the most frequent value and its count with max(by:)
        if let (value, _) = counts.max(by: {$0.1 < $1.1}) {
            return value
        }
        return ""
    }
    
    func topMeditationCategories(meditations: [Meditation]) -> [(category: Category, count: Int)] {
        var categoryCounts: [String: Int] = [:]
        for meditation in meditations {
            for category in meditation.categories {
                categoryCounts[category, default: 0] += 1
            }
        }
        
        // Sorting the categories
//        let sortedCategories = categoryCounts.sorted { $0.value > $1.value }
//        let topCategories = Array(sortedCategories.prefix(3))
        
        let topCategories = Array(categoryCounts.prefix(3))

        return topCategories.map { (category: getCategory(for: $0.key), count: $0.value) }
    }
    
    func getCategory(for meditationCategory: String) -> Category {
        return phrasesRealmManager.categories.first(where: { $0.name.rawValue == meditationCategory })!
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
