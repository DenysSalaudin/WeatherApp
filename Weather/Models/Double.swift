//
//  Double.swift
//  Weather
//
//  Created by Denis on 2/15/23.
//

import Foundation

extension Double {
    
    
    
    ///converts double into 2 decimal places
    ///```
    ///Convert 1234.56 to $1,234,56
    ///Convert 12.3456 to $12,3456
    ///Convert 0.123456 to $0,23456
    ///```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        //formatter.locale = .current // default value
        //formatter.currencyCode = "usd" // change currency
        //formatter.currencySymbol = "$" // change currency symbol
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    
    ///converts double into String  2 digits
    ///```
    ///Convert 1234.56 to "$1,234,56"
    ///Convert 12.3456 to "$12,3456"
    ///Convert 0.123456 to "$0,23456"
    ///```
    
    
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from:number) ?? "0.00"
    }
    
    
    
    
    
    ///converts double into 2-6 decimal places
    ///```
    ///Convert 1234.56 to $1,234,56
    ///Convert 12.3456 to $12,3456
    ///Convert 0.123456 to $0,23456
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current // default value
        //formatter.currencyCode = "usd" // change currency
        //formatter.currencySymbol = "$" // change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    ///converts double into String  2-6 digits
    ///```
    ///Convert 1234.56 to "$1,234,56"
    ///Convert 12.3456 to "$12,3456"
    ///Convert 0.123456 to "$0,23456"
    ///```
    
    
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from:number) ?? "0.00"
    }
    
    
    ///converts double into String  2-6 digits
    ///```
    ///Convert 1234.56 to "$1,23"
    ///```
    
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
