//
//  LogFormView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogFormView: View {
    
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
    
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    @State var date: Date = Date()
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var title: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 8) {
                
                Group {
                    TextField("Name", text: $name)
                        .disableAutocorrection(true)
                    TextField("Amount", value: $amount, formatter: Utils.numberFormatter)
                        .keyboardType(.numbersAndPunctuation)
                }
                .padding()
                .border(Color.black)
                
                HStack {
                    
                    Picker(selection: $category, label: categoryLabel) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }.pickerStyle(MenuPickerStyle())
                    
                    DatePicker(selection: $date, displayedComponents: .date) {
                        EmptyView()
                    }.datePickerStyle(CompactDatePickerStyle())
                }
                .accentColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            .navigationBarItems(
                leading: Button(action: self.onCancelTapped) { Text("Cancel")},
                trailing: Button(action: self.onSaveTapped) { Text("Save")}
            ).navigationBarTitle(title)
        }
    }
    
    var categoryLabel: some View {
        (Text("Category:") + Text(" \(category.rawValue)").foregroundColor(category.color))
         .font(Font.subheadline.bold())
         .fixedSize()
    }
    
    private func onCancelTapped() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onSaveTapped() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        let log: ExpenseLog
        if let logToEdit = self.logToEdit {
            log = logToEdit
        } else {
            log = ExpenseLog(context: self.context)
            log.id = UUID()
        }
        
        log.name = self.name
        log.category = self.category.rawValue
        log.amount = NSDecimalNumber(value: self.amount)
        log.date = self.date
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

struct LogFormView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        return LogFormView(context: stack.viewContext)
    }
}
