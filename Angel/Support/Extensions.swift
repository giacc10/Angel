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
            .font(.custom("whitescratches", size: size))
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

extension TimeInterval {
    func toMinutes() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        return formatter.string(from: self) ?? ""
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
}
