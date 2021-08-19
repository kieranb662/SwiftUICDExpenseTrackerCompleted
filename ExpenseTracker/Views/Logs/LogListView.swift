//
//  LogListView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogListView: View {
    @Environment(\.sizeCategory) var dynamicType
    @State var logToEdit: ExpenseLog?
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    
    init(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach(result) { (log: ExpenseLog) in
                Button(action: {
                    self.logToEdit = log
                }) {
                    if dynamicType > .extraExtraExtraLarge {
                        largeDynamicTypeLayout(log: log)
                    } else {
                        smallDynamicTypeLayout(log: log)
                    }
                }
                .sheet(item: $logToEdit, onDismiss: {
                    self.logToEdit = nil
                }) { (log: ExpenseLog) in
                    LogFormView(
                        logToEdit: log,
                        context: self.context,
                        name: log.name ?? "",
                        amount: log.amount?.doubleValue ?? 0,
                        category: Category(rawValue: log.category ?? "") ?? .food,
                        date: log.date ?? Date()
                    )
                }
            }
            .onDelete(perform: onDelete)
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
    
    private func onDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let log = result[index]
            context.delete(log)
        }
        try? context.saveContext()
    }
}

struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        return LogListView(predicate: nil, sortDescriptor: sortDescriptor)
            .environment(\.managedObjectContext, stack.viewContext)
    }
}
