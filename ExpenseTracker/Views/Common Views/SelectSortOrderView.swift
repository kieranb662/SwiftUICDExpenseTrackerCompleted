//
//  SelectSortOrderView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct SelectSortOrderView: View {
    @Environment(\.sizeCategory) var dynamicType
    @Binding var sortType: SortType
    @Binding var sortOrder: SortOrder
    
    private let sortTypes = SortType.allCases
    private let sortOrders = SortOrder.allCases
    
    var body: some View {
        if Utils.largeDynamicTypeSizes.contains(dynamicType) {
            VStack {
                sortByPicker
                sortOrderPicker
            }.padding()
        } else {
            HStack {
                sortByPicker
                sortOrderPicker
            }.padding()
        }
    }
    
    var sortByPicker: some View {
        HStack {
            Text("Sort by")
            Picker(selection: $sortType, label: Text("Sort by")) {
                ForEach(SortType.allCases) { type in
                    Image(systemName: type == .date ? "calendar" : "dollarsign.circle")
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var sortOrderPicker: some View {
        HStack {
            
            Text("Order by")
            Picker(selection: $sortOrder, label: Text("Order")) {
                ForEach(sortOrders) { order in
                    Image(systemName: order == .ascending ? "arrow.up" : "arrow.down")
                        .tag(order)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

struct SelectSortOrderView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSortOrderView(sortType: .constant(.amount), sortOrder: .constant(.descending))
    }
}
