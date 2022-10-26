//
//  NetworkService.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//

import Foundation

typealias ExchangeCompletion = (Result<ExchangeCurrenciesData?, Error>) -> Void
typealias GetCurrenciesListCompletion = (Result<CurrenciesListData?, Error>) -> Void

  // MARK: - Network Service Protocol

protocol NetworkServiceProtocol {
   
  func getCurrenciesList(completion: @escaping GetCurrenciesListCompletion)
  func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: String, completion: @escaping ExchangeCompletion)
  func exchangeAllCurrencies(fromValue: String, toValue: String, completion: @escaping ExchangeCompletion)
}

  // MARK: - Class Network Service
 
final class NetworkService: NetworkServiceProtocol {
   
  private let session = URLSession.shared
  
  // MARK: - Get Currencies List
  
  func getCurrenciesList(completion: @escaping (Result<CurrenciesListData?, Error>) -> Void) {
    let request = getRequest(Constants.Api.currenciesListUrl)
    
    let completionOnMain: GetCurrenciesListCompletion = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    
    session.dataTask(with: request as URLRequest) { (data, _, error) in
         
      if let error {
        completionOnMain(.failure(error))
      }
      
      guard let data else { return }
      do {
        let currenciesData = try JSONDecoder().decode(CurrenciesListData.self, from: data)
        completionOnMain(.success(currenciesData))
      } catch {
        completionOnMain(.failure(error))
      }
    }.resume()
  }
  
  // MARK: - Exchange From/To Values
  
  func exchangeCurrencies(fromValue: String, toValue: String, currentAmount amount: String, completion: @escaping ExchangeCompletion) { 
    let url = "\(Constants.Api.firstPartUrl)\(fromValue)&to=\(toValue)&amount=\(amount)&apiKey=\(Constants.Api.apiKey)&format=json"
    let request = getRequest(url)
    
    let completionOnMain: ExchangeCompletion = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    
    session.dataTask(with: request as URLRequest) { (data, _, error) in
      
      if let error {
        completionOnMain(.failure(error))
      }
       
      guard let data else { return }
      do {
        let convertingRate = try JSONDecoder().decode(ExchangeCurrenciesData.self, from: data)
        completionOnMain(.success(convertingRate))
      } catch {
        completionOnMain(.failure(error))
      }
    }.resume()
  }
  
  // MARK: - Exchange All Currencies In List
  
  func exchangeAllCurrencies(fromValue: String, toValue: String, completion: @escaping ExchangeCompletion) {
    let url = "\(Constants.Api.firstPartUrl)\(fromValue)&to=\(toValue)&amount=1&apiKey=\(Constants.Api.apiKey)&format=json"
    let request = getRequest(url)
    
    let completionOnMain: ExchangeCompletion = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    
    session.dataTask(with: request as URLRequest) { (data, _, error) in
      
      if let error {
        completionOnMain(.failure(error))
      }
      
      guard let data else { return }
      do {
        let convertingRate = try JSONDecoder().decode(ExchangeCurrenciesData.self, from: data)
        completionOnMain(.success(convertingRate))
      } catch {
        completionOnMain(.failure(error))
      }
    }.resume()
  }
  
  // MARK: - Get Request
  
  private func getRequest(_ url: String) -> NSMutableURLRequest {
    let request = NSMutableURLRequest(
      url: NSURL(string: url)! as URL,
      cachePolicy: .useProtocolCachePolicy,
      timeoutInterval: 5.0
    )
    request.httpMethod = Constants.Api.httpMethod
    request.allHTTPHeaderFields = Constants.Api.headers
    
    return request
  }
}
 
