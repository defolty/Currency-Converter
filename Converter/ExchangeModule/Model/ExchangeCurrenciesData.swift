//
//  ExchangeCurrenciesData.swift
//  Converter
//
//  Created by Nikita Nesporov on 20.12.2021.
//
  
struct ExchangeCurrenciesData: Decodable {
  let baseCurrencyName, updatedDate, status: String
  let baseCurrencyCode, amount: String
  let rates: [String: Rates]?
  
  enum CodingKeys: String, CodingKey {
    case status, amount, rates
    case baseCurrencyCode = "base_currency_code"
    case baseCurrencyName = "base_currency_name"
    case updatedDate = "updated_date"
  }
}
 
struct Rates: Decodable {
  let currencyName: String?
  let rate: String?
  let rateForAmount: String?
  
  enum CodingKeys: String, CodingKey {
    case rate
    case currencyName = "currency_name"
    case rateForAmount = "rate_for_amount"
  }
}


