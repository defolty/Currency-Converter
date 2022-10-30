//
//  AllExchangedCurrenciesViewController.swift
//  Converter
//
//  Created by Nikita Nesporov on 21.10.2022.
//

import UIKit
 
  // MARK: - View Protocol
 
protocol AllExchangedCurrenciesViewProtocol: AnyObject {
  func onSuccess()
  func onFailure(error: Error)
}

  // MARK: - Send Initial Currency From View

protocol AllExchangedViewDelegate: AnyObject {
  func sendBaseCurrency(_ currency: String)
}
 
  // MARK: - Class Exchange All Currencies ViewController

final class AllExchangedCurrenciesViewController: UIViewController {
  
  // MARK: - Properties
  
  private var tableView = UITableView()
  private var safeArea: UILayoutGuide!
  private let searchController = UISearchController(searchResultsController: nil)
   
  var presenter: AllExchangedCurrenciesPresenterProtocol!
  
  private var isFiltering: Bool {
    searchController.isActive && !isSearchBarEmpty
  }
  
  private var isSearchBarEmpty: Bool {
    searchController.searchBar.text?.isEmpty ?? true
  }
  
  var fromCurrencyDidAccept: String? {
    didSet {
      presenter.fromCurrency = fromCurrencyDidAccept
      presenter.getCurrenciesList()
    }
  }
  
  // MARK: - Life Cycle
  
  override func loadView() {
    super.loadView()
    
    setup()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
     
    presenter.onDidDisappear()
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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.Identifiers.allExchangedCurrenciesListCellID)
    tableView.dataSource = self
//    tableView.allowsSelection = false
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
    title = presenter.getNavigationBarTitle()
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

  // MARK: - Extension Exchanged View Delegate

extension AllExchangedCurrenciesViewController: AllExchangedViewDelegate {
  func sendBaseCurrency(_ currency: String) {
    fromCurrencyDidAccept = currency
  }
}
 
  // MARK: - All Exchanged CurrenciesView Protocol
  
extension AllExchangedCurrenciesViewController: AllExchangedCurrenciesViewProtocol {
  func onSuccess() {
    tableView.reloadData()
  }
  
  func onFailure(error: Error) {
    self.showAlert(
      withTitle: Constants.Errors.errorTitle,
      withMessage: error.localizedDescription
    )
  }
}

  // MARK: - Extension Search Controller

extension AllExchangedCurrenciesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text ?? "")
  }
  
  private func filterContentForSearchText(_ searchText: String) {
    presenter.filterList(text: searchText, state: isFiltering)
    tableView.reloadData()
  }
}

  // MARK: - TableView Data Source
 
extension AllExchangedCurrenciesViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfRows()
  }
   
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: Constants.Identifiers.allExchangedCurrenciesListCellID,
      for: indexPath
    )
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.adjustsFontSizeToFitWidth = true
     
    cell.textLabel?.text = isFiltering
    ? presenter.filteredList?[indexPath.row]
    : presenter.getCellText(indexPath: indexPath)
     
    return cell
  }
} 
