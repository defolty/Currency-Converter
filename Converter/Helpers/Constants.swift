//
//  Constants.swift
//  Converter
//
//  Created by Nikita Nesporov on 19.12.2021.
//

import Foundation

enum Constants {
  
  enum Api {
    static let apiKey = "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5"
    static let firstPartUrl = "https://currency-converter5.p.rapidapi.com/currency/convert?from="
    static let currenciesListUrl = "https://currency-converter5.p.rapidapi.com/currency/list?apiKey=f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5&format=json"
    static let headers = [
      "x-rapidapi-host": "currency-converter5.p.rapidapi.com",
      "x-rapidapi-key": "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5"
    ]
    static let httpMethod = "GET"
  }
  
  enum Identifiers {
    static let currenciesListCellID = "cell"
    static let allExchangedCurrenciesListCellID = "allCurrenciesCell"
  }
  
  enum Titles {
    static let navigationItemEmptyBackButtonTitle = ""
    static let navigationBarTitle = "Currency Converter"
    static let allExchangedCurrenciesNavBarTitle = "Exchange Rate To All Currencies"
    static let currenciesListNavBarTitle = "Select Currency To Exchange"
    static let firstCurrencyTextFieldPlaceholder = "You can type here..."
    static let secondCurrencyTextFieldPlaceholder = "or here..."
    static let searchBarPlaceholder = "Search currency"
    static let showAllExchangedCurrenciesListTitle = "Show All Exchanged Currencies"
  }
  
  enum SystemName {
    static let swapButtonImage = "rectangle.2.swap"
  }
  
  enum InitialValues {
    static let firstCurrencyTextFieldInitialValue = "1.0"
    static let fromCurrencySelectionButtonInitialValue = "EUR"
    static let toCurrencySelectionButtonInitialValue = "RUB"
  }
  
  enum Errors {
    static let errorTitle = "Error"
    static let errorGetCellText = "Error get Cell Text"
    static let errorNavBarTitle = "Error nav bar title"
  }
}
  

