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

final class CurrenciesListView: UIViewController {
  
  private var tableView = UITableView()
  private var safeArea: UILayoutGuide!
  var onButtonAction: ((String) -> Void)?
  var presenter: CurrenciesListViewPresenterProtocol!
  
  override func loadView() {
    super.loadView()
    
    setupTableView()
    setupNavigationBar()
    presenter.setAction()
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
    self.isModalInPresentation = true
    self.navigationController?.view.backgroundColor = .systemBackground
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(handleDone))
  }
  
  @objc func handleDone() {
    print("handleDone")
    //presenter.popToRoot()
  }
  
  @objc func handleCancel() {
    presenter.popToRoot()
  }
}

extension CurrenciesListView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.currenciesList?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
    let currentCurrency = presenter.currenciesList?[indexPath.row]
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.text = currentCurrency
    
    return cell
  }
}

extension CurrenciesListView: UITableViewDelegate { 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let currentCurrency = presenter.currenciesList?[indexPath.row]
    guard let currentCurrency else { return }
    onButtonAction?(currentCurrency)
    presenter.popToRoot()
    print(currentCurrency)
  }
}

//#if DEBUG
//import SwiftUI
//
//struct ListViewController_Preview: PreviewProvider {
//    static var previews: some View = Preview(
//        for: CurrenciesListView()
//    )
//}
//#endif
