// Swift toolchain version 5.0
// Running macOS version 12.0
// Created on 8/19/21.
//
// Author: Kieran Brown
//

import SwiftUI

// Create a new view for “monthly summary”, the user can access the view from the bottom submenu
// (add a third icon to the submenu).

// On the view, all twelve months should display and the User can
// select one or multiple months from the screen and the logs for the selected months will be
// displayed in order of date.

struct MonthlySummaryTab: View {
    @State var selection: Set<String> = []
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 300))], spacing: 8) {
            ForEach(Calendar.current.monthSymbols, id: \.self) { month in
                Text(month)
                    .onTapGesture(perform: { select(month) })
                    .border(selection.contains(month) ? Color.black : .clear)
                    .animation(.linear, value: selection)
            }
        }
    }
    
    func select(_ month: String) {
        selection.formSymmetricDifference([month])
    }
}

struct MonthlySummaryTab_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySummaryTab()
    }
}
