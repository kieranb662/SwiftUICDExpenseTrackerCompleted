// Swift toolchain version 5.0
// Running macOS version 12.0
// Created on 8/19/21.
//
// Author: Kieran Brown
//

import SwiftUI 

struct LogRow: View {
    @Environment(\.sizeCategory) private var dynamicType
    var log: ExpenseLog
    
    var body: some View {
        if dynamicType > .extraExtraExtraLarge {
            largeDynamicTypeLayout(log: log)
        } else {
            smallDynamicTypeLayout(log: log)
        }
    }
    
    func largeDynamicTypeLayout(log: ExpenseLog) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack() {
                CategoryImageView(category: log.categoryEnum)
                Text(log.nameText).font(.headline)
            }

            if dynamicType > .accessibilityLarge {
                Text(log.amountText).font(.headline)
                Text(log.dateText).font(.subheadline)
            } else {
                HStack(spacing: 0) {
                    Text(log.dateText).font(.subheadline)
                    Spacer()
                    Text(log.amountText).font(.headline)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    func smallDynamicTypeLayout(log: ExpenseLog) -> some View {
        HStack(spacing: 16) {
            CategoryImageView(category: log.categoryEnum)

            VStack(alignment: .leading, spacing: 8) {
                Text(log.nameText).font(.headline)
                Text(log.dateText).font(.subheadline)
            }
            Spacer()
            Text(log.amountText).font(.headline)
        }
        .padding(.vertical, 4)
    }
}
