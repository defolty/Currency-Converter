//
//  ExchangePresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 06.10.2022.
//
 
import Foundation
 
//protocol SelectedCurrencyDelegate {
//    func tapOnButton(currencyName: String, condition: SelectedButtonCondition)
//}
 
enum SelectedButtonCondition {
    case fromButton, toButton
}

enum ActiveTextField {
   case firstTextField, secondTextField
}

protocol ExchangeViewProtocol: AnyObject {
    func updateViews(buttonCondition: SelectedButtonCondition, activeTextField: ActiveTextField)
    func failure(error: Error)
}

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol?
    )
    func exchangeCurrencies()
    func tapOnButton()
    var firstSelectedCurrency: String { get set }
    var secondSelectedCurrency: String { get set }
    var firstCurrencyValue: String { get set }
    var secondCurrencyValue: String? { get set }
    var exchangeModel: ExchangeCurrenciesData? { get set }
}

//extension ExchangePresenter: SelectedCurrencyDelegate {
//    func tapOnButton(currencyName: String, condition: SelectedButtonCondition) {
//        switch condition {
//        case .fromButton:
//            self.firstSelectedCurrency = currencyName
//        case .toButton:
//            self.secondSelectedCurrency = currencyName
//        }
//    }
//}
 
class ExchangePresenter: ExchangeViewPresenterProtocol {
    let view: ExchangeViewProtocol?
    let router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var exchangeModel: ExchangeCurrenciesData?
    
    var firstSelectedCurrency: String
    var secondSelectedCurrency: String
    var firstCurrencyValue: String
    var secondCurrencyValue: String?
    
    var selectedButton: SelectedButtonCondition
    var activeField: ActiveTextField
    
    required init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
        self.view = view
        self.networkService = networkService
        self.router = router
         
        self.firstSelectedCurrency = "USD"
        self.secondSelectedCurrency = "RUB"
        self.firstCurrencyValue = "100.0"
        self.selectedButton = .fromButton
        self.activeField = .firstTextField
        exchangeCurrencies()
    }
    
    func tapOnButton() {
        router?.showCurrenciesList()
    }
    
    func exchangeCurrencies() {
        networkService.exchangeCurrencies(
            fromValue: firstSelectedCurrency,
            toValue: secondSelectedCurrency,
            currentAmount: firstCurrencyValue) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let rates):
                        self.exchangeModel = rates
                        self.view?.updateViews(buttonCondition: self.selectedButton, activeTextField: self.activeField)
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
        }
        
        //networkService.exchangeCurrencies(fromValue: firstSelectedCurrency, toValue: secondSelectedCurrency, currentAmount: firstCurrencyValue)
        guard let rateForAmount = exchangeModel?.rates?.first?.value.rateForAmount else { return }
        
        switch activeField {
        case .firstTextField:
            self.secondCurrencyValue = rateForAmount
        case .secondTextField:
            self.firstCurrencyValue = rateForAmount
        }
    }
}

