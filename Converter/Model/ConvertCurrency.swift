//
//  ConvertCurrency.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.12.2021.
//

import Foundation

struct ConvertCurrency: Codable {
    var baseCurrencyCode: String
    let baseCurrencyName: String
    var amount: String
    let updatedDate: String
    var rates: [String: Rates]?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case status,amount,rates
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
        case updatedDate = "updated_date"
    }
}

struct Rates: Codable {
    var currency_name: String?
    var rate: String?
    var rate_for_amount: String?
}
 
struct DataCurrency: Codable {
    let currencies : [String: String]
}
