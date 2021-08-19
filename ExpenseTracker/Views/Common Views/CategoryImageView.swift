//
//  CategoryImageView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CategoryImageView: View {
    
    let category: Category
    
    var body: some View {
        Image(systemName: category.systemNameIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.all, 12)
            .foregroundColor(category.color)
            .background(
                Circle()
                    .fill(category.color.opacity(0.1))
                )
            .frame(maxWidth: 50,  maxHeight: 50)
    }
}

struct CategoryImageView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryImageView(category: .donation)
    }
}
