//
//  CurrenciesListView.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//

import UIKit

extension CurrenciesListView: CurrenciesListViewProtocol { 
  func success() {
    tableView.reloadData()
  }
   
  func failure(error: Error) {
    self.showAlert(withTitle: "Error", withMessage: error.localizedDescription)
  }
}

extension CurrenciesListView: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text ?? "")
  }
  
  private func filterContentForSearchText(_ searchText: String) {
    presenter.filterList(text: searchText, state: isFiltering) 
    tableView.reloadData()
  }
}
  
extension CurrenciesListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfRows()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.textAlignment = .center
     
    if isFiltering {
      cell.textLabel?.text = presenter.filteredList?[indexPath.row]
    } else {
      cell.textLabel?.text = presenter.currenciesList?[indexPath.row]
    }
     
    return cell
  }
}

extension CurrenciesListView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let currentCurrency: String
    if isFiltering {
      currentCurrency = presenter.filteredList?[indexPath.row] ?? "n/a"
    } else {
      currentCurrency = presenter.currenciesList?[indexPath.row] ?? "n/a"
    }
    
    sendCurrencyDelegate?.sendSelectedCurrency(currency: currentCurrency)
    presenter.popToRoot()
  }
}
   
protocol SendSelectedCurrency: AnyObject {
  func sendSelectedCurrency(currency: String)
}
 
final class CurrenciesListView: UIViewController {
  
  private var tableView = UITableView()
  private var safeArea: UILayoutGuide!
  private let searchController = UISearchController(searchResultsController: nil)
  
  weak var sendCurrencyDelegate: SendSelectedCurrency?
  var presenter: CurrenciesListViewPresenterProtocol!
  
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
   
  override func loadView() {
    super.loadView()
    
    view.backgroundColor = .systemBackground
    setupTableView()
    setupNavigationBar()
    setupSearchController()
  }
    
  private func setupTableView() {
    safeArea = view.layoutMarginsGuide
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
  }
   
  private func setupNavigationBar() {
    title = "Select Currency To Exchange"
    self.navigationController?.view.backgroundColor = .systemBackground
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Currency"
    searchController.isActive = true
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
}
