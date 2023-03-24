//
//  OnBoardingModel.swift
//  Angel
//
//  Created by Thomas Giacinto on 24/03/23.
//

import Foundation

struct OnBoardingItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}
