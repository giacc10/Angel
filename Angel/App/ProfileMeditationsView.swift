//
//  ProfileMeditations.swift
//  Angel
//
//  Created by Thomas Giacinto on 18/03/23.
//

import SwiftUI
import Charts
import RealmSwift
import DynamicColor

struct ProfileMeditationsView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    @ObservedResults(User.self) var users
    
    @State var meditationCategoriesCount = 0 // To set the height of the chart
    @State var isChartDisclosureExpanded = false
    
    // MARK: - BODY
    var body: some View {
        ScrollView {
            Spacer(minLength: 20)
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading) {
                        Text(String(localized: "You-Meditated") + ":")
                            .font(.footnote)
                            .fontWeight(.bold)
                        Text(totalTimeMeditation())
                            .font(.system(size: 35))
                            .fontWeight(.bold)
                    } //: VSTACK
                    
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
                    
                    DisclosureGroup(isExpanded: $isChartDisclosureExpanded) {
                        Chart {
                            ForEach(meditationCategories(meditations: Array(users.first!.meditations)), id: \.category) { category, count in
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
                        .frame(minHeight: CGFloat(meditationCategoriesCount * 60))
                    } label: {
                        HStack {
                            Spacer()
                            Text(isChartDisclosureExpanded ? "Collapse-Chart" : "Expand-Chart")
                                .font(.caption2)
                                .fontWeight(.medium)
                        }
                    }
                    
                } //: VSTACK
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                )
                .padding(.horizontal)
                
                ForEach(groupMeditationsByMonth().sorted(by: { $0.value[0].date > $1.value[0].date }), id: \.key) { key, values in
                    VStack {
                        DisclosureGroup {
//                            Spacer(minLength: 10)
                            Text(String(localized: "Meditation-Number \(values.count)"))
                                .font(.footnote)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            ForEach(values.sorted(by: { $0.date > $1.date }), id: \.self) { meditation in
                                MeditationRow(meditation: meditation, categories: getCategories(for: Array(meditation.categories)))
                            }
                        } label: {
                            Text(key)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    } //: VSTACK
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                    )
                    .padding(.horizontal)
                    
                }
                
            } //: VSTACK
            .onAppear {
                meditationCategoriesCount = Set(users.first!.meditations.map { $0.categories.first! }).count
            }
        } //: SCROLLVIEW
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(String(localized: "Meditations"))
                    //                            .customFont(size: 40)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
            }
        }
    }
}

extension ProfileMeditationsView {
    // MARK: - FUNCTIONS
    private func totalTimeMeditation() -> String {
        return users.first!.meditations.map({$0.duration}).reduce(0, +).hourMinute
    }
    
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
    
    private func meditationCategories(meditations: [Meditation]) -> [(category: Category, count: Int)] {
        var categoryCounts: [String: Int] = [:]
        for meditation in meditations {
            if meditation.type == .standard {
                for category in meditation.categories {
                    categoryCounts[category, default: 0] += 1
                }
            }
        }
        // Sorting the categories
        let sortedCategories = categoryCounts.sorted { $0.value > $1.value }

        return sortedCategories.map{ (category: getCategory(for: $0.key), count: $0.value) }
    }
    
    private func getCategory(for category: String) -> Category {
        return phrasesRealmManager.categories.first(where: { $0.name.rawValue == category })!
    }
    
    private func getCategories(for categories: [String]) -> [Category] {
        var categoriesToReturn: [Category] = []
        for category in categories {
            categoriesToReturn.append(getCategory(for: category))
        }
        return categoriesToReturn
    }
    
    private func groupMeditationsByMonth() -> [String: [Meditation]] {
        if let user = users.first {
            let meditations = user.meditations
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy" // format for grouping by month and year
                
            let groupedMeditations = Dictionary(grouping: meditations) { meditation in
                formatter.string(from: meditation.date)
            }
                
            return groupedMeditations
        }
        return ["" : [Meditation()]]
    }
}

struct ProfileMeditationsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMeditationsView()
    }
}
