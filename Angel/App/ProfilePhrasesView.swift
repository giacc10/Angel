//
//  ProfilePhrasesView.swift
//  Angel
//
//  Created by Thomas Giacinto on 20/03/23.
//

import SwiftUI
import RealmSwift
import DynamicColor

struct ProfilePhrasesView: View {
    
    // MARK: - PROPERTIES
    @StateObject var phrasesRealmManager = PhrasesRealmManager()
    
    @ObservedResults(AngelicPhrase.self) var allPhrases
    
    @State var selectedPhrase: AngelicPhrase? = nil
    @State var isProfilePhraseDetailPresented = false
    
    // MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            Spacer(minLength: 20)
            ForEach(phrasesInCategory().sorted(by: { $0.key < $1.key }), id: \.key) { key, values in
                VStack {
                    DisclosureGroup {
                        Spacer(minLength: 10)
                        ForEach(values, id: \.self) { phrase in
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey(phrase.key))
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color(DynamicColor(hexString: getCategory(for: key).color).darkened(amount: 0.4)))
                                    .onTapGesture {
                                        selectedPhrase = phrase
                                        print(getCategory(for: key).color)
                                    }
                            }
                            .padding()
                            .background(Color(DynamicColor(hexString: getCategory(for: key).color).saturated(amount: 0.5)))
                            .cornerRadius(7)
                        }
                    } label: {
                        Text(LocalizedStringKey(returnCategoryName(for: key)))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color(DynamicColor(hexString: getCategory(for: key).color).saturated(amount: 0.5)))
                    }
                } //: VSTACK
                .padding()
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                )
                .padding(.horizontal)
                .sheet(item: $selectedPhrase) { phrase in
                    ProfilePhraseDetailView(phrase: phrase, category: getCategory(for: String(phrase.idProgressive.prefix(3))))
                }
            }
            Spacer(minLength: 20)
        } //: SCROLLVIEW
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(String(localized: "Favorites"))
                    //                            .customFont(size: 40)
                        .font(.headline)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
                }
            }
        }
    }
}

extension ProfilePhrasesView {
    // MARK: - FUNCTIONS
    private func phrasesInCategory() -> [String : [AngelicPhrase]] {
        return Dictionary(grouping: allPhrases, by: { String($0.idProgressive.prefix(3)) })
    }
    
    private func returnCategoryName(for string: String) -> String {
        switch string {
        case "pea":
            return "Peace"
        case "hop":
            return "Hope"
        case "ble":
            return "Blessing"
        case "for":
            return "Forgiveness"
        case "abu":
            return "Abundance"
        case "cou":
            return "Courage"
        case "joy":
            return "Joy"
        case "pro":
            return "Protection"
        case "tra":
            return "Transformation"
        case "sel":
            return "Self-Care"
        case "rel":
            return "Relationships"
        case "suc":
            return "Success"
        case "con":
            return "Confidence"
        case "gra":
            return "Gratitude"
        case "hea":
            return "Healing"
        case "kin":
            return "Kindness"
        case "fai":
            return "Faith"
        case "ser":
            return "Serenity"
        case "fea":
            return "Fear"
        case "pat":
            return "Patience"
        default:
            return "Category"
        }
    }
    
    private func getCategory(for string: String) -> Category {
        let category = returnCategoryName(for: string)
        return phrasesRealmManager.categories.first(where: { $0.name.rawValue == category })!
    }
}

struct ProfilePhrasesView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhrasesView()
    }
}
