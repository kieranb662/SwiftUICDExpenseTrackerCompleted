// Swift toolchain version 5.0
// Running macOS version 12.0
// Created on 8/19/21.
//
// Author: Kieran Brown
//

import SwiftUI

struct MonthToggleStyle: ToggleStyle {
    
    // Provides behavior for when toggle is On/off.
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {configuration.isOn.toggle()}, label: {
            configuration.label
        })
        .buttonStyle(MonthButtonStyle())
        .foregroundColor(configuration.isOn ? Color.white : nil)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(configuration.isOn ? Color.black : .clear)
        )
        .animation(.linear, value: configuration.isOn)
    }
    
    // Encapsulated because only used inside toggle
    // Provides behavior for when toggle is pressed
    struct MonthButtonStyle: ButtonStyle {
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .fixedSize(horizontal: true, vertical: false)
                .padding(configuration.isPressed ? 0 : 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(configuration.isPressed ? .clear : Color.black))
                .animation(.linear, value: configuration.isPressed)
        }
    }
}

struct MonthPicker: View {
    @Binding var selection: Set<String>
    @ScaledMetric var minimumWidth: CGFloat = 90 // scales with dynamic type sizes
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: minimumWidth, maximum: 400))], spacing: 8) {
            ForEach(Calendar.current.monthSymbols, id: \.self) { month in
                Toggle(month, isOn: isOnBinding(for: month))
                .toggleStyle(MonthToggleStyle())
            }
        }
    }
    
    func isOnBinding(for month: String) -> Binding<Bool> {
        Binding(get: { selection.contains(month) },
                set: { _ in selection.formSymmetricDifference([month]) })
    }
}

// Create a new view for “monthly summary”, the user can access the view from the bottom submenu
// (add a third icon to the submenu).

// On the view, all twelve months should display and the User can
// select one or multiple months from the screen and the logs for the selected months will be
// displayed in order of date.

struct MonthlySummaryTab: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var selection: Set<String> = []
    
    var body: some View {
        VStack {
            MonthPicker(selection: $selection)
                .font(.headline)
        }
    }
}

struct MonthlySummaryTab_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySummaryTab()
//                    .environment(\.sizeCategory, .accessibilityExtraLarge)
        
    }
}
