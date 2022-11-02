//
//  CurrenciesListViewController.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit
 
  // MARK: - Extension Delegate Send Selected Currency
 
protocol ExchangeViewDelegate: AnyObject {
  func sendSelectedCurrency(_ currency: String)
}

  // MARK: - View Protocol

protocol CurrenciesListViewProtocol: AnyObject {
  func onSuccess()
  func onFailure(error: Error)
}

  // MARK: - Class Currencies List ViewController
 
final class CurrenciesListViewController: UIViewController {
  
  // MARK: - Properties
  
  private var tableView = UITableView()
  private var safeArea: UILayoutGuide!
  private let searchController = UISearchController(searchResultsController: nil)
  
  weak var exchangeViewDelegate: ExchangeViewDelegate?
  var presenter: CurrenciesListViewPresenterProtocol!
   
  private var isFiltering: Bool {
    searchController.isActive && !isSearchBarEmpty
  }
   
  private var isSearchBarEmpty: Bool {
    searchController.searchBar.text?.isEmpty ?? true
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    
    setup()
  }
  
  // MARK: - Config UI
  
  private func setup() {
    view.backgroundColor = .systemBackground
    setupTableView()
    setupConstraints()
    setupNavigationBar()
    setupSearchController()
  }
  
  private func setupTableView() {
    safeArea = view.layoutMarginsGuide
    view.addSubview(tableView)
    tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: Constants.Identifiers.currenciesListCellID
    )
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }
  
  private func setupNavigationBar() {
    title = Constants.Titles.currenciesListNavBarTitle
    navigationController?.view.backgroundColor = .systemBackground
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = Constants.Titles.searchBarPlaceholder
    searchController.isActive = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
}
 
 // MARK: - Extension CurrenciesListViewProtocol

extension CurrenciesListViewController: CurrenciesListViewProtocol {
  
  func onSuccess() {
    tableView.reloadData()
  }
  
  func onFailure(error: Error) {
    showAlert(
      withTitle: Constants.Errors.errorTitle,
      withMessage: error.localizedDescription
    )
  }
}

 // MARK: - Extension UISearchController

extension CurrenciesListViewController: UISearchResultsUpdating {
 func updateSearchResults(for searchController: UISearchController) {
   let searchBar = searchController.searchBar
   filterContentForSearchText(searchBar.text ?? "")
 }
  
  private func filterContentForSearchText(_ searchText: String) {
    presenter.filterList(by: searchText, state: isFiltering)
    tableView.reloadData()
  }
}

// MARK: - TableView Data Source
 
extension CurrenciesListViewController: UITableViewDataSource {
  
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   presenter.numberOfRows()
 }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: Constants.Identifiers.currenciesListCellID,
      for: indexPath
    )
    cell.textLabel?.textAlignment = .center
    
//    cell.textLabel?.text = isFiltering
//    ? presenter.filteredList?[indexPath.row]
//    : presenter.currenciesList?[indexPath.row]
     
    cell.textLabel?.text = isFiltering
    ? presenter.filteredList?[indexPath.row]
    : "\(presenter.currenciesList?[indexPath.row] ?? "bad cell 1") (\(presenter.currenciesDetailList?[indexPath.row] ?? "bad cell"))"
     
    return cell
  }
}

 // MARK: - TableView Delegate

extension CurrenciesListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentCurrency: String
    
    currentCurrency = isFiltering
    ? presenter.filteredList?[indexPath.row] ?? "n/a"
    : presenter.currenciesList?[indexPath.row] ?? "n/a"
    
    exchangeViewDelegate?.sendSelectedCurrency(currentCurrency)
    presenter.popToRootViewController()
  }
}

