//
//  CurrenciesListView.swift
//  Converter
//
//  Created by Nikita Nesporov on 08.10.2022.
//
 
import UIKit

class CurrenciesListView: UIViewController {
    
    private let tableView = UITableView()
    private var safeArea: UILayoutGuide!
    var presenter: CurrenciesListViewPresenterProtocol!
    
    override func loadView() {
        super.loadView()
         
        safeArea = view.layoutMarginsGuide
        setupTableView()
        print("load view success")
    }
     
    private func setupTableView() {
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
}

extension CurrenciesListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.currenciesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let currentCurrency = presenter.currenciesList?[indexPath.row] 
        cell.textLabel?.text = currentCurrency
        
        return cell
    }
}

extension CurrenciesListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.popToRoot()
    }
}

extension CurrenciesListView: CurrenciesListViewProtocol {
    
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        ///# add alert
        print(error.localizedDescription)
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
