// Swift toolchain version 5.0
// Running macOS version 12.0
// Created on 8/19/21.
//
// Author: Kieran Brown
//

import SwiftUI

struct MonthToggleStyle: ToggleStyle {
    
    static let BackgroundShape = Capsule()

    // Provides behavior for when toggle is On/off.
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {configuration.isOn.toggle()}, label: {
            configuration.label
        })
        .buttonStyle(MonthButtonStyle())
        .foregroundColor(configuration.isOn ? Color.white : nil)
        .background(
            MonthToggleStyle.BackgroundShape
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
                .padding(configuration.isPressed ? 0 : 8)
                .overlay(
                    MonthToggleStyle.BackgroundShape
                        .strokeBorder(configuration.isPressed ? .clear : Color.black))
                .padding(configuration.isPressed ? 8 : 0)
                .animation(.linear, value: configuration.isPressed)
        }
    }
}

struct MonthPicker: View {
    @Binding var selection: Set<Int>
    @ScaledMetric var minimumWidth: CGFloat = 90 // scales with dynamic type sizes
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle().frame(height: 1)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0...11, id: \.self) { month in
                        Toggle(Calendar.current.monthSymbols[month], isOn: isOnBinding(for: month))
                            .toggleStyle(MonthToggleStyle())
                    }
                }
            }
            .padding(8)
            .background(Color(white: 0.96))
            Rectangle().frame(height: 1)
        }
    }
    
    func isOnBinding(for month: Int) -> Binding<Bool> {
        Binding(get: { selection.contains(month) },
                set: { _ in selection.formSymmetricDifference([month]) })
    }
}

// Create a new view for “monthly summary”, the user can access the view from the bottom submenu
// (add a third icon to the submenu).

// On the view, all twelve months should display and the User can
// select one or multiple months from the screen and the logs for the selected months will be
// displayed in order of date.

struct SummaryExpenseList: View {
    var selection: Set<Int>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)],
        animation: .default)
    private var items: FetchedResults<ExpenseLog>
    
    var body: some View {
        List {
            ForEach(items) { log in
                if log.dateOccurs(in: selection) {
                    LogRow(log: log)
                }
            }
        }
    }
}

struct MonthlySummaryTab: View {
    @Environment(\.managedObjectContext) var viewContext
    @State var selection: Set<Int> = []
    
    var body: some View {
        VStack {
            MonthPicker(selection: $selection)
                .font(.headline)
            SummaryExpenseList(selection: selection)
        }
    }
}

struct MonthlySummaryTab_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySummaryTab()
    }
}
