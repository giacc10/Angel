//
//  CustomSegmentedPicker.swift
//  Angel
//
//  Created by Thomas Giacinto on 10/03/23.
//

import SwiftUI
import DynamicColor

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
struct BackgroundGeometryReader: View {
    var body: some View {
        GeometryReader { geometry in
            return Color
                    .clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
}
struct SizeAwareViewModifier: ViewModifier {

    @Binding private var viewSize: CGSize

    init(viewSize: Binding<CGSize>) {
        self._viewSize = viewSize
    }

    func body(content: Content) -> some View {
        content
            .background(BackgroundGeometryReader())
            .onPreferenceChange(SizePreferenceKey.self, perform: { if self.viewSize != $0 { self.viewSize = $0 }})
    }
}

struct CustomSegmentedPicker: View {
    private static let ActiveSegmentColor: Color = Color(.tertiarySystemBackground)
    private static let ShadowColor: Color = Color.black.opacity(0.2)
    private static let TextColor: Color = .black
    private static let SelectedTextColor: Color = Color(.label)

    private static let TextFont: Font = .callout.bold()
        
    private static let SegmentCornerRadius: CGFloat = 12
    private static let ShadowRadius: CGFloat = 4
    private static let SegmentXPadding: CGFloat = 16
    private static let SegmentYPadding: CGFloat = 10
    private static let PickerPadding: CGFloat = 8
    
    private static let AnimationDuration: Double = 0.1
        
    // Stores the size of a segment, used to create the active segment rect
    @State private var segmentSize: CGSize = .zero
    // Rounded rectangle to denote active segment
    private var activeSegmentView: AnyView {
        // Don't show the active segment until we have initialized the view
        // This is required for `.animation()` to display properly, otherwise the animation will fire on init
        let isInitialized: Bool = segmentSize != .zero
        if !isInitialized { return EmptyView().eraseToAnyView() }
            return
                RoundedRectangle(cornerRadius: CustomSegmentedPicker.SegmentCornerRadius)
                    .foregroundColor(Color(DynamicColor(hexString: color).saturated(amount: 0.2)))
                    .shadow(color: Color(DynamicColor(hexString: color).darkened(amount: 0.5)).opacity(0.3), radius: CustomSegmentedPicker.ShadowRadius)
                    .frame(width: self.segmentSize.width, height: self.segmentSize.height)
                    .offset(x: self.computeActiveSegmentHorizontalOffset(), y: 0)
                    .animation(Animation.linear(duration: CustomSegmentedPicker.AnimationDuration))
                    .eraseToAnyView()
    }
        
    @Binding private var selection: Int
    private let items: [TimeInterval]
    private let color: String
        
    init(items: [TimeInterval], selection: Binding<Int>, color: String) {
        self._selection = selection
        self.items = items
        self.color = color
    }
        
    var body: some View {
        // Align the ZStack to the leading edge to make calculating offset on activeSegmentView easier
        ZStack(alignment: .leading) {
            // activeSegmentView indicates the current selection
            self.activeSegmentView
            HStack {
                ForEach(0..<self.items.count, id: \.self) { index in
                    self.getSegmentView(for: index)
                }
            }
        }
        .padding(CustomSegmentedPicker.PickerPadding)
        .background(Color(DynamicColor(hexString: color).tinted(amount: 0.7)))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    // Helper method to compute the offset based on the selected index
    private func computeActiveSegmentHorizontalOffset() -> CGFloat {
        CGFloat(self.selection) * (self.segmentSize.width + CustomSegmentedPicker.SegmentXPadding / 2)
    }

    // Gets text view for the segment
    private func getSegmentView(for index: Int) -> some View {
        guard index < self.items.count else {
            return EmptyView().eraseToAnyView()
        }
        let isSelected = self.selection == index
        return
        Text(self.items[index].toMinutes())
                // Dark test for selected segment
            .font(CustomSegmentedPicker.TextFont)
            .textCase(.uppercase)
            .foregroundColor(isSelected ? Color(DynamicColor(hexString: color).darkened(amount: 0.4)) : Color(DynamicColor(hexString: color).saturated(amount: 0.2)))
            .lineLimit(1)
            .padding(.vertical, CustomSegmentedPicker.SegmentYPadding)
            .padding(.horizontal, 10)
            .frame(minWidth: 0, maxWidth: .infinity)
            // Watch for the size of the
            .modifier(SizeAwareViewModifier(viewSize: self.$segmentSize))
            .onTapGesture { self.onItemTap(index: index) }
            .eraseToAnyView()
    }

    // On tap to change the selection
    private func onItemTap(index: Int) {
        guard index < self.items.count else {
            return
        }
        self.selection = index
    }
}

struct CustomSegmentedPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentedPicker(items: [300, 600, 900, 1800, 2700, 3600], selection: .constant(0), color: "#7FB3D5")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
