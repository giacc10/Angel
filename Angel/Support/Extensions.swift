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
}
