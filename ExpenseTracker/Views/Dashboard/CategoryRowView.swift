//
//  CategoryRowView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    @Environment(\.sizeCategory) var dynamicType
    let category: Category
    let sum: Double
    
    var body: some View {
        if dynamicType > .accessibilityMedium {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    CategoryImageView(category: category)
                    Text(category.rawValue.capitalized)
                }
                
                Text(sum.formattedCurrencyText).font(.headline)
            }
            
        } else {
            HStack {
                CategoryImageView(category: category)
                Text(category.rawValue.capitalized)
                Spacer()
                Text(sum.formattedCurrencyText).font(.headline)
            }
        }
        
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRowView(category: .donation, sum: 2500)
    }
}
