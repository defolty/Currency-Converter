//
//  CurrencyList.swift
//  Converter
//
//  Created by Nikita Nesporov on 19.12.2021.
//

// fromCurrency
// toCurrency

import UIKit
 
protocol MyDataSendingDelegateProtocol: AnyObject {
    func sendStringToAny(myString: String, inputButton: String)
}
 
extension CurrencyListVC {
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
       if activeSearch {
           return filterKeys.count
       } else {
           return onlyKeys?.count ?? 0  
       }
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
       if activeSearch {
           cell.textLabel?.text = filterKeys[indexPath.row]
           cell.detailTextLabel?.text = ""
       } else {
           cell.textLabel?.text = onlyKeys?[indexPath.row]
           cell.detailTextLabel?.text = onlyValues?[indexPath.row]
       }
          
       return cell
   }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { 
       let specS = selectedButton
       
       switch selectedButton {
       case "firstButton":
           if activeSearch {
               selectedDelegate?.sendStringToAny(myString: filterKeys[indexPath.row], inputButton: specS)
               navigationController?.popViewController(animated: true)
           } else {
               selectedDelegate?.sendStringToAny(myString: onlyKeys![indexPath.row], inputButton: specS) // до search bar
               navigationController?.popViewController(animated: true)
           } 
       case "secondButton":
           if activeSearch {
               selectedDelegate?.sendStringToAny(myString: filterKeys[indexPath.row], inputButton: specS)
               navigationController?.popViewController(animated: true)
           } else {
               selectedDelegate?.sendStringToAny(myString: onlyKeys![indexPath.row], inputButton: specS) // до search bar
               navigationController?.popViewController(animated: true)
           }
       default:
           print("error 333")
       }
   }
}

// MARK: - Search Bar Methods

extension CurrencyListVC: UISearchBarDelegate {
     
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        activeSearch = !activeSearch
        filterKeys = onlyKeys!

        if searchText.isEmpty == false {
            filterKeys = onlyKeys!.filter({ $0.contains(searchText) })
        }
        mainTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   shouldChangeTextIn range: NSRange,
                   replacementText text: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Z].*", options: [])
            if regex.firstMatch(in: text,
                                options: [],
                                range: NSMakeRange(0, text.count)) != nil {
                return false
            }
        } catch {
            print("error shouldChangeTextIn searchBar")
        }
        return true
    }
}
 
// MARK: - Currency List View Controller

class CurrencyListVC: UITableViewController {
     
    @IBOutlet var searchBar: UISearchBar!
    var activeSearch = false
    
    @IBOutlet var mainTableView: UITableView!
    
    let activityIndicator = ActivityIndicator()
    
    weak var selectedDelegate: MyDataSendingDelegateProtocol?
     
    var dataCurrencies: DataCurrency?
    
    var currencyArray: [String: String]?
    
    var onlyKeys: [String]? = []
    var onlyValues: [String]? = []
    var filterKeys: [String] = []
    
    var selectedButton = ""
    var receivedString = "" {
        didSet {
            selectedButton = receivedString
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
         
        searchBar.delegate = self
        searchBar.autocapitalizationType = .allCharacters 
        
        newFetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
     
    //MARK: - подгрузки данных наименования валюты
    
    func newFetch() { 
        let request = NSMutableURLRequest(url: NSURL(string: Constants.urlString)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constants.headers
        
        self.view.addSubview(activityIndicator)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                self.dataCurrencies = try JSONDecoder().decode(DataCurrency.self, from: data)
                
                self.currencyArray = self.dataCurrencies?.currencies
                
                self.dataCurrencies?.currencies.forEach({ currency in
                    self.onlyKeys?.append(currency.key)
                    self.onlyValues?.append(currency.value)
                })
                   
                DispatchQueue.main.async {
                    self.tableView.reloadData() 
                    self.activityIndicator.hide()
                }
                
            } catch let error {
                print("Error serialization", error)
            } 
        }.resume()
    }
}
 
