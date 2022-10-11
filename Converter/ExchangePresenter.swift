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
    func updateViews(field: ActiveTextField)
    func failure(error: Error)
}

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol?
    )
    func exchangeCurrencies(fromValue: String, toValue: String)
    func getValuesFromView(field: ActiveTextField, value: String)
    func setValues(value: String, activeField: ActiveTextField)
    func tapOnButton()
    var firstSelectedCurrency: String? { get set }
    var secondSelectedCurrency: String? { get set }
    var valueForFirstField: String? { get set }
    var valueForSecondField: String? { get set }
    var amount: String? { get set }
    var selectedButton: SelectedButtonCondition? { get set }
    var activeField: ActiveTextField? { get set }
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
    
    var firstSelectedCurrency: String?
    var secondSelectedCurrency: String?
    var valueForFirstField: String?
    var valueForSecondField: String?
    var amount: String?
    
    var selectedButton: SelectedButtonCondition?
    var activeField: ActiveTextField?
    
    required init(view: ExchangeViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        print("Exchange Presenter Has Been Initialized")
    }
     
    func getValuesFromView(field: ActiveTextField, value: String) {
        print("2")
        guard let firstSelectedCurrency, let secondSelectedCurrency else { return }
        amount = value
        activeField = field
        
        switch field {
        case .firstTextField:
            exchangeCurrencies(fromValue: firstSelectedCurrency, toValue: secondSelectedCurrency)
        case .secondTextField:
            exchangeCurrencies(fromValue: secondSelectedCurrency, toValue: firstSelectedCurrency)
        }
    }
    
    func exchangeCurrencies(fromValue: String, toValue: String) {
        print("3")
        guard let amount else { return }
        networkService.exchangeCurrencies(fromValue: fromValue,
                                          toValue: toValue,
                                          currentAmount: amount) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async { //After(deadline: .now() + 0.3)
                switch result {
                case .success(let model):
                    self.exchangeModel = model
                    guard let rateForAmount = model?.rates?.first?.value.rateForAmount else { return }
                    self.setValues(
                        value: rateForAmount,
                        activeField: self.activeField!
                    )
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func setValues(value: String, activeField: ActiveTextField) {
        print("4")
        switch activeField {
        case .firstTextField:
            valueForSecondField = value
        case .secondTextField:
            valueForFirstField = value
        }
        view?.updateViews(field: activeField)
    }
    
    func tapOnButton() {
        router?.showCurrenciesList()
    } 
}

