//
//  Extensions.swift
//  Angel
//
//  Created by Thomas Giacinto on 15/02/23.
//

import Foundation
import SwiftUI

// MARK: - CUSTOMIZATION
struct CustomFont: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Hey-August", size: size))
//            .font(.custom("whitescratches", size: size))
//            .font(.custom("Alvifont", size: size))
    }
}

// MARK: - EXTENSIONS
extension View {
    func customFont(size: CGFloat) -> some View {
        modifier(CustomFont(size: size))
    }
    
    #if canImport(UIKit)
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
}

extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
    
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey ?? "", locale: locale)
    }
}

extension String {
    // Remove the last character if is a space
    func trimWhiteSpace() -> String {
        var newString = self
        while newString.last?.isWhitespace == true {
            newString = String(newString.dropLast())
        }
        return newString
    }
    
    static func localizedString(for key: String, locale: Locale = .current) -> String {
        
        let language = locale.languageCode
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

extension Array {
    /// Picks `n` random elements (straightforward approach)
    subscript (randomPick n: Int) -> [Element] {
        var indices = [Int](0..<count)
        var randoms = [Int]()
        for _ in 0..<n {
            randoms.append(indices.remove(at: Int(arc4random_uniform(UInt32(indices.count)))))
        }
        return randoms.map { self[$0] }
    }
}

extension Date {
    func startOfDay() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)!
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm E, d MMM y"
        return dateFormatter.string(from: self)
    }
}

extension TimeInterval {
    func toMinutes() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        return formatter.string(from: self) ?? ""
    }
    
    var hourMinute: String {
        String(format:"%d h %02d m", hour, minute)
    }
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
}

extension DateComponentsFormatter {
    static let abbreviated: DateComponentsFormatter = {
        print("Initializing DateComponentsFormatter.abbreviated" )
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    static let positional: DateComponentsFormatter = {
        print("Initializing DateComponentsFormatter.positional")
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
}

extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}
