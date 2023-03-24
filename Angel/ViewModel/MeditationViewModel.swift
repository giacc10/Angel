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
    let durations: [TimeInterval] = [1, 600, 900, 1800, 2700, 3600]
    let tracks: [String] = ["A Meditation", "Angelic Interlude", "Asia Travel", "Battle Angel", "Believe In Miracle", "Blessed Meditation", "Calling Emotional Angelic Melodic", "Did You Know Angels Play Guitar?", "Documentary", "Dreamy Breathing", "Epic Era", "For Documentary", "For When It Rains", "Francisco Samuel Epic", "Inner Peace Meditation", "Inspirational Asia", "Inspiring Asia", "Love Meditation", "Mindfulness Relaxation", "Monumental Victory", "Open Angel", "Peaceful Garden Healing", "Pure", "Solo Path", "Tolworth", "Voice Of An Angel Three", "You Are Always With Me"]
    
//    @ObservedRealmObject private(set) var meditation: Meditation = Meditation()
    private(set) var meditationOfTheDay: Meditation = Meditation()
    private(set) var featuredMeditations: List<Meditation> = List<Meditation>()
    
    init() {
        phrasesRealmManager.getCategories()
        self.meditationOfTheDay = getTodaysMeditation() ?? Meditation()
        self.featuredMeditations = getFeaturedMeditaion()
    }
    
    func createMeditation(title: String, caption: String, categories: [Category], duration: Int, track: String, type: Typology) -> Meditation {
        return Meditation(value: ["date": Date(), "title": title, "caption": caption, "categories": categories.map({ $0.name.rawValue }), "duration": durations[duration], "track": track, "type": type])
    }
    
    func createGeneratedMeditation(title: String, caption: String, categories: [Category], duration: TimeInterval, track: String, type: Typology) -> Meditation {
        return Meditation(value: ["date": Date(), "title": title, "caption": caption, "categories": categories.map({ $0.name.rawValue }), "duration": duration, "track": track, "type": type])
    }
    
    func getCategories(for meditation: Meditation) -> [Category] {
        var categories = [Category]()
        
        for category in meditation.categories {
            categories.append(phrasesRealmManager.categories.first(where: { $0.name.rawValue == category })!)
        }
        
        return categories
    }
    
//    func createMeditation(title: String, caption: String, categories: [Category], duration: Int, track: String, type: Typology) -> Meditation {
//        return Meditation(value: ["date": Date(), "title": title, "caption": caption, "categories": categories, "duration": durations[duration], "track": track, "type": type])
//    }
    
    private func getTodaysMeditation() -> Meditation? {
        let today = Date().startOfDay()
            
        if let meditationsStorage = meditationsStorages.first {
            
            // Check if there is a meditation in Realm MeditationsStorage
            if let todaysMeditation = meditationsStorage.todaysMeditation {
                // Check if the meditation is for the day
                if todaysMeditation.date.startOfDay() == today {
                    return todaysMeditation
                } else {
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
            newTodaysMeditation.categories.append(randomCategory.name.rawValue)
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
    
    private func getFeaturedMeditaion() -> List<Meditation> {
        let calendar = Calendar.current
        
        if let meditationsStorage = meditationsStorages.first {
            
            // Check if the meditation is of the current week
            if let firstFeaturedMeditation = meditationsStorage.featuredMeditations.first {
                
                if calendar.isDayInCurrentWeek(date: firstFeaturedMeditation.date) ?? false {
                    return meditationsStorage.featuredMeditations
                } else {
                    // If the day is different deleting the Meditation of the day
                    let realm = try! Realm()
                    try! realm.write {
                        for meditation in meditationsStorage.featuredMeditations {
                            realm.delete(meditation)
                        }
                    }
                }
            }
            
            for _ in 1...3 {
                let randomCategories = phrasesRealmManager.categories[randomPick: 2]
                let newFeaturedMeditation = Meditation()
                newFeaturedMeditation.date = Date().startOfDay()
                newFeaturedMeditation.title = "\(randomCategories[0].name.localizedString()) & \(randomCategories[1].name.localizedString())"
                newFeaturedMeditation.caption = "Lorem ipsum dolor sit amet consecutor tes"
                for category in randomCategories {
                    newFeaturedMeditation.categories.append(category.name.rawValue)
                }
                newFeaturedMeditation.duration = durations[Int.random(in: 1...3)]
                newFeaturedMeditation.track = tracks.randomElement()!
                newFeaturedMeditation.type = .featured
                
                let thawedMeditationsStorage = meditationsStorage.thaw()!.realm!
                try! thawedMeditationsStorage.write {
                    let meditationToAppend = thawedMeditationsStorage.create(
                        Meditation.self, value: newFeaturedMeditation, update: .modified
                    )
                    meditationsStorage.featuredMeditations.append(meditationToAppend)
                }
            }
            
            return meditationsStorage.featuredMeditations
            
        }
        
        return List<Meditation>()
        
    }
}
