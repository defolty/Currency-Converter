//
//  ViewController.swift
//  Converter
//
//  Created by Nikita Nesporov on 17.12.2021.
//

import UIKit
  

extension MainScreenVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.validInput(textField: textField, range: range, string: string, numberOfCharacter: 6, maxDecimalPlaces: 2)
    }
}

extension MainScreenVC: MyDataSendingDelegateProtocol {
    func sendStringToAny(myString: String, inputButton: SelectedButton) {
         
        switch inputButton {
        case .firstButton:
            firstChangeCurrency.setTitle(myString, for: .normal)
            fromValue = myString
        case .secondButton:
            secondChangeCurrency.setTitle(myString, for: .normal)
            toValue = myString 
        }
    }
}

// MARK: - Main View Controller

class MainScreenVC: UIViewController {
     
    @IBOutlet var firstCurrency: UITextField!
    @IBOutlet var secondCurrency: UITextField!
    
    @IBOutlet var firstChangeCurrency: UIButton!
    @IBOutlet var secondChangeCurrency: UIButton!
    
    @IBOutlet var replaceButton: UIButton!
    
    @IBOutlet var resultLabel: UILabel!
    
    private var convertData: ConvertCurrensy? 
    let activityIndicator = ActivityIndicator()
    
    var fromValue = "USD"
    var toValue = "RUB"
    var fromTextField: Double = 0
    
    var firstFieldNumber = ""
    var secondFieldNumber = ""
    
    var firstValueForReplace: Double?
    var secondValueForReplace: Double?
    
    var activeField = ""
    var checkReplace = false
       
    var completeUpdateDate: String = "" {
        didSet {
            let today = Date()
            let formatter1 = DateFormatter()
            formatter1.dateStyle = .short
            
            let formatter2 = DateFormatter()
            formatter2.timeStyle = .medium
            
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm E" //, d MMM y
           
            DispatchQueue.main.async {
                self.resultLabel.text = "Update Date: \(self.completeUpdateDate) \nLocal Time: \(formatter2.string(from: today)) \nConverted: \(self.convertData?.status ?? "")"
                // добавить в загрузку кэша, убрать отсюда
                
                self.view.layoutIfNeeded()
            }
        }
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        // если жест касания заблокировал некоторые другие прикосновения, добавить эту строку:
        // tapGesture.cancelsTouchesInView = false
        
        setupOutlets()
    }
      
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCurrency" {
            if let nextVC = segue.destination as? CurrencyListVC {
                nextVC.selectedButton = .firstButton
                nextVC.selectedDelegate = self
            }
        } else {
            if let nextVC = segue.destination as? CurrencyListVC {
                nextVC.selectedButton = .secondButton
                nextVC.selectedDelegate = self
            }
        }
    }
    
    @objc func dynamicTextFieldResult(textField: UITextField) {
        if textField == firstCurrency {
            activeField = "firstCurrency"
        } else if textField == secondCurrency {
            activeField = "secondCurrency"
        }
        
        checkReplace = false
        fetchingConvertData(textField: textField, activeReplace: false)
    }
     
    func replaceFields() {
        let tempFromValue = fromValue
        let tempToValue = toValue
        let tempNumberFirst = firstFieldNumber
        let tempNumberSecond = secondFieldNumber
        
        fetchingConvertData(textField: firstCurrency, activeReplace: true)
        firstChangeCurrency.setTitle(toValue, for: .normal) // toValue
        secondChangeCurrency.setTitle(fromValue, for: .normal) // fromValue
        fromValue = tempToValue
        toValue = tempFromValue
        firstFieldNumber = tempNumberFirst
        secondFieldNumber = tempNumberSecond
        checkReplace = false
    }
    
    @IBAction func replaceAction(_ sender: UIButton) {
        checkReplace = true
        replaceFields()
    }
     
    // MARK: - Fetching Convert Data
    
    func fetchingConvertData(textField: UITextField, activeReplace: Bool) {
        if activeReplace || checkReplace {
            fromTextField = Double(firstCurrency.text?.replacingOccurrences(of: ",", with: ".") ?? "textfield is empty") ?? 0.0
            
            // для юзера
            let specURL = "\(Constants.firstPartUrl)\(fromValue)&to=\(toValue)&amount=\(fromTextField)&apiKey=\(Constants.apiKey)&format=json"
            let request = NSMutableURLRequest(url: NSURL(string: specURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            // для получения обратной конвертации
            let reverse = "\(Constants.firstPartUrl)\(toValue)&to=\(fromValue)&amount=\(fromTextField)&apiKey=\(Constants.apiKey)&format=json"
            let reverseRequest = NSMutableURLRequest(url: NSURL(string: reverse)! as URL,
                                                     cachePolicy: .useProtocolCachePolicy,
                                                     timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = Constants.headers
            
            reverseRequest.httpMethod = "GET"
            reverseRequest.allHTTPHeaderFields = Constants.headers
            differentRequest(selectedRequest: reverseRequest, textField: firstCurrency, activeForReplace: true)
        } else {
            fromTextField = Double(textField.text?.replacingOccurrences(of: ",", with: ".") ?? "textfield is empty") ?? 0.0
            
            // для юзера
            let specURL = "\(Constants.firstPartUrl)\(fromValue)&to=\(toValue)&amount=\(fromTextField)&apiKey=\(Constants.apiKey)&format=json"
            let request = NSMutableURLRequest(url: NSURL(string: specURL)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            
            // для получения обратной конвертации
            let reverse = "\(Constants.firstPartUrl)\(toValue)&to=\(fromValue)&amount=\(fromTextField)&apiKey=\(Constants.apiKey)&format=json"
            let reverseRequest = NSMutableURLRequest(url: NSURL(string: reverse)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = Constants.headers
            
            reverseRequest.httpMethod = "GET"
            reverseRequest.allHTTPHeaderFields = Constants.headers
              
            switch activeField {
            case "firstCurrency":
                differentRequest(selectedRequest: request, textField: textField, activeForReplace: false)
            case "secondCurrency":
                differentRequest(selectedRequest: reverseRequest, textField: textField, activeForReplace: false)
            default:
                print("fetchingConvertData switch activeField default case")
            }
        }
    }
    
    // MARK: - Different Requests Methods
    
    func differentRequest(selectedRequest: NSMutableURLRequest, textField: UITextField, activeForReplace: Bool) {
        if activeForReplace || checkReplace {
            self.view.addSubview(activityIndicator)
            URLSession.shared.dataTask(with: selectedRequest as URLRequest) { (data, response, error) in
                guard let data = data else { return }
                do {
                    self.convertData = try JSONDecoder().decode(ConvertCurrensy.self, from: data)
                    self.convertData?.amount = String(self.fromTextField)
                    self.completeUpdateDate = self.convertData?.updatedDate ?? "\nnothing 1"
                    
                    DispatchQueue.main.async(execute: { [self]() -> Void in
                         
                            self.firstFieldNumber = self.convertData?.rates?.first?.value.rate_for_amount ?? "000"
                            let doubleFirstValue = Double(self.firstFieldNumber)
                            let roundDouble = floor(10000 * doubleFirstValue!) / 10000
                            self.activityIndicator.hide()
                            self.secondCurrency.text = String(roundDouble) //String(roundDouble)
                            
                            firstValueForReplace = roundDouble
                    })
                } catch let error {
                    print("Error serialization", error)
                }
            }.resume()
        } else {
            self.view.addSubview(activityIndicator)
            URLSession.shared.dataTask(with: selectedRequest as URLRequest) { (data, response, error) in
                guard let data = data else { return }
                do {
                    self.convertData = try JSONDecoder().decode(ConvertCurrensy.self, from: data)
                    self.convertData?.amount = String(self.fromTextField)
                    self.completeUpdateDate = self.convertData?.updatedDate ?? "\nnothing 1"
                     
                    DispatchQueue.main.async(execute: { [self]() -> Void in
                        if textField == self.firstCurrency {
                            self.firstFieldNumber = self.convertData?.rates?.first?.value.rate_for_amount ?? "000"
                            let doubleFirstValue = Double(self.firstFieldNumber)
                            let roundDouble = floor(10000 * doubleFirstValue!) / 10000
                            self.activityIndicator.hide()
                            self.secondCurrency.text = String(roundDouble) //String(roundDouble)
                            firstValueForReplace = roundDouble
                        } else if textField == self.secondCurrency {
                            self.secondFieldNumber = self.convertData?.rates?.first?.value.rate_for_amount ?? "000"
                            let doubleSecondValue = Double(self.secondFieldNumber)
                            let roundDouble = round(10000 * doubleSecondValue!) / 10000
                            self.activityIndicator.hide()
                            self.firstCurrency.text = String(roundDouble)
                            secondValueForReplace = roundDouble
                        } else {
                            print("no one textfield is active")
                        }
                    })
                } catch let error {
                    print("Error serialization", error.localizedDescription)
                }
            }.resume()
        }
    }
    
    @objc func checkingValues(textField: UITextField) {
        let checkValue = Double(textField.text?.replacingOccurrences(of: ",", with: ".") ?? "0.0") ?? 0.0
        
        if checkValue > 0.000001 {
            replaceButton.isHidden = false
        } else {
            replaceButton.isHidden = true
            resultLabel.text = ""
        }
    }
    
    @objc func checkingAfterClear(textField: UITextField) {
        let checkValue = Double(textField.text?.replacingOccurrences(of: ",", with: ".") ?? "0.0") ?? 0.0
        
        if checkValue == 0.0 {
            firstCurrency.text = ""
            secondCurrency.text = ""
            resultLabel.text = ""
            
            // self.showAlert(withTitle: "Ошибка", withMessage: "Значения должны быть больше 0.")
        }
    }
    
    func setupOutlets() {
        let textFields = [firstCurrency, secondCurrency]
        for textField in textFields {
            textField?.delegate = self
            textField?.keyboardType = .decimalPad
            textField?.clearButtonMode = .whileEditing
            textField?.textAlignment = .left
            textField?.autocorrectionType = .no
            textField?.addTarget(self, action: #selector(dynamicTextFieldResult(textField:)), for: .editingChanged)
            textField?.addTarget(self, action: #selector(checkingValues(textField:)), for: .editingChanged)
            textField?.addTarget(self, action: #selector(checkingAfterClear(textField:)), for: .editingDidEnd)
            if #available(iOS 11.0, *) {
                textField?.smartDashesType = .no
            } else {
                print("current version under ios 11")
            }
        }
        
        /// firstCurrency.placeholder = "У меня есть"
        /// secondCurrency.placeholder = "Хочу приобрести"
        
        firstCurrency.placeholder = "type here..."
        secondCurrency.placeholder = "or here..."
        
        let buttons = [firstChangeCurrency, secondChangeCurrency]
        for allButtons in buttons {
            allButtons?.layer.cornerRadius = 5
            allButtons?.clipsToBounds = true
        }
         
        resultLabel.numberOfLines = 3
        replaceButton.isHidden = true
        
        firstChangeCurrency.setTitle(fromValue, for: .normal)
        secondChangeCurrency.setTitle(toValue, for: .normal)
    }
    
    
    @IBAction func firstButton(_ sender: UIButton) {
        firstCurrency.text = ""
        secondCurrency.text = ""
        resultLabel.text = ""
        replaceButton.isHidden = true
    }
    
    @IBAction func secondButton(_ sender: UIButton) {
        firstCurrency.text = ""
        secondCurrency.text = ""
        resultLabel.text = ""
        replaceButton.isHidden = true
    }
}
   
 
