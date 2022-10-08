//
//  NetworkManager.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCurrenciesList(completion: @escaping (Result<CurrenciesListData?, Error>) -> Void)
    func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: Double)
    func sendExchangeRequest(request: NSMutableURLRequest)
}

class NetworkService: NetworkServiceProtocol {
    
    func getCurrenciesList(completion: @escaping (Result<CurrenciesListData?, Error>) -> Void) {
        let request = NSMutableURLRequest(
            url: NSURL(string: Constants.currenciesListUrl)! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            guard let data else { return }
            if let error {
                completion(.failure(error))
            }
            do {
                let currenciesData = try JSONDecoder().decode(CurrenciesListData.self, from: data)
                completion(.success(currenciesData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: Double) {
        let url = "\(Constants.firstPartUrl)\(fromValue)&to=\(toValue)&amount=\(amount)&apiKey=\(Constants.apiKey)&format=json"
        let request = NSMutableURLRequest(
            url: NSURL(string: url)! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0
        )
        let reverse = "\(Constants.firstPartUrl)\(toValue)&to=\(fromValue)&amount=\(amount)&apiKey=\(Constants.apiKey)&format=json"
        let reverseRequest = NSMutableURLRequest(
            url: NSURL(string: reverse)! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0
        )
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        reverseRequest.httpMethod = "GET"
        reverseRequest.allHTTPHeaderFields = Constants.headers
        
        sendExchangeRequest(request: request)
        //sendExchangeRequest(request: reverseRequest)
    }
    
    func sendExchangeRequest(request: NSMutableURLRequest) {
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data else { return }
            do {
                let convertingRate = try JSONDecoder().decode(ExchangeCurrenciesData.self, from: data)
                
                DispatchQueue.main.async {
                    print(convertingRate)
                }
            } catch let error {
                print("Error serialization", error)
            }
        }.resume()
    }
}

/*
 DispatchQueue.main.async {
 // let firstFieldNumber = convertingRate.rates?.first?.value.rateForAmount ?? "000"
 // let doubleFirstValue = Double(firstFieldNumber)
 // let roundDouble = floor(10000 * doubleFirstValue!) / 10000
 // let roundedFirstFieldNumber = String(roundDouble) //String(roundDouble)
 print(convertingRate)
 }
 */
