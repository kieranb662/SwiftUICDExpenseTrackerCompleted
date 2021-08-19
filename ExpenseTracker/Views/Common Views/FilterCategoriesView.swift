//
//  FilterCategoriesView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct FilterCategoriesView: View {
    
    @Binding var selectedCategories: Set<Category>
    private let categories = Category.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                
                Spacer().frame(width: 1)
                    
                ForEach(categories) { category in
                    FilterButtonView(
                        category: category,
                        isSelected: self.selectedCategories.contains(category),
                        onTap: self.onTap
                    )
                }
                
                Spacer().frame(width: 1)
            }
        }
        .padding(.vertical, 8)
    }
    
    func onTap(category: Category) {
        selectedCategories.formSymmetricDifference([category])
    }
}

struct FilterButtonView: View {
    
    var category: Category
    var isSelected: Bool
    var onTap: (Category) -> ()
    
    var body: some View {
        Button(action: {
            self.onTap(self.category)
        }) {
            Text(category.rawValue.capitalized)
            .fixedSize(horizontal: true, vertical: true)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(isSelected ? category.color : Color(UIColor.lightGray), lineWidth: 1))
        }
        .foregroundColor(isSelected ? category.color : Color(UIColor.gray))
    }
    
    
}


struct FilterCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        FilterCategoriesView(selectedCategories: .constant(Set()))
    }
}
