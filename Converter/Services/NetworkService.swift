//
//  NetworkService.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import Foundation

  // MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
  typealias exchangeCompletion = (Result<ExchangeCurrenciesData?, Error>) -> Void
  func getCurrenciesList(completion: @escaping (Result<CurrenciesListData?, Error>) -> Void)
  func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: String, completion: @escaping exchangeCompletion)
}

// MARK: - Class Network Service

class NetworkService: NetworkServiceProtocol {
  
  typealias exchangeComplition = (Result<ExchangeCurrenciesData?, Error>) -> Void
  
  func getCurrenciesList(completion: @escaping (Result<CurrenciesListData?, Error>) -> Void) {
    let request = NSMutableURLRequest(
      url: NSURL(string: Constants.currenciesListUrl)! as URL,
      cachePolicy: .useProtocolCachePolicy,
      timeoutInterval: 5.0
    )
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = Constants.headers
    URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
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
  
  func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: String, completion: @escaping exchangeCompletion) { 
    let url = "\(Constants.firstPartUrl)\(fromValue)&to=\(toValue)&amount=\(amount)&apiKey=\(Constants.apiKey)&format=json"
    let request = NSMutableURLRequest(
      url: NSURL(string: url)! as URL,
      cachePolicy: .useProtocolCachePolicy,
      timeoutInterval: 5.0
    )
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = Constants.headers
 
    URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
      guard let data else { return }
      do {
        let convertingRate = try JSONDecoder().decode(ExchangeCurrenciesData.self, from: data)
        DispatchQueue.main.async {
          completion(.success(convertingRate))
        }
      } catch let error { 
        completion(.failure(error))
      }
    }.resume()
  }
}
 
