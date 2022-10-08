//
//  ConvertCurrency.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.12.2021.
//
 
struct CurrenciesListData: Codable {
   let currencies: [String: String]
}

struct ExchangeCurrenciesData: Codable {
    var baseCurrencyName, updatedDate, status: String
    var baseCurrencyCode, amount: String
    var rates: [String: Rates]?
    
    enum CodingKeys: String, CodingKey {
        case status, amount, rates
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
        case updatedDate = "updated_date"
    }
}

struct Rates: Codable {
    var currencyName: String?
    var rate: String?
    var rateForAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case rate
        case currencyName = "currency_name"
        case rateForAmount = "rate_for_amount"
    }
}
 
 
