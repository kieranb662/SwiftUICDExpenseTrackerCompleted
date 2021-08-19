//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

enum Currency: Hashable, Equatable {
    case usd, eur
}

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    @StateObject var conversionManager = CurrencyConversionManager()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                if let totalExpenses = totalExpenses {
                    Text("Total expenses")
                        .font(.headline)
                    
                    Text((totalExpenses * (conversionManager.response?.rate ?? 1))
                            .formattedCurrencyText(using: conversionManager.currency))
                        .font(.largeTitle)
                    
                    Picker("Currency", selection: $conversionManager.currency) {
                        Text("USD").tag(Currency.usd)
                        Text("EUR").tag(Currency.eur)
                    }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: conversionManager.currency) { (selected) in
                        switch selected {
                        case .eur:
                            conversionManager.fetchConvertedAmount(value: totalExpenses)
                        case .usd:
                            conversionManager.response = nil
                            conversionManager.cancellable = nil 
                        }
                    }
                }
            }
            
            if let categoriesSum = categoriesSum {
                if let totalExpenses = totalExpenses, totalExpenses > 0 {
                    PieChartView(
                        data: categoriesSum.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                }
                
                Divider()

                List {
                    Section(header: Text("Breakdown").font(.headline)) {
                        ForEach(categoriesSum) {
                            CategoryRowView(currency: conversionManager.currency, category: $0.category, sum: $0.sum * (conversionManager.response?.rate ?? 1))
                        }
                    }
                }
            }
            
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
        .onAppear(perform: fetchTotalSums)
        .alert(item: $conversionManager.fetchErrorToDisplay) { (error) in
            Alert(title: Text(error.title), message: Text(error.message))
        }
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
