//
//  ExchangePresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//
 
import Foundation

enum SelectedButton {
    case fromButton, toButton
}

protocol SelectedCurrencyDelegate {
    func tapOnButton(currencyName: String, condition: SelectedButton)
}
 
protocol ExchangeViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
}

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?)
    func exchangeCurrencies(fromValue: String, toValue: String, and amount: Double)
}

class ExchangePresenter: ExchangeViewPresenterProtocol {
    
    private let view: ExchangeViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private let router: RouterProtocol?
    var firstSelectedCurrency: String?
    var secondSelectedCurrency: String?
    
    required init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func exchangeCurrencies(fromValue: String, toValue: String, and amount: Double) {
        networkService.exchangeCurrencies(fromValue: fromValue, toValue: toValue, currentAmount: amount) 
    }
}

extension ExchangePresenter: SelectedCurrencyDelegate {
    func tapOnButton(currencyName: String, condition: SelectedButton) {
        switch condition {
        case .fromButton:
            self.firstSelectedCurrency = currencyName
        case .toButton:
            self.secondSelectedCurrency = currencyName
        }
    }
}
 
