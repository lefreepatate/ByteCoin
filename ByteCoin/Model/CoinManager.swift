//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let url = URL(string: baseURL + apiKey)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(apiKey)", forHTTPHeaderField: "X-CoinAPI-Key: ")
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let responseData = data {
                DispatchQueue.main.async {
                    if let rate = self.parseJson(responseData) {
                        self.delegate?.didUpdatePrice(price: rate, currency: currency)
                    }
                }
            }
        }
        task.resume()
    }
    
    func parseJson(_ data: Data) -> String? {
        let jsonDecoder = JSONDecoder()
        do {
            let rate = try jsonDecoder.decode(ExchangeRateModel.self, from: data)
            return rate.rateString
        } catch {
            return nil
        }
    }
}
