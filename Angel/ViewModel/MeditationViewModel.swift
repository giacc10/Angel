//
//  MeditationViewModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 08/03/23.
//

import Foundation
import RealmSwift

final class MeditationViewModel: ObservableObject {
    
    @ObservedResults(MeditationsStorage.self) var meditationsStorages
    
    let phrasesRealmManager = PhrasesRealmManager()
    let durations: [TimeInterval] = [300, 600, 900, 1800, 2700, 3600]
    let tracks: [String] = ["Angelic Soprano", "Did You Know Angels Play Guitar?", "Solo Path", "For When It Rains", "Epic Era", "Calling Emotional Angelic Melodic", "Angelic Interlude"]
    
    private(set) var meditation = Meditation()
    private(set) var meditationOfTheDay = Meditation()
    
    init() {
        phrasesRealmManager.getCategories()
        self.meditationOfTheDay = getTodaysMeditation() ?? Meditation()
    }
    
    func createMeditation(title: String, caption: String, categories: [Category], duration: Int, track: String, type: Typology) {
        self.meditation = Meditation(value: ["date": Date(), "title": title, "caption": caption, "categories": categories, "duration": durations[duration], "track": track, "type": type])
    }
    
    private func getTodaysMeditation() -> Meditation? {
        let today = Date().startOfDay()
            
        if let meditationsStorage = meditationsStorages.first {
            
            // Check if there is a meditation in Realm MeditationsStorage
            if let todaysMeditation = meditationsStorage.todaysMeditation {
                // Check if the meditation is for the day
                if todaysMeditation.date.startOfDay() == today {
                    return todaysMeditation
                } else  {
                    // If the day is different deleting the Meditation of the day
                    let realm = try! Realm()
                    try! realm.write {
                        realm.delete(todaysMeditation)
                    }
                }
            }
            
            let randomCategory = phrasesRealmManager.categories.randomElement()!
            let newTodaysMeditation = Meditation()
            newTodaysMeditation.date = today
            newTodaysMeditation.title = "Today \(randomCategory.name.localizedString())"
            newTodaysMeditation.caption = "Lorem ipsum dolor sit amet consecutor tes"
            newTodaysMeditation.categories.append(randomCategory)
            newTodaysMeditation.duration = durations[Int.random(in: 0...2)]
            newTodaysMeditation.track = tracks.randomElement()!
            newTodaysMeditation.type = .ofTheDay
            
            let thawedMeditationsStorage = meditationsStorage.thaw()!.realm!
            try! thawedMeditationsStorage.write {
                meditationsStorage.todaysMeditation = thawedMeditationsStorage.create(
                    Meditation.self, value: newTodaysMeditation, update: .modified
                )
            }
            
            return newTodaysMeditation
            
        }
        return nil
    }
}
