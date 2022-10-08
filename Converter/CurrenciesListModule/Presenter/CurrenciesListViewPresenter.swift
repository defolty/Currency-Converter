//
//  CurrenciesListViewPresenter.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import Foundation

protocol CurrenciesListViewProtocol: AnyObject {
    func success()
    func failure(error: Error)
    func sendCurrency(currency: String)
}
 
protocol CurrenciesListViewPresenterProtocol: AnyObject {
    init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?)
    //var currencyDelegate: SelectedCurrencyDelegate? { get set }
    //var buttonCondition: SelectedButton { get }
    var currenciesList: [String]? { get set }
    func getCurrenciesList()
}

class CurrenciesListPresenter: CurrenciesListViewPresenterProtocol {
     
    weak var view: CurrenciesListViewProtocol?
    var currencyTitle: SelectedCurrencyDelegate?
    let networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var currenciesList: [String]?
    
    //var buttonCondition: SelectedButton
    //var currencyDelegate: SelectedCurrencyDelegate?
    
    required init(view: CurrenciesListViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol?) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    func getCurrenciesList() {
        networkService.getCurrenciesList { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    self.currenciesList = list?.currencies.map{ $0.key }.sorted()
                    self.view?.success() 
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
} 
 
