//
//  Constants.swift
//  Converter
//
//  Created by Nikita Nesporov on 19.12.2021.
//

import Foundation
 
struct Constants {
    static let firstPartUrl = "https://currency-converter5.p.rapidapi.com/currency/convert?from="
    static let apiKey = "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5"
    static let currenciesListUrl = "https://currency-converter5.p.rapidapi.com/currency/list?apiKey=f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5&format=json"
    static let headers = [
        "x-rapidapi-host": "currency-converter5.p.rapidapi.com",
        "x-rapidapi-key": "f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5"
    ]
}
 
/*
 exchange
 https://currency-converter5.p.rapidapi.com/currency/convert?from=USD&to=RUB&amount=100&apiKey=f96847c424msh3226f07e3f2ade4p1464a8jsn93f99a3b39e5&format=json
 */
