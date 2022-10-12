////
////  CurrencyTextField.swift
////  Converter
////
////  Created by Nikita Nesporov on 12.10.2022.
////
//
//import UIKit
//
//extension CurrencyTextField: UITextFieldDelegate {
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let lastCharacterInTextField = (textField.text ?? "").last
//
//        if string == "" && lastCharacterInTextField!.isNumber == false {
//            isSymbolOnRight = true
//        } else {
//            isSymbolOnRight = false
//        }
//        return true
//    }
//}
//
//struct Currency {
//   let locale: String
//   let amount: Double
//
//   var code: String? {
//       return formatter.currencyCode ?? "N/A"
//   }
//
//   var symbol: String? {
//       return formatter.currencySymbol ?? "N/A"
//   }
//
//   var format: String {
//       return formatter.string(from: NSNumber(value: self.amount))!
//   }
//
//   var formatter: NumberFormatter {
//       let numberFormatter = NumberFormatter()
//       numberFormatter.locale = Locale(identifier: self.locale)
//       numberFormatter.numberStyle = .decimal
//
//       return numberFormatter
//   }
//
//   // Used to populate the cells on the MainVC
//   func retrieveDetailedInformation() -> [(description: String, value: String)] {
//       let retrievedLocale = Locale(identifier: self.locale)
//
//       let informationToReturn = [
//           (description: "locale", value: self.locale),
//           (description: "code", value: self.code ?? "N/A"),
//           (description: "symbol", value: retrievedLocale.currencySymbol ?? "N/A"),
//           (description: "groupingSep", value: retrievedLocale.groupingSeparator ?? "N/A"),
//           (description: "decimalSeparator", value: retrievedLocale.decimalSeparator ?? "N/A")
//       ]
//
//       return informationToReturn
//   }
//
//   // Clean formatting from string
//   //not used anymore but left for example
//   //    static func cleanString(given formattedString: String) -> String {
//   //        var cleanedAmount = ""
//   //
//   //        for character in formattedString {
//   //            if character.isNumber {
//   //                cleanedAmount.append(character)
//   //            }
//   //        }
//   //
//   //        return cleanedAmount
//   //    }
//
//   // Use when saving to a database which only requires numeric values
//   static func formatCurrencyStringAsDouble(with localeString: String, for stringAmount: String) -> Double {
//       let numberFormatter = NumberFormatter()
//       numberFormatter.locale = Locale(identifier: localeString)
//       numberFormatter.numberStyle = .decimal
//
//       return numberFormatter.number(from: stringAmount) as! Double
//   }
//
//   // Currency Input Formatting - called when the user enters an amount in the
//   static func currencyInputFormatting(with localeString: String, for amount: String) -> String {
//       let numberFormatter = NumberFormatter()
//       numberFormatter.locale = Locale(identifier: localeString)
//       numberFormatter.numberStyle = .decimal
//
//       let numberOfDecimalPlaces = numberFormatter.maximumFractionDigits
//
//       //Clean the inputed string
//       var cleanedAmount = ""
//
//       for character in amount {
//           if character.isNumber {
//               cleanedAmount.append(character)
//           }
//       }
//
//       //Format the number based on number of decimal digits
//       if numberOfDecimalPlaces > 0 {
//           //ie. USD
//           let amountAsDouble = Double(cleanedAmount) ?? 0.0
//           return numberFormatter.string(from: amountAsDouble / 100.0 as NSNumber) ?? ""
//       } else {
//           //ie. JPY
//           let amountAsNumber = Double(cleanedAmount) as NSNumber?
//           return numberFormatter.string(from: amountAsNumber ?? 0) ?? ""
//       }
//   }
//}
//
//struct Currencies {
//   static func retrieveAllCurrencies() -> [Currency] {
//       var currencies = [Currency]()
//       for locale in Locale.availableIdentifiers {
//           let loopLocale = Locale(identifier: locale)
//           currencies.append(Currency(locale: loopLocale.identifier, amount: 1000.00))
//       }
//
//       return currencies.sorted(by: { $0.locale < $1.locale })
//   }
//}
//
//class CurrencyTextField: UITextField {
//    // Это закрытие/обратный вызов будет передавать отформатированную строку валюты и "чистую" цифровую сумму в UIViewController, ViewModel и т.д.
//    // каждый раз, когда пользователь изменяет содержимое текстового поля.
//    var passTextFieldText: ((String, Double?) -> Void)?
//
//    // Когда вы создаете экземпляр CurrencyTextField в UIViewController, вам нужно передать экземпляр валюты, чтобы текстовое поле имело локаль, currencyCode и т.д.
//    var currency: Currency? {
//        didSet {
//            guard let currency = currency else { return }
//            numberFormatter.currencyCode = currency.code
//            numberFormatter.locale = Locale(identifier: currency.locale)
//        }
//    }
//
//    //Used to send clean double value back
//    private var amountAsDouble: Double?
//
//    var startingValue: Double? {
//        didSet {
//            let nsNumber = NSNumber(value: startingValue ?? 0.0)
//            self.text = numberFormatter.string(from: nsNumber)
//        }
//    }
//
//    // Вот форматер чисел поля CurrencyTextField, помеченный как private, поскольку доступ к нему нужен только этому классу.
//    private lazy var numberFormatter: NumberFormatter = {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        //locale and currencyCode set in currency property observer
//        return formatter
//    }()
//
//    // Помните, я говорил, что некоторые валюты форматируются как целые числа (например, JPY)? Вычисляемое свойство будет возвращать либо 2, либо 0 в зависимости от запрашиваемой валюты. Это свойство также является ключевой частью этого текстового поля, поскольку оно определяет, нужно ли делить введенную сумму на 100.
//    private var roundingPlaces: Int {
//        return numberFormatter.maximumFractionDigits
//    }
//
//    // Это частное свойство помогает методу делегата shouldChangeCharactersIn range определить,
//    // справа или слева находится символ валюты. Это важно, когда пользователь нажимает кнопку удаления, а валюта находится справа.
//    private var isSymbolOnRight = false
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        //If using in SBs
//        setup()
//    }
//
//    // Этот метод настраивает текстовое поле, включая установку типа клавиатуры NumberPad. Это ограничивает пользователя от ввода букв вместо цифр.
//    private func setup() {
//        self.textAlignment = .right
//        self.keyboardType = .decimalPad
//        self.contentScaleFactor = 0.5
//        delegate = self
//
//        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//    }
//
//    //AFTER entered string is registered in the textField
//    @objc private func textFieldDidChange() {
//        updateTextField()
//    }
//
//    // Этот метод вызывается каждый раз, когда пользователь изменяет содержимое текстового поля.
//    // Этот метод перебирает символы введенной строки и удаляет все символы, не являющиеся числовыми.
//    // После того, как введенная сумма "очищена", класс определяет,
//    // отформатирована ли валюта как целое число (т.е. JPY) или с двумя десятичными знаками (т.е. USD).
//    // После этого и отформатированная строка суммы, и очищенное значение передаются обратно во ViewController с помощью обратного вызова passTextFieldText.
//    //Placed in separate method so when the user selects an account with a different currency, it will immediately be reflected
//    private func updateTextField() {
//        var cleanedAmount = ""
//
//        for character in self.text ?? "" {
//            if character.isNumber {
//                cleanedAmount.append(character)
//            }
//        }
//
////        if isSymbolOnRight {
////            cleanedAmount = String(cleanedAmount.dropLast())
////        }
//
//        //Format the number based on number of decimal digits
//        if self.roundingPlaces > 0 {
//            //ie. USD
//            let amount = Double(cleanedAmount) ?? 0.0
//            amountAsDouble = (amount / 100.0)
//            let amountAsString = numberFormatter.string(from: NSNumber(value: amountAsDouble ?? 0.0)) ?? ""
//
//            self.text = amountAsString
//        } else {
//            //ie. JPY
//            let amountAsNumber = Double(cleanedAmount) ?? 0.0
//            amountAsDouble = amountAsNumber
//            self.text = numberFormatter.string(from: NSNumber(value: amountAsNumber)) ?? ""
//        }
//
//        passTextFieldText?(self.text!, amountAsDouble)
//    }
//
//    // Я нашел этот метод на Stack Overflow для того, чтобы курсор всегда начинался в крайнем правом углу текстового поля, и отключил возможность его перемещения.
//    override func closestPosition(to point: CGPoint) -> UITextPosition? {
//        let beginning = self.beginningOfDocument
//        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
//        return end
//    }
//}
//
