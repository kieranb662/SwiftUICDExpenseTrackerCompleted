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
    @Environment(\.sizeCategory) var dynamicType
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
    
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    @State var date: Date = Date()
    @State var notes: String = ""
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var title: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button("Cancel", action: onCancelTapped)
                Spacer()
                Button("Save", action: onSaveTapped)
            }
            
            Text(title).font(.largeTitle)
            
            Group {
                TextField("Name", text: $name)
                    .disableAutocorrection(true)
                TextField("Amount", value: $amount, formatter: Utils.numberFormatter)
                    .keyboardType(.numbersAndPunctuation)
            }
            .padding()
            .border(Color.black)
            
            if dynamicType > .extraLarge {
                Group {
                    categoryPicker
                    datePicker.labelsHidden()
                }.accentColor(.black)
            } else {
                HStack {
                    categoryPicker
                    datePicker
                }.accentColor(.black)
            }
            
            Text("Notes").bold()
            
            TextEditor(text: $notes)
                .border(Color.black)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    var categoryLabel: some View {
        if dynamicType > .extraLarge  {
            HStack(spacing: 0) {
                Text("Category:")
                Spacer()
                Text(" \(category.rawValue)").foregroundColor(category.color)
            }
            .contentShape(Rectangle())
            .font(Font.subheadline.bold())
            
        } else {
            (Text("Category:") + Text(" \(category.rawValue)").foregroundColor(category.color))
                .font(Font.subheadline.bold())
                .fixedSize()
        }
    }
    
    var categoryPicker: some View {
        Picker(selection: $category, label: categoryLabel) {
            ForEach(Category.allCases) { category in
                Text(category.rawValue.capitalized).tag(category)
            }
        }.pickerStyle(MenuPickerStyle())
    }
    
    var datePicker: some View {
        DatePicker(selection: $date, displayedComponents: .date) {
            EmptyView()
        }.datePickerStyle(CompactDatePickerStyle())
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
        log.note = notes
        
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
