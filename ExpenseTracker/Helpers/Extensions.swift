//
//  Extensions.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import Foundation

extension Double {
    
    var formattedCurrencyText: String {
        return Utils.numberFormatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
    func formattedCurrencyText(using currency: Currency) -> String {
        switch currency {
        case .usd:
            return formattedCurrencyText
        case .eur:
            return "€" + formattedCurrencyText.dropFirst()
        }
    }
}
